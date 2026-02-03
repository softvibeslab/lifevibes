import 'package:equatable/equatable.dart';

/// Onboarding events (Ritual de Origen)
abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize onboarding
class OnboardingInitialize extends OnboardingEvent {
  const OnboardingInitialize();
}

/// Save values selected
class OnboardingSaveValues extends OnboardingEvent {
  final List<String> values;

  const OnboardingSaveValues(this.values);

  @override
  List<Object?> get props => [values];
}

/// Save passions selected
class OnboardingSavePassions extends OnboardingEvent {
  final List<String> passions;

  const OnboardingSavePassions(this.passions);

  @override
  List<Object?> get props => [passions];
}

/// Save purpose statement
class OnboardingSavePurpose extends OnboardingEvent {
  final String purpose;

  const OnboardingSavePurpose(this.purpose);

  @override
  List<Object?> get props => [purpose];
}

/// Complete onboarding
class OnboardingComplete extends OnboardingEvent {
  const OnboardingComplete();
}
