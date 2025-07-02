import '../notifiers/auth/auth_notifiers.dart';
import '../notifiers/theme/theme_notifiers.dart';
import '../repositories/auth_repository.dart';
import '../repositories/theme_repository.dart';

/// NotifierFactory following Dependency Inversion Principle
/// This allows for easy testing and different implementations
abstract class INotifierFactory {
  AuthNotifier createAuthNotifier();
  ThemeNotifier createThemeNotifier();
}

/// Production implementation of NotifierFactory
class NotifierFactory implements INotifierFactory {
  static final NotifierFactory _instance = NotifierFactory._internal();
  factory NotifierFactory() => _instance;
  NotifierFactory._internal();

  // Lazy initialization of repositories
  AuthRepositoryWithResult? _authRepository;
  ThemeRepository? _themeRepository;

  AuthRepositoryWithResult get authRepository {
    _authRepository ??= AuthRepositoryWithResult();
    return _authRepository!;
  }

  ThemeRepository get themeRepository {
    _themeRepository ??= ThemeRepository();
    return _themeRepository!;
  }

  @override
  AuthNotifier createAuthNotifier() {
    return AuthNotifier(authRepository: authRepository);
  }

  @override
  ThemeNotifier createThemeNotifier() {
    return ThemeNotifier(themeRepository: themeRepository);
  }

  /// Reset repositories (useful for testing)
  void reset() {
    _authRepository = null;
    _themeRepository = null;
  }
}

/// Test implementation of NotifierFactory for unit testing
class TestNotifierFactory implements INotifierFactory {
  final AuthRepositoryWithResult? mockAuthRepository;
  final ThemeRepository? mockThemeRepository;

  TestNotifierFactory({
    this.mockAuthRepository,
    this.mockThemeRepository,
  });

  @override
  AuthNotifier createAuthNotifier() {
    return AuthNotifier(authRepository: mockAuthRepository);
  }

  @override
  ThemeNotifier createThemeNotifier() {
    return ThemeNotifier(themeRepository: mockThemeRepository);
  }
}
