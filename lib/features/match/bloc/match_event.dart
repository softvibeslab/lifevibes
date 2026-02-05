import 'package:equatable/equatable.dart';
import 'package:lifevibes/features/avatar/models/match_model.dart';

abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object?> get props => [];
}

class MatchLoadRequested extends MatchEvent {
  final String userId;

  const MatchLoadRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class MatchCalculateRequested extends MatchEvent {
  final String targetUserId;

  const MatchCalculateRequested(this.targetUserId);

  @override
  List<Object?> get props => [targetUserId];
}

class MatchAcceptRequested extends MatchEvent {
  final String matchId;

  const MatchAcceptRequested(this.matchId);

  @override
  List<Object?> get props => [matchId];
}

class MatchRejectRequested extends MatchEvent {
  final String matchId;

  const MatchRejectRequested(this.matchId);

  @override
  List<Object?> get props => [matchId];
}

class MatchSwipe extends MatchEvent {
  final String targetUserId;
  final bool isLike; // true = like (swipe right), false = pass (swipe left)

  const MatchSwipe({
    required this.targetUserId,
    required this.isLike,
  });

  @override
  List<Object?> get props => [targetUserId, isLike];
}

class MatchesRefreshRequested extends MatchEvent {
  const MatchesRefreshRequested();
}
