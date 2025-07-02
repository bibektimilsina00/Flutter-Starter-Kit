import '../base_state.dart';

/// AuthState extending BaseState for consistency and better state management
class AuthState extends BaseState {
  final bool isLoggedIn;
  final String? userToken;
  final Map<String, dynamic>? userData;

  const AuthState({
    super.status,
    super.error,
    this.isLoggedIn = false,
    this.userToken,
    this.userData,
  });

  /// Factory constructor for initial state
  factory AuthState.initial() => const AuthState();

  /// Factory constructor for authenticated state
  factory AuthState.authenticated({
    required String token,
    Map<String, dynamic>? userData,
  }) => AuthState(
    status: Status.success,
    isLoggedIn: true,
    userToken: token,
    userData: userData,
  );

  /// Factory constructor for unauthenticated state
  factory AuthState.unauthenticated() => const AuthState(
    status: Status.success,
    isLoggedIn: false,
  );

  @override
  AuthState copyWith({
    Status? status,
    String? error,
    bool? isLoggedIn,
    String? userToken,
    Map<String, dynamic>? userData,
  }) {
    return AuthState(
      status: status ?? this.status,
      error: error ?? this.error,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userToken: userToken ?? this.userToken,
      userData: userData ?? this.userData,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    isLoggedIn,
    userToken,
    userData,
  ];
}
