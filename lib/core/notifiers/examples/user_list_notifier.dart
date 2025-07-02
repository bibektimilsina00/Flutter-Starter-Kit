import '../base_notifier.dart';
import '../mixins/notifier_mixins.dart';
import 'user_list_state.dart';

/// Example of a complex notifier using pagination and mixins
class UserListNotifier extends PaginatedNotifier<UserListState>
    with DebounceMixin, RetryMixin, NotifierLifecycleMixin {
  
  UserListNotifier() : super(UserListState.initial());

  @override
  UserListState createInitialState() => UserListState.initial();

  /// Search users with debouncing
  void searchUsers(String query) {
    ensureNotDisposed();
    
    // Update search query immediately
    final newState = state.copyWith(searchQuery: query);
    updateState(newState);
    
    // Debounce the actual search operation
    debounce('search', const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  /// Perform the actual search
  Future<void> _performSearch(String query) async {
    ensureNotDisposed();
    
    resetPagination();
    await handleAsyncOperation(() async {
      final users = await _fetchUsersFromApi(1, 20, query);
      final newState = state.copyWith(
        users: users,
        currentPage: 1,
        hasReachedMax: users.length < 20,
      );
      updateState(newState);
    });
  }

  @override
  Future<void> fetchData(int page, int pageSize) async {
    ensureNotDisposed();
    
    final newUsers = await withRetry(() => 
      _fetchUsersFromApi(page, pageSize, state.searchQuery)
    );
    
    if (newUsers.isEmpty || newUsers.length < pageSize) {
      markAsReachedMax();
    }
    
    final updatedUsers = page == 1 ? newUsers : [...state.users, ...newUsers];
    final newState = state.copyWith(
      users: updatedUsers,
      currentPage: page,
      hasReachedMax: hasReachedMax,
    );
    updateState(newState);
  }

  /// Mock API call - replace with actual implementation
  Future<List<Map<String, dynamic>>> _fetchUsersFromApi(
    int page, 
    int pageSize, 
    String query
  ) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data generation
    return List.generate(pageSize, (index) => {
      'id': '${page}_$index',
      'name': 'User ${page}_$index',
      'email': 'user${page}_$index@example.com',
    });
  }

  /// Clear search and reset
  void clearSearch() {
    ensureNotDisposed();
    
    cancelDebounce('search');
    final newState = state.copyWith(searchQuery: '');
    updateState(newState);
    refresh();
  }

  /// Add a new user
  Future<void> addUser(Map<String, dynamic> user) async {
    ensureNotDisposed();
    
    await handleAsyncOperation(() async {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final updatedUsers = [user, ...state.users];
      final newState = state.copyWith(users: updatedUsers);
      updateState(newState);
    }, showLoading: false);
  }

  /// Remove a user
  Future<void> removeUser(String userId) async {
    ensureNotDisposed();
    
    await handleAsyncOperation(() async {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final updatedUsers = state.users.where((user) => user['id'] != userId).toList();
      final newState = state.copyWith(users: updatedUsers);
      updateState(newState);
    }, showLoading: false);
  }

  @override
  void dispose() {
    markAsDisposed();
    cancelAllDebounces();
    super.dispose();
  }

  /// Convenience getters
  List<Map<String, dynamic>> get users => state.users;
  String get searchQuery => state.searchQuery;
  bool get hasUsers => users.isNotEmpty;
}
