# Enhanced Notifier Architecture

This enhanced notifier architecture follows SOLID principles and implements best practices for Flutter state management.

## Architecture Overview

### 🏗️ SOLID Principles Implementation

1. **Single Responsibility Principle (SRP)**

   - Each notifier has a single responsibility
   - Interfaces are focused on specific operations
   - Mixins handle cross-cutting concerns

2. **Open/Closed Principle (OCP)**

   - Base classes are open for extension, closed for modification
   - Result wrapper allows extending error handling
   - Mixins can be added without modifying base classes

3. **Liskov Substitution Principle (LSP)**

   - All notifiers can be substituted with their base class
   - Interfaces ensure consistent behavior

4. **Interface Segregation Principle (ISP)**

   - Multiple small interfaces instead of large ones
   - Clients depend only on interfaces they use

5. **Dependency Inversion Principle (DIP)**
   - High-level modules don't depend on low-level modules
   - Both depend on abstractions (interfaces)
   - Dependency injection through constructors

## 📁 File Structure

```
core/
├── notifiers/
│   ├── interfaces/
│   │   ├── i_notifier.dart          # Core notifier interfaces
│   │   └── i_repository.dart        # Repository interfaces
│   ├── mixins/
│   │   └── notifier_mixins.dart     # Reusable mixins
│   ├── common/
│   │   └── result.dart              # Result wrapper for operations
│   ├── auth/
│   │   ├── auth_state.dart          # Auth-specific state
│   │   └── auth_notifiers.dart      # Auth notifier implementation
│   ├── theme/
│   │   ├── theme_state.dart         # Theme-specific state
│   │   └── theme_notifiers.dart     # Theme notifier implementation
│   ├── examples/
│   │   ├── user_list_state.dart     # Example complex state
│   │   └── user_list_notifier.dart  # Example complex notifier
│   ├── base_state.dart              # Base state with status enum
│   ├── base_notifier.dart           # Enhanced base notifier
│   └── notifiers.dart               # Barrel export file
├── repositories/
│   ├── auth_repository.dart         # Auth data layer
│   └── theme_repository.dart        # Theme data layer
└── factories/
    └── notifier_factory.dart        # Dependency injection factory
```

## 🚀 Key Features

### Enhanced Base State

- Consistent status management
- Equatable for efficient comparisons
- Immutable state objects
- Type-safe state updates

### Improved Base Notifier

- Template method pattern
- Protected methods for subclasses
- Error handling with Result wrapper
- Lifecycle management
- Operation validation

### Pagination Support

- Built-in pagination handling
- Load more functionality
- Refresh capabilities
- Max reached detection

### Mixins for Cross-Cutting Concerns

- **NotifierLifecycleMixin**: Disposal tracking
- **DebounceMixin**: Operation debouncing
- **RetryMixin**: Automatic retry logic

### Result Wrapper

- Type-safe error handling
- Functional programming approach
- Composable operations
- Clear success/failure states

## 📝 Usage Examples

### Basic Notifier Implementation

```dart
class MyNotifier extends BaseNotifier<MyState> {
  MyNotifier() : super(MyState.initial());

  @override
  MyState createInitialState() => MyState.initial();

  Future<void> performOperation() async {
    await handleAsyncOperation(() async {
      // Your async operation here
      final result = await apiCall();
      final newState = state.copyWith(data: result);
      updateState(newState);
    });
  }
}
```

### Paginated Notifier

```dart
class MyListNotifier extends PaginatedNotifier<MyListState> {
  MyListNotifier() : super(MyListState.initial());

  @override
  MyListState createInitialState() => MyListState.initial();

  @override
  Future<void> fetchData(int page, int pageSize) async {
    final data = await apiService.getData(page, pageSize);
    if (data.length < pageSize) markAsReachedMax();

    final updatedList = page == 1 ? data : [...state.items, ...data];
    final newState = state.copyWith(items: updatedList);
    updateState(newState);
  }
}
```

### Using Mixins

```dart
class SearchNotifier extends BaseNotifier<SearchState>
    with DebounceMixin, RetryMixin {

  void search(String query) {
    debounce('search', Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    await withRetry(() => apiService.search(query));
  }
}
```

### Factory Pattern

```dart
// Production
final authNotifier = NotifierFactory().createAuthNotifier();

// Testing
final testNotifier = TestNotifierFactory(
  mockAuthRepository: mockRepo,
).createAuthNotifier();
```

## 🧪 Testing Benefits

1. **Dependency Injection**: Easy mocking of repositories
2. **Interface-based**: Test against interfaces, not implementations
3. **State Isolation**: Each test can create fresh state
4. **Factory Pattern**: Different configurations for test/production

## 📊 State Management Flow

```
UI Layer
    ↓ (calls methods)
Notifier Layer (Business Logic)
    ↓ (uses interfaces)
Repository Layer (Data Access)
    ↓ (calls APIs/Storage)
External Services
```

## 🔒 Error Handling

1. **Centralized**: All errors handled in base notifier
2. **Type-safe**: Result wrapper prevents runtime errors
3. **Graceful**: UI can respond appropriately to different states
4. **Logged**: All errors are properly logged

## 🎯 Best Practices

1. **Always extend BaseState** for consistency
2. **Use factory constructors** for common state patterns
3. **Implement createInitialState()** in all notifiers
4. **Validate before operations** using validateBeforeOperation()
5. **Use Result wrapper** for complex operations
6. **Add mixins** for cross-cutting concerns
7. **Inject dependencies** through constructors
8. **Test with mock repositories**

## 🚀 Migration Guide

1. **Update existing states** to extend BaseState
2. **Replace direct ChangeNotifier** with BaseNotifier
3. **Move API calls** to repository classes
4. **Use factory** for notifier creation
5. **Add interfaces** for better testing
6. **Update UI** to handle new state structure

This architecture provides a robust, testable, and maintainable foundation for Flutter applications.
