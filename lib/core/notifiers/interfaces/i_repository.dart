/// Interface for authentication operations following Interface Segregation Principle
abstract class IAuthRepository {
  /// Login with email and password
  Future<void> login(String email, String password);
  
  /// Register new user
  Future<void> register(String email, String password);
  
  /// Logout current user
  Future<void> logout();
  
  /// Check if user is authenticated
  Future<bool> isAuthenticated();
  
  /// Get current user token
  Future<String?> getToken();
  
  /// Refresh authentication token
  Future<void> refreshToken();
}

/// Interface for theme operations
abstract class IThemeRepository {
  /// Get current theme mode
  Future<String?> getThemeMode();
  
  /// Save theme mode
  Future<void> saveThemeMode(String themeMode);
}

/// Generic repository interface for CRUD operations
abstract class IRepository<T> {
  /// Get all items
  Future<List<T>> getAll();
  
  /// Get item by id
  Future<T?> getById(String id);
  
  /// Create new item
  Future<T> create(T item);
  
  /// Update existing item
  Future<T> update(T item);
  
  /// Delete item
  Future<void> delete(String id);
}
