import 'package:equatable/equatable.dart';

/// Onboarding states (Ritual de Origen)
abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

/// Loading state
class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

/// Values step state
class OnboardingValuesStep extends OnboardingState {
  final List<String> availableValues;
  final List<String> selectedValues;

  const OnboardingValuesStep({
    this.availableValues = const [],
    this.selectedValues = const [],
  });

  @override
  List<Object?> get props => [availableValues, selectedValues];
}

/// Passions step state
class OnboardingPassionsStep extends OnboardingState {
  final List<String> availablePassions;
  final List<String> selectedPassions;

  const OnboardingPassionsStep({
    this.availablePassions = const [],
    this.selectedPassions = const [],
  });

  @override
  List<Object?> get props => [availablePassions, selectedPassions];
}

/// Purpose step state
class OnboardingPurposeStep extends OnboardingState {
  final String purpose;

  const OnboardingPurposeStep({
    this.purpose = '',
  });

  @override
  List<Object?> get props => [purpose];
}

/// Completed state
class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted();
}

/// Error state
class OnboardingError extends OnboardingState {
  final String message;

  const OnboardingError(this.message);

  @override
  List<Object?> get props => [message];
}
