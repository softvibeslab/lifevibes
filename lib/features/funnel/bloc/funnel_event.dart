import 'package:equatable/equatable.dart';
import 'package:lifevibes/features/avatar/models/funnel_model.dart';

abstract class FunnelEvent extends Equatable {
  const FunnelEvent();

  @override
  List<Object?> get props => [];
}

class FunnelsLoadRequested extends FunnelEvent {
  final String userId;

  const FunnelsLoadRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FunnelCreateRequested extends FunnelEvent {
  final FunnelModel funnel;

  const FunnelCreateRequested(this.funnel);

  @override
  List<Object?> get props => [funnel];
}

class FunnelUpdateRequested extends FunnelEvent {
  final String funnelId;
  final Map<String, dynamic> updates;

  const FunnelUpdateRequested({
    required this.funnelId,
    required this.updates,
  });

  @override
  List<Object?> get props => [funnelId, updates];
}

class FunnelDeleteRequested extends FunnelEvent {
  final String funnelId;

  const FunnelDeleteRequested(this.funnelId);

  @override
  List<Object?> get props => [funnelId];
}

class FunnelStepUpdateRequested extends FunnelEvent {
  final String funnelId;
  final FunnelStep step;

  const FunnelStepUpdateRequested({
    required this.funnelId,
    required this.step,
  });

  @override
  List<Object?> get props => [funnelId, step];
}

class FunnelGenerateRequested extends FunnelEvent {
  final FunnelModel funnel;

  const FunnelGenerateRequested(this.funnel);

  @override
  List<Object?> get props => [funnel];
}
