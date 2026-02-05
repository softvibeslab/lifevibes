import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifevibes/features/match/models/match_model.dart';
import 'match_event.dart';
import 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  MatchBloc(this._firestore, this._auth) : super(const MatchState()) {
    on<MatchLoadRequested>(_onMatchLoadRequested);
    on<MatchCalculateRequested>(_onMatchCalculateRequested);
    on<MatchAcceptRequested>(_onMatchAcceptRequested);
    on<MatchRejectRequested>(_onMatchRejectRequested);
    on<MatchSwipe>(_onMatchSwipe);
    on<MatchesRefreshRequested>(_onMatchesRefreshRequested);
  }

  Future<void> _onMatchLoadRequested(
    MatchLoadRequested event,
    Emitter<MatchState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, hasError: false));

    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        emit(state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: 'Usuario no autenticado',
        ));
        return;
      }

      // Load matches where current user is involved
      final matchesSnapshot = await _firestore
          .collection('matches')
          .where('userId1', isEqualTo: currentUserId)
          .where('status', whereIn: ['pending', 'accepted'])
          .orderBy('matchDate', descending: true)
          .limit(20)
          .get();

      final matchesSnapshot2 = await _firestore
          .collection('matches')
          .where('userId2', isEqualTo: currentUserId)
          .where('status', whereIn: ['pending', 'accepted'])
          .orderBy('matchDate', descending: true)
          .limit(20)
          .get();

      // Combine and deduplicate
      final allMatches = <MatchModel>[];
      final seenMatchIds = <String>{};

      for (var doc in [...matchesSnapshot.docs, ...matchesSnapshot2.docs]) {
        final data = doc.data();
        final matchId = doc.id;

        if (!seenMatchIds.contains(matchId)) {
          seenMatchIds.add(matchId);
          allMatches.add(MatchModel.fromJson({
            ...data,
            'matchId': matchId,
          }));
        }
      }

      // Categorize matches
      final pending = allMatches.where((m) => m.status == 'pending').toList();
      final accepted = allMatches.where((m) => m.status == 'accepted').toList();

      emit(state.copyWith(
        isLoading: false,
        pendingMatches: pending,
        acceptedMatches: accepted,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Error cargando matches: ${e.toString()}',
      ));
    }
  }

  Future<void> _onMatchCalculateRequested(
    MatchCalculateRequested event,
    Emitter<MatchState> emit,
  ) async {
    emit(state.copyWith(isCalculating: true, hasError: false));

    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) {
        emit(state.copyWith(
          isCalculating: false,
          hasError: true,
          errorMessage: 'Usuario no autenticado',
        ));
        return;
      }

      // Get current user profile
      final currentUserDoc = await _firestore
          .collection('users')
          .doc(currentUserId)
          .get();

      if (!currentUserDoc.exists) {
        emit(state.copyWith(
          isCalculating: false,
          hasError: true,
          errorMessage: 'Perfil no encontrado',
        ));
        return;
      }

      final currentUserData = currentUserDoc.data();
      final currentUser = UserProfile(
        userId: currentUserId,
        displayName: currentUserData?['displayName'] ?? '',
        photoURL: currentUserData?['photoURL'],
        level: currentUserData?['level'] ?? 1,
        currentPhase: currentUserData?['currentPhase'] ?? 'SER',
        values: List<String>.from(currentUserData?['values'] ?? []),
        purpose: currentUserData?['purpose'] ?? '',
        skills: List<String>.from(currentUserData?['skills'] ?? []),
        interests: List<String>.from(currentUserData?['interests'] ?? []),
      );

      // Get target user profile
      final targetUserDoc = await _firestore
          .collection('users')
          .doc(event.targetUserId)
          .get();

      if (!targetUserDoc.exists) {
        emit(state.copyWith(
          isCalculating: false,
          hasError: true,
          errorMessage: 'Usuario objetivo no encontrado',
        ));
        return;
      }

      final targetUserData = targetUserDoc.data();
      final targetUser = UserProfile(
        userId: event.targetUserId,
        displayName: targetUserData?['displayName'] ?? '',
        photoURL: targetUserData?['photoURL'],
        level: targetUserData?['level'] ?? 1,
        currentPhase: targetUserData?['currentPhase'] ?? 'SER',
        values: List<String>.from(targetUserData?['values'] ?? []),
        purpose: targetUserData?['purpose'] ?? '',
        skills: List<String>.from(targetUserData?['skills'] ?? []),
        interests: List<String>.from(targetUserData?['interests'] ?? []),
      );

      // Calculate match using Softvibes algorithm
      final breakdown = SoftvibesMatchAlgorithm.calculateMatch(
        user1: currentUser,
        user2: targetUser,
      );

      final matchScore = breakdown.totalScore;

      // Create match ID (sorted user IDs for consistency)
      final matchId = [currentUserId, event.targetUserId]..sort();

      // Save match to Firestore
      await _firestore.collection('matches').doc(matchId.join('_')).set({
        'userId1': currentUserId,
        'userId2': event.targetUserId,
        'matchScore': matchScore,
        'matchDate': FieldValue.serverTimestamp(),
        'status': 'pending',
        'breakdown': breakdown.toJson(),
      }, SetOptions(merge: true));

      emit(state.copyWith(
        isCalculating: false,
        pendingMatches: [
          ...state.pendingMatches,
          MatchModel(
            matchId: matchId.join('_'),
            userId1: currentUserId,
            userId2: event.targetUserId,
            matchScore: matchScore,
            matchDate: DateTime.now(),
            status: 'pending',
            breakdown: breakdown,
          ),
        ],
      ));
    } catch (e) {
      emit(state.copyWith(
        isCalculating: false,
        hasError: true,
        errorMessage: 'Error calculando match: ${e.toString()}',
      ));
    }
  }

  Future<void> _onMatchAcceptRequested(
    MatchAcceptRequested event,
    Emitter<MatchState> emit,
  ) async {
    try {
      await _firestore
          .collection('matches')
          .doc(event.matchId)
          .update({'status': 'accepted'});

      // Move match from pending to accepted
      final updatedPending = state.pendingMatches
          .where((m) => m.matchId != event.matchId)
          .toList();

      final matchToAccept = state.pendingMatches
          .firstWhere((m) => m.matchId == event.matchId);

      emit(state.copyWith(
        pendingMatches: updatedPending,
        acceptedMatches: [
          ...state.acceptedMatches,
          matchToAccept.copyWith(status: 'accepted'),
        ],
      ));
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error aceptando match: ${e.toString()}',
      ));
    }
  }

  Future<void> _onMatchRejectRequested(
    MatchRejectRequested event,
    Emitter<MatchState> emit,
  ) async {
    try {
      await _firestore
          .collection('matches')
          .doc(event.matchId)
          .update({'status': 'rejected'});

      // Remove match from pending
      final updatedPending = state.pendingMatches
          .where((m) => m.matchId != event.matchId)
          .toList();

      emit(state.copyWith(
        pendingMatches: updatedPending,
        rejectedMatches: [
          ...state.rejectedMatches,
          state.pendingMatches
              .firstWhere((m) => m.matchId == event.matchId)
              .copyWith(status: 'rejected'),
        ],
      ));
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error rechazando match: ${e.toString()}',
      ));
    }
  }

  Future<void> _onMatchSwipe(
    MatchSwipe event,
    Emitter<MatchState> emit,
  ) async {
    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) return;

      if (event.isLike) {
        // Calculate match
        add(MatchCalculateRequested(event.targetUserId));
      } else {
        // Record rejection (pass)
        final matchId = [currentUserId, event.targetUserId]..sort();
        await _firestore.collection('matches').doc(matchId.join('_')).set({
          'userId1': currentUserId,
          'userId2': event.targetUserId,
          'matchScore': 0,
          'matchDate': FieldValue.serverTimestamp(),
          'status': 'rejected',
        }, SetOptions(merge: true));
      }
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error en swipe: ${e.toString()}',
      ));
    }
  }

  Future<void> _onMatchesRefreshRequested(
    MatchesRefreshRequested event,
    Emitter<MatchState> emit,
  ) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;
    add(MatchLoadRequested(currentUserId));
  }
}
