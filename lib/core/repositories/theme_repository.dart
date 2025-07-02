import '../../../app/services/service_locator.dart';
import '../interfaces/i_repository.dart';

/// ThemeRepository implementing repository pattern
class ThemeRepository implements IThemeRepository {
  final _prefsService = ServiceLocator.sharedPrefs;
  static const String _themeKey = 'theme_mode';

  @override
  Future<String?> getThemeMode() async {
    try {
      return _prefsService.getString(_themeKey);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveThemeMode(String themeMode) async {
    await _prefsService.setString(_themeKey, themeMode);
  }

  /// Clear theme preferences
  Future<void> clearThemeMode() async {
    await _prefsService.remove(_themeKey);
  }
}
