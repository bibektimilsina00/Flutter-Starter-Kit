import '../base_state.dart';

/// Example of a more complex state for a user list with pagination
class UserListState extends BaseState {
  final List<Map<String, dynamic>> users;
  final bool hasReachedMax;
  final int currentPage;
  final String searchQuery;

  const UserListState({
    super.status,
    super.error,
    this.users = const [],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.searchQuery = '',
  });

  factory UserListState.initial() => const UserListState();

  @override
  UserListState copyWith({
    Status? status,
    String? error,
    List<Map<String, dynamic>>? users,
    bool? hasReachedMax,
    int? currentPage,
    String? searchQuery,
  }) {
    return UserListState(
      status: status ?? this.status,
      error: error ?? this.error,
      users: users ?? this.users,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    users,
    hasReachedMax,
    currentPage,
    searchQuery,
  ];
}
