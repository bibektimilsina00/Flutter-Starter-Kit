/// Result wrapper for operations following Open/Closed Principle
abstract class Result<T> {
  const Result();
  
  /// Check if result is successful
  bool get isSuccess;
  
  /// Check if result is failure
  bool get isFailure;
  
  /// Get data if success, throws if failure
  T get data;
  
  /// Get error if failure, throws if success
  String get error;
  
  /// Map result to another type
  Result<U> map<U>(U Function(T) mapper);
  
  /// Handle result with callbacks
  U when<U>({
    required U Function(T data) success,
    required U Function(String error) failure,
  });
}

/// Success result implementation
class Success<T> extends Result<T> {
  final T _data;
  
  const Success(this._data);
  
  @override
  bool get isSuccess => true;
  
  @override
  bool get isFailure => false;
  
  @override
  T get data => _data;
  
  @override
  String get error => throw StateError('Success result has no error');
  
  @override
  Result<U> map<U>(U Function(T) mapper) {
    try {
      return Success(mapper(_data));
    } catch (e) {
      return Failure(e.toString());
    }
  }
  
  @override
  U when<U>({
    required U Function(T data) success,
    required U Function(String error) failure,
  }) {
    return success(_data);
  }
}

/// Failure result implementation
class Failure<T> extends Result<T> {
  final String _error;
  
  const Failure(this._error);
  
  @override
  bool get isSuccess => false;
  
  @override
  bool get isFailure => true;
  
  @override
  T get data => throw StateError('Failure result has no data');
  
  @override
  String get error => _error;
  
  @override
  Result<U> map<U>(U Function(T) mapper) {
    return Failure<U>(_error);
  }
  
  @override
  U when<U>({
    required U Function(T data) success,
    required U Function(String error) failure,
  }) {
    return failure(_error);
  }
}
