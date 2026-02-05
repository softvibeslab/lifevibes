import 'package:equatable/equatable.dart';
import '../models/funnel_model.dart';

class FunnelState extends Equatable {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final String? message;
  final List<FunnelModel> funnels;
  final bool isGenerating;
  final FunnelModel? currentFunnel;

  const FunnelState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.message,
    this.funnels = const [],
    this.isGenerating = false,
    this.currentFunnel,
  });

  FunnelState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    String? message,
    List<FunnelModel>? funnels,
    bool? isGenerating,
    FunnelModel? currentFunnel,
  }) {
    return FunnelState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      message: message,
      funnels: funnels ?? this.funnels,
      isGenerating: isGenerating ?? this.isGenerating,
      currentFunnel: currentFunnel ?? this.currentFunnel,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        hasError,
        errorMessage,
        message,
        funnels,
        isGenerating,
        currentFunnel,
      ];
}
