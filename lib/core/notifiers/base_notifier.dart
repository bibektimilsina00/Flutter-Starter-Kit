import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/app/exceptions/app_exception.dart';

import 'base_state.dart';
import 'interfaces/i_notifier.dart';
import 'common/result.dart';

/// Enhanced base notifier implementing multiple interfaces for better separation of concerns
abstract class BaseNotifier<T extends BaseState> extends ChangeNotifier
    implements INotifier<T>, IAsyncOperationHandler, ILoadingStateManager {
  T _state;

  BaseNotifier(this._state);

  @override
  T get state => _state;

  @override
  void updateState(T newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  /// Protected method for subclasses to update state safely
  @protected
  void setState(T newState) {
    updateState(newState);
  }

  @override
  Future<void> handleAsyncOperation(
    Future<void> Function() operation, {
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) setLoading();
      await operation();
      setSuccess();
    } on AppExceptions catch (e) {
      setFailure(e.message);
    } catch (e) {
      setFailure("Something went wrong: ${e.toString()}");
    }
  }

  /// Enhanced async operation handler with result wrapper
  @protected
  Future<Result<U>> handleAsyncOperationWithResult<U>(
    Future<U> Function() operation, {
    bool showLoading = true,
  }) async {
    try {
      if (showLoading) setLoading();
      final result = await operation();
      setSuccess();
      return Success(result);
    } on AppExceptions catch (e) {
      setFailure(e.message);
      return Failure(e.message);
    } catch (e) {
      final errorMessage = "Something went wrong: ${e.toString()}";
      setFailure(errorMessage);
      return Failure(errorMessage);
    }
  }

  @override
  void resetState() {
    final resetState = createInitialState();
    updateState(resetState);
  }

  @override
  void setFailure(String error) {
    final newState = state.copyWith(status: Status.failure, error: error) as T;
    updateState(newState);
  }

  @override
  void setLoading() {
    final newState = state.copyWith(status: Status.loading, error: '') as T;
    updateState(newState);
  }

  @override
  void setSuccess() {
    final newState = state.copyWith(status: Status.success, error: '') as T;
    updateState(newState);
  }

  @override
  void setPartialSuccess() {
    final newState =
        state.copyWith(status: Status.partialSuccess, error: '') as T;
    updateState(newState);
  }

  @override
  void setCancelled() {
    final newState = state.copyWith(status: Status.cancelled, error: '') as T;
    updateState(newState);
  }

  /// Abstract method for creating initial state - forces subclasses to implement
  @protected
  T createInitialState();

  /// Utility method to check if operation can be performed
  @protected
  bool canPerformOperation() {
    return !state.isLoading;
  }

  /// Template method for validation before operations
  @protected
  bool validateBeforeOperation() {
    return true;
  }
}

/// Enhanced paginated notifier for lists with pagination support
abstract class PaginatedNotifier<T extends BaseState> extends BaseNotifier<T>
    implements IPaginationHandler {
  int _currentPage = 1;
  bool _hasReachedMax = false;
  static const int _defaultPageSize = 20;

  PaginatedNotifier(super.initialState);

  int get currentPage => _currentPage;
  bool get hasReachedMax => _hasReachedMax;

  @override
  bool get canLoadMore => !_hasReachedMax && !state.isLoading;

  @override
  Future<void> loadMore() async {
    if (!canLoadMore) return;

    _currentPage++;
    await handleAsyncOperation(
      () => fetchData(_currentPage, _defaultPageSize),
      showLoading: false,
    );
  }

  @override
  void resetPagination() {
    _currentPage = 1;
    _hasReachedMax = false;
  }

  /// Abstract method for fetching paginated data
  @protected
  Future<void> fetchData(int page, int pageSize);

  /// Method to be called when pagination reaches the end
  @protected
  void markAsReachedMax() {
    _hasReachedMax = true;
  }

  /// Refresh data from the beginning
  Future<void> refresh() async {
    resetPagination();
    await handleAsyncOperation(
      () => fetchData(_currentPage, _defaultPageSize),
    );
  }
}
