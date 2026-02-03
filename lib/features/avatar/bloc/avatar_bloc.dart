import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'avatar_event.dart';
import 'avatar_state.dart';

class AvatarBloc extends Bloc<AvatarEvent, AvatarState> {
  final FirebaseFirestore _firestore;

  // Default avatar data for new users
  static const Map<String, dynamic> _defaultAvatar = {
    'faceType': 'round',
    'eyeStyle': 'normal',
    'eyeColor': '#4A5568',
    'mouthStyle': 'smile',
    'hairStyle': 'short',
    'hairColor': '#1A202C',
    'skinColor': '#FBD38D',
    'outfit': 'casual',
    'accessories': [],
    'level': 1,
    'xp': 0,
    'badges': [],
    'lastUpdated': null,
  };

  AvatarBloc(this._firestore) : super(const AvatarState()) {
    on<AvatarLoadRequested>(_onAvatarLoadRequested);
    on<AvatarUpdated>(_onAvatarUpdated);
    on<AvatarResetRequested>(_onAvatarResetRequested);
  }

  Future<void> _onAvatarLoadRequested(
    AvatarLoadRequested event,
    Emitter<AvatarState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, hasError: false));

    try {
      final docSnapshot =
          await _firestore.collection('avatars').doc(event.userId).get();

      if (docSnapshot.exists) {
        final avatarData = docSnapshot.data() as Map<String, dynamic>;
        emit(state.copyWith(
          isLoading: false,
          avatarData: avatarData,
        ));
      } else {
        // Create default avatar for new user
        await _firestore
            .collection('avatars')
            .doc(event.userId)
            .set(_defaultAvatar);

        emit(state.copyWith(
          isLoading: false,
          avatarData: Map.from(_defaultAvatar),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Error loading avatar: ${e.toString()}',
      ));
    }
  }

  Future<void> _onAvatarUpdated(
    AvatarUpdated event,
    Emitter<AvatarState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, hasError: false));

    try {
      final updatedData = {
        ...state.avatarData,
        ...event.avatarData,
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('avatars')
          .doc(event.userId)
          .set(updatedData, SetOptions(merge: true));

      emit(state.copyWith(
        isLoading: false,
        avatarData: updatedData,
        isSaved: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Error updating avatar: ${e.toString()}',
      ));
    }
  }

  Future<void> _onAvatarResetRequested(
    AvatarResetRequested event,
    Emitter<AvatarState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, hasError: false));

    try {
      await _firestore
          .collection('avatars')
          .doc(event.userId)
          .set(_defaultAvatar);

      emit(state.copyWith(
        isLoading: false,
        avatarData: Map.from(_defaultAvatar),
        isSaved: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Error resetting avatar: ${e.toString()}',
      ));
    }
  }
}
