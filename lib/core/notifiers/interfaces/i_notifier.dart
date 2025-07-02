import 'package:flutter/widgets.dart';
import '../base_state.dart';

/// Interface for notifiers following the Single Responsibility Principle
abstract class INotifier<T extends BaseState> extends ChangeNotifier {
  /// Current state of the notifier
  T get state;
  
  /// Update the state
  void updateState(T newState);
  
  /// Reset state to initial
  void resetState();
  
  /// Dispose resources
  @override
  void dispose();
}

/// Interface for async operations
abstract class IAsyncOperationHandler {
  /// Handle async operations with proper error handling
  Future<void> handleAsyncOperation(
    Future<void> Function() operation, {
    bool showLoading = true,
  });
}

/// Interface for loading state management
abstract class ILoadingStateManager {
  /// Set loading state
  void setLoading();
  
  /// Set success state
  void setSuccess();
  
  /// Set failure state with error message
  void setFailure(String error);
  
  /// Set partial success state
  void setPartialSuccess();
  
  /// Set cancelled state
  void setCancelled();
}

/// Interface for pagination support
abstract class IPaginationHandler {
  /// Load more data
  Future<void> loadMore();
  
  /// Check if more data can be loaded
  bool get canLoadMore;
  
  /// Reset pagination
  void resetPagination();
}
