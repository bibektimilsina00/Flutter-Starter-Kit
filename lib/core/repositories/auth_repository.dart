import 'package:dio/dio.dart';
import 'package:flutter_starter_kit/app/utils/logger_utils.dart';

import '../../app/routes/api_routes.dart';
import '../../app/services/service_locator.dart';
import '../notifiers/interfaces/i_repository.dart';
import '../notifiers/common/result.dart';

/// AuthRepository implementing the repository interface
class AuthRepository implements IAuthRepository {
  final _apiClient = ServiceLocator.apiClient;

  @override
  Future<void> login(String email, String password) async {
    try {
      final response = await _apiClient.post(ApiRoutes.login, data: {
        'email': email,
        'password': password,
      });
      
      // Handle successful response
      if (response.statusCode == 200) {
        final token = response.data['token'] as String?;
        if (token != null) {
          await _saveToken(token);
        }
      }
    } on DioException catch (error) {
      logger.e('Login failed: ${error.message}');
      rethrow;
    } catch (error) {
      logger.e('Unexpected login error: $error');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiRoutes.logout);
      await _clearToken();
    } on DioException catch (error) {
      logger.e('Logout failed: ${error.message}');
      // Don't rethrow - we still want to clear local token
      await _clearToken();
    } catch (error) {
      logger.e('Unexpected logout error: $error');
      await _clearToken();
    }
  }

  @override
  Future<void> register(String email, String password) async {
    try {
      final response = await _apiClient.post(ApiRoutes.register, data: {
        'email': email,
        'password': password,
      });
      
      if (response.statusCode == 201) {
        final token = response.data['token'] as String?;
        if (token != null) {
          await _saveToken(token);
        }
      }
    } on DioException catch (error) {
      logger.e('Registration failed: ${error.message}');
      rethrow;
    } catch (error) {
      logger.e('Unexpected registration error: $error');
      rethrow;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<String?> getToken() async {
    try {
      return ServiceLocator.sharedPrefs.getString('auth_token');
    } catch (error) {
      logger.e('Error getting token: $error');
      return null;
    }
  }

  @override
  Future<void> refreshToken() async {
    try {
      final response = await _apiClient.post(ApiRoutes.refreshToken);
      
      if (response.statusCode == 200) {
        final newToken = response.data['token'] as String?;
        if (newToken != null) {
          await _saveToken(newToken);
        }
      }
    } on DioException catch (error) {
      logger.e('Token refresh failed: ${error.message}');
      rethrow;
    } catch (error) {
      logger.e('Unexpected token refresh error: $error');
      rethrow;
    }
  }

  /// Private method to save token securely
  Future<void> _saveToken(String token) async {
    await ServiceLocator.sharedPrefs.setString('auth_token', token);
  }

  /// Private method to clear token
  Future<void> _clearToken() async {
    await ServiceLocator.sharedPrefs.remove('auth_token');
  }
}

/// Enhanced auth repository with result wrapper
class AuthRepositoryWithResult extends AuthRepository {
  /// Login with result wrapper
  Future<Result<String>> loginWithResult(String email, String password) async {
    try {
      await login(email, password);
      final token = await getToken();
      if (token != null) {
        return Success(token);
      } else {
        return const Failure('Login successful but no token received');
      }
    } catch (e) {
      return Failure(e.toString());
    }
  }

  /// Register with result wrapper
  Future<Result<String>> registerWithResult(String email, String password) async {
    try {
      await register(email, password);
      final token = await getToken();
      if (token != null) {
        return Success(token);
      } else {
        return const Failure('Registration successful but no token received');
      }
    } catch (e) {
      return Failure(e.toString());
    }
  }

  /// Logout with result wrapper
  Future<Result<void>> logoutWithResult() async {
    try {
      await logout();
      return const Success(null);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
