import '../../core/base/base_viewmodel.dart';
import 'models/auth_service.dart';
import 'models/login_request.dart';
import 'models/user.dart';
import '../../core/services/storage_service.dart';

class LoginViewModel extends BaseViewModel {
  final AuthService authService;
  final StorageService storage;

  String? emailError;
  String? passwordError;

  LoginViewModel({
    AuthService? authService,
    StorageService? storage,
  })  : authService = authService ?? AuthService(),
        storage = storage ?? StorageService();

  bool validateEmail(String email) {
    if (email.isEmpty) {
      emailError = 'Email is required';
      return false;
    } else if (!email.contains('@') || !email.contains('.')) {
      emailError = 'Email must be valid (e.g., user@example.com)';
      return false;
    } else {
      emailError = null;
      return true;
    }
  }

  bool validatePassword(String password) {
    if (password.isEmpty) {
      passwordError = 'Password is required';
      return false;
    } else if (password.length < 8) {
      passwordError = 'Password must be at least 8 characters long';
      return false;
    } else {
      passwordError = null;
      return true;
    }
  }

  Future<User> login(String email, String password) async {
    notifyListeners();
    
    bool isEmailValid = validateEmail(email);
    bool isPasswordValid = validatePassword(password);
    notifyListeners();

    if (!isEmailValid || !isPasswordValid) {
      return Future.error('Please fix validation errors');
    }

    setLoading(true);
    clearError();
    try {
      final user = await authService.login(LoginRequest(email: email, password: password));
      if (user.token.isEmpty) {
        setError('No token received from server');
        return Future.error('No token');
      }
      await storage.saveToken(user.token);
      return user;
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      setError(errorMsg);
      return Future.error(errorMsg);
    } finally {
      setLoading(false);
    }
  }
}