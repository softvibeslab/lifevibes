import 'package:equatable/equatable.dart';

class AvatarState extends Equatable {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final Map<String, dynamic> avatarData;
  final bool isSaved;

  const AvatarState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.avatarData = const {},
    this.isSaved = false,
  });

  AvatarState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    Map<String, dynamic>? avatarData,
    bool? isSaved,
  }) {
    return AvatarState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      avatarData: avatarData ?? this.avatarData,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        hasError,
        errorMessage,
        avatarData,
        isSaved,
      ];
}
