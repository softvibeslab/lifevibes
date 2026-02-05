import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../avatar/presentation/pages/avatar_creation_screen.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

/// Onboarding BLoC (Ritual de Origen)
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  // Available values for Tinder-swipe (El Espejo del Alma)
  static const List<String> availableValues = [
    'Creatividad',
    'Libertad',
    'Impacto',
    'Crecimiento',
    'Conexión',
    'Abundancia',
    'Autenticidad',
    'Innovación',
    'Sabiduría',
    'Bienestar',
    'Excelencia',
    'Comunidad',
    'Propósito',
    'Coraje',
    'Gratitud',
    'Equilibrio',
  ];

  // Available passions (La Forja del Superpoder)
  static const List<String> availablePassions = [
    'Tecnología',
    'Diseño',
    'Arte',
    'Negocios',
    'Educación',
    'Salud',
    'Deportes',
    'Música',
    'Escritura',
    'Fotografía',
    'Viajes',
    'Gastronomía',
    'Voluntariado',
    'Medio Ambiente',
    'Ciencia',
    'Entretenimiento',
  ];

  OnboardingBloc() : super(OnboardingInitial()) {
    on<OnboardingInitialize>(_onInitialize);
    on<OnboardingSaveValues>(_onSaveValues);
    on<OnboardingSavePassions>(_onSavePassions);
    on<OnboardingSavePurpose>(_onSavePurpose);
    on<OnboardingComplete>(_onComplete);
  }

  /// Initialize onboarding with available values and passions
  Future<void> _onInitialize(
    OnboardingInitialize event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());

    // Simulate loading
    await Future.delayed(const Duration(milliseconds: 500));

    emit(const OnboardingValuesStep(
      availableValues: availableValues,
      selectedValues: [],
    ));
  }

  /// Save selected values
  Future<void> _onSaveValues(
    OnboardingSaveValues event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());

    // Simulate saving
    await Future.delayed(const Duration(milliseconds: 300));

    emit(const OnboardingPassionsStep(
      availablePassions: availablePassions,
      selectedPassions: [],
    ));
  }

  /// Save selected passions
  Future<void> _onSavePassions(
    OnboardingSavePassions event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());

    // Simulate saving
    await Future.delayed(const Duration(milliseconds: 300));

    emit(const OnboardingPurposeStep(purpose: ''));
  }

  /// Save purpose statement
  Future<void> _onSavePurpose(
    OnboardingSavePurpose event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());

    // TODO: Integrate with PoppyAI to generate personalized purpose
    // For now, save the user's input

    await Future.delayed(const Duration(milliseconds: 300));

    emit(const OnboardingCompleted());
  }

  /// Complete onboarding and navigate to avatar creation
  Future<void> _onComplete(
    OnboardingComplete event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const OnboardingCompleted());
    
    // Navigate to avatar creation screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const AvatarCreationScreen(),
        ),
      );
    }
  }
}
