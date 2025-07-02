import 'package:flutter/foundation.dart';

import '../base_notifier.dart';
import '../../repositories/auth_repository.dart';
import 'auth_state.dart';

/// AuthNotifier following SOLID principles with dependency injection
class AuthNotifier extends BaseNotifier<AuthState> {
  final AuthRepositoryWithResult _authRepository;

  AuthNotifier({
    AuthRepositoryWithResult? authRepository,
  }) : _authRepository = authRepository ?? AuthRepositoryWithResult(),
        super(AuthState.initial());

  @override
  AuthState createInitialState() => AuthState.initial();

  /// Login with enhanced error handling and validation
  Future<void> login(String email, String password) async {
    if (!validateBeforeOperation()) return;
    
    if (!_validateLoginInput(email, password)) {
      setFailure('Please provide valid email and password');
      return;
    }

    await handleAsyncOperation(() async {
      final result = await _authRepository.loginWithResult(email, password);
      
      result.when(
        success: (token) {
          final newState = AuthState.authenticated(token: token);
          updateState(newState);
        },
        failure: (error) {
          throw Exception(error);
        },
      );
    });
  }

  /// Register with enhanced validation
  Future<void> register(String email, String password) async {
    if (!validateBeforeOperation()) return;
    
    if (!_validateRegistrationInput(email, password)) {
      setFailure('Please provide valid email and password');
      return;
    }

    await handleAsyncOperation(() async {
      final result = await _authRepository.registerWithResult(email, password);
      
      result.when(
        success: (token) {
          final newState = AuthState.authenticated(token: token);
          updateState(newState);
        },
        failure: (error) {
          throw Exception(error);
        },
      );
    });
  }

  /// Logout with proper cleanup
  Future<void> logout() async {
    if (!canPerformOperation()) return;

    await handleAsyncOperation(() async {
      final result = await _authRepository.logoutWithResult();
      
      result.when(
        success: (_) {
          final newState = AuthState.unauthenticated();
          updateState(newState);
        },
        failure: (error) {
          // Still update state to logged out even if API call fails
          final newState = AuthState.unauthenticated();
          updateState(newState);
          if (kDebugMode) {
            print('Logout API failed but user logged out locally: $error');
          }
        },
      );
    });
  }

  /// Check authentication status on app start
  Future<void> checkAuthenticationStatus() async {
    await handleAsyncOperation(() async {
      final isAuthenticated = await _authRepository.isAuthenticated();
      
      if (isAuthenticated) {
        final token = await _authRepository.getToken();
        if (token != null) {
          final newState = AuthState.authenticated(token: token);
          updateState(newState);
        } else {
          final newState = AuthState.unauthenticated();
          updateState(newState);
        }
      } else {
        final newState = AuthState.unauthenticated();
        updateState(newState);
      }
    });
  }

  /// Refresh authentication token
  Future<void> refreshAuthToken() async {
    if (!canPerformOperation()) return;

    await handleAsyncOperation(() async {
      await _authRepository.refreshToken();
      final token = await _authRepository.getToken();
      
      if (token != null) {
        final newState = state.copyWith(userToken: token);
        updateState(newState);
      } else {
        final newState = AuthState.unauthenticated();
        updateState(newState);
      }
    }, showLoading: false);
  }

  /// Validate login input
  bool _validateLoginInput(String email, String password) {
    return email.trim().isNotEmpty && 
           password.isNotEmpty && 
           _isValidEmail(email);
  }

  /// Validate registration input  
  bool _validateRegistrationInput(String email, String password) {
    return email.trim().isNotEmpty && 
           password.length >= 6 && 
           _isValidEmail(email);
  }

  /// Basic email validation
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  bool validateBeforeOperation() {
    return !state.isLoading;
  }

  /// Convenience getters
  bool get isLoggedIn => state.isLoggedIn;
  String? get userToken => state.userToken;
  Map<String, dynamic>? get userData => state.userData;
}
