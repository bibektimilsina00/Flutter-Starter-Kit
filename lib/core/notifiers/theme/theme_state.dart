import '../base_state.dart';

/// ThemeState extending BaseState for consistency
class ThemeState extends BaseState {
  final String themeMode;

  const ThemeState({
    super.status,
    super.error,
    this.themeMode = 'system',
  });

  /// Factory constructor for initial state
  factory ThemeState.initial() => const ThemeState();

  @override
  ThemeState copyWith({
    Status? status,
    String? error,
    String? themeMode,
  }) {
    return ThemeState(
      status: status ?? this.status,
      error: error ?? this.error,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    themeMode,
  ];
}

