import 'dart:async';
import 'package:flutter/foundation.dart';

/// Mixin for notifier lifecycle management
mixin NotifierLifecycleMixin {
  bool _isDisposed = false;
  
  bool get isDisposed => _isDisposed;
  
  void markAsDisposed() {
    _isDisposed = true;
  }
  
  void ensureNotDisposed() {
    if (_isDisposed) {
      throw StateError('Notifier has been disposed');
    }
  }
}

/// Mixin for debouncing operations
mixin DebounceMixin {
  final Map<String, Timer> _timers = {};
  
  void debounce(String key, Duration duration, VoidCallback callback) {
    _timers[key]?.cancel();
    _timers[key] = Timer(duration, callback);
  }
  
  void cancelDebounce(String key) {
    _timers[key]?.cancel();
    _timers.remove(key);
  }
  
  void cancelAllDebounces() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }
}

/// Mixin for retry logic
mixin RetryMixin {
  Future<T> withRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          rethrow;
        }
        await Future.delayed(delay * attempts);
      }
    }
    
    throw StateError('Max retries exceeded');
  }
}
