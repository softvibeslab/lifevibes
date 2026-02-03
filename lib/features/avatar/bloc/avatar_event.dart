import 'package:equatable/equatable.dart';

abstract class AvatarEvent extends Equatable {
  const AvatarEvent();

  @override
  List<Object> get props => [];
}

class AvatarLoadRequested extends AvatarEvent {
  final String userId;

  const AvatarLoadRequested(this.userId);

  @override
  List<Object> get props => [userId];
}

class AvatarUpdated extends AvatarEvent {
  final String userId;
  final Map<String, dynamic> avatarData;

  const AvatarUpdated({
    required this.userId,
    required this.avatarData,
  });

  @override
  List<Object> get props => [userId, avatarData];
}

class AvatarResetRequested extends AvatarEvent {
  final String userId;

  const AvatarResetRequested(this.userId);

  @override
  List<Object> get props => [userId];
}
