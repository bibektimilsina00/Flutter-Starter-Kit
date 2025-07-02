import 'package:flutter/material.dart';

import '../../../app/enum/enum.dart';
import '../base_notifier.dart';
import '../../repositories/theme_repository.dart';
import 'theme_state.dart';

/// ThemeNotifier following SOLID principles with dependency injection
class ThemeNotifier extends BaseNotifier<ThemeState> {
  final ThemeRepository _themeRepository;

  ThemeNotifier({
    ThemeRepository? themeRepository,
  }) : _themeRepository = themeRepository ?? ThemeRepository(),
        super(ThemeState.initial()) {
    _loadTheme();
  }

  @override
  ThemeState createInitialState() => ThemeState.initial();

  /// Get current theme mode as enum
  AppThemeMode get themeMode {
    return AppThemeMode.fromJson(state.themeMode);
  }

  /// Set theme mode with validation and persistence
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (!validateBeforeOperation()) return;

    await handleAsyncOperation(() async {
      await _themeRepository.saveThemeMode(mode.toJson());
      final newState = state.copyWith(themeMode: mode.toJson());
      updateState(newState);
    }, showLoading: false);
  }

  /// Load theme from storage
  Future<void> _loadTheme() async {
    await handleAsyncOperation(() async {
      final savedTheme = await _themeRepository.getThemeMode();
      final themeMode = savedTheme ?? AppThemeMode.system.toJson();
      
      final newState = state.copyWith(themeMode: themeMode);
      updateState(newState);
    }, showLoading: false);
  }

  /// Reset theme to system default
  Future<void> resetToSystemTheme() async {
    await setThemeMode(AppThemeMode.system);
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final currentMode = themeMode;
    AppThemeMode newMode;
    
    switch (currentMode) {
      case AppThemeMode.light:
        newMode = AppThemeMode.dark;
        break;
      case AppThemeMode.dark:
        newMode = AppThemeMode.light;
        break;
      case AppThemeMode.system:
        // When system, default to dark
        newMode = AppThemeMode.dark;
        break;
    }
    
    await setThemeMode(newMode);
  }

  /// Check if current theme is dark
  bool get isDarkMode => themeMode == AppThemeMode.dark;

  /// Check if current theme is light
  bool get isLightMode => themeMode == AppThemeMode.light;

  /// Check if using system theme
  bool get isSystemMode => themeMode == AppThemeMode.system;

  @override
  bool validateBeforeOperation() {
    return !state.isLoading;
  }
}
