import 'package:equatable/equatable.dart';
import 'package:lifevibes/features/avatar/models/match_model.dart';

class MatchState extends Equatable {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final List<MatchModel> pendingMatches;
  final List<MatchModel> acceptedMatches;
  final List<MatchModel> rejectedMatches;
  final List<UserProfile> potentialMatches;
  final bool isCalculating;

  const MatchState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.pendingMatches = const [],
    this.acceptedMatches = const [],
    this.rejectedMatches = const [],
    this.potentialMatches = const [],
    this.isCalculating = false,
  });

  MatchState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    List<MatchModel>? pendingMatches,
    List<MatchModel>? acceptedMatches,
    List<MatchModel>? rejectedMatches,
    List<UserProfile>? potentialMatches,
    bool? isCalculating,
  }) {
    return MatchState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      pendingMatches: pendingMatches ?? this.pendingMatches,
      acceptedMatches: acceptedMatches ?? this.acceptedMatches,
      rejectedMatches: rejectedMatches ?? this.rejectedMatches,
      potentialMatches: potentialMatches ?? this.potentialMatches,
      isCalculating: isCalculating ?? this.isCalculating,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        hasError,
        errorMessage,
        pendingMatches,
        acceptedMatches,
        rejectedMatches,
        potentialMatches,
        isCalculating,
      ];
}
