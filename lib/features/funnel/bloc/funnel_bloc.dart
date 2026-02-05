import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/funnel_model.dart';
import 'funnel_event.dart';
import 'funnel_state.dart';

class FunnelBloc extends Bloc<FunnelEvent, FunnelState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FunnelBloc(this._firestore, this._auth) : super(const FunnelState()) {
    on<FunnelsLoadRequested>(_onFunnelsLoadRequested);
    on<FunnelCreateRequested>(_onFunnelCreateRequested);
    on<FunnelUpdateRequested>(_onFunnelUpdateRequested);
    on<FunnelDeleteRequested>(_onFunnelDeleteRequested);
    on<FunnelStepUpdateRequested>(_onFunnelStepUpdateRequested);
    on<FunnelGenerateRequested>(_onFunnelGenerateRequested);
  }

  Future<void> _onFunnelsLoadRequested(
    FunnelsLoadRequested event,
    Emitter<FunnelState> emit,
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

      // Load user's funnels
      final funnelsSnapshot = await _firestore
          .collection('funnels')
          .where('userId', isEqualTo: currentUserId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      // Parse funnels
      final funnels = funnelsSnapshot.docs.map((doc) {
        final data = doc.data();
        return FunnelModel.fromJson({
          ...data,
          'funnelId': doc.id,
        });
      }).toList();

      emit(state.copyWith(
        isLoading: false,
        funnels: funnels,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Error cargando funnels: ${e.toString()}',
      ));
    }
  }

  Future<void> _onFunnelCreateRequested(
    FunnelCreateRequested event,
    Emitter<FunnelState> emit,
  ) async {
    try {
      final currentUserId = _auth.currentUser?.uid;
      if (currentUserId == null) return;

      final newFunnelRef = await _firestore.collection('funnels').add({
        'userId': currentUserId,
        'title': event.funnel.title,
        'description': event.funnel.description,
        'type': event.funnel.type.name,
        'status': event.funnel.status.name,
        'steps': event.funnel.steps.map((s) => s.toJson()).toList(),
        'metrics': event.funnel.metrics.toJson(),
        'targetProduct': event.funnel.targetProduct,
        'leadMagnet': event.funnel.leadMagnet,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Get the created funnel
      final newFunnelDoc = await newFunnelRef.get();
      final newFunnel = FunnelModel.fromJson({
        ...newFunnelDoc.data() as Map<String, dynamic>,
        'funnelId': newFunnelDoc.id,
      });

      emit(state.copyWith(
        funnels: [newFunnel, ...state.funnels],
      ));

      ScaffoldMessenger.of(context).mounted
          ? ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✨ Funnel creado exitosamente'),
                backgroundColor: Colors.green,
              ),
            )
          : null;
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error creando funnel: ${e.toString()}',
      ));
    }
  }

  Future<void> _onFunnelUpdateRequested(
    FunnelUpdateRequested event,
    Emitter<FunnelState> emit,
  ) async {
    try {
      await _firestore
          .collection('funnels')
          .doc(event.funnelId)
          .update({
        ...event.updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local state
      final updatedFunnels = state.funnels.map((f) {
        if (f.funnelId == event.funnelId) {
          return f.copyWith(
            ...event.updates,
            updatedAt: DateTime.now(),
          );
        }
        return f;
      }).toList();

      emit(state.copyWith(funnels: updatedFunnels));
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error actualizando funnel: ${e.toString()}',
      ));
    }
  }

  Future<void> _onFunnelDeleteRequested(
    FunnelDeleteRequested event,
    Emitter<FunnelState> emit,
  ) async {
    try {
      await _firestore.collection('funnels').doc(event.funnelId).delete();

      // Remove from local state
      final updatedFunnels = state.funnels
          .where((f) => f.funnelId != event.funnelId)
          .toList();

      emit(state.copyWith(funnels: updatedFunnels));

      ScaffoldMessenger.of(context).mounted
          ? ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🗑️ Funnel eliminado'),
                backgroundColor: Colors.red,
              ),
            )
          : null;
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error eliminando funnel: ${e.toString()}',
      ));
    }
  }

  Future<void> _onFunnelStepUpdateRequested(
    FunnelStepUpdateRequested event,
    Emitter<FunnelState> emit,
  ) async {
    try {
      final funnel = state.funnels.firstWhere(
        (f) => f.funnelId == event.funnelId,
      );

      final updatedSteps = funnel.steps.map((step) {
        if (step.stepId == event.step.stepId) {
          return event.step;
        }
        return step;
      }).toList();

      await _firestore
          .collection('funnels')
          .doc(event.funnelId)
          .update({
        'steps': updatedSteps.map((s) => s.toJson()).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Update local state
      final updatedFunnels = state.funnels.map((f) {
        if (f.funnelId == event.funnelId) {
          return f.copyWith(steps: updatedSteps);
        }
        return f;
      }).toList();

      emit(state.copyWith(funnels: updatedFunnels));
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: 'Error actualizando paso: ${e.toString()}',
      ));
    }
  }

  Future<void> _onFunnelGenerateRequested(
    FunnelGenerateRequested event,
    Emitter<FunnelState> emit,
  ) async {
    emit(state.copyWith(isGenerating: true, hasError: false));

    try {
      // Simulate AI generation with template
      await Future.delayed(const Duration(seconds: 2));

      final generatedFunnel = FunnelTemplates.webinarTemplate.copyWith(
        funnelId: '',
        userId: _auth.currentUser?.uid ?? '',
        title: event.funnel.title,
        description: event.funnel.description,
        createdAt: DateTime.now(),
      );

      emit(state.copyWith(
        isGenerating: false,
        currentFunnel: generatedFunnel,
      ));
    } catch (e) {
      emit(state.copyWith(
        isGenerating: false,
        hasError: true,
        errorMessage: 'Error generando funnel: ${e.toString()}',
      ));
    }
  }
}

// Get context for ScaffoldMessenger
extension on BuildContext {
  bool get mounted {
    try {
      widget;
      return true;
    } catch (e) {
      return false;
    }
  }
}
