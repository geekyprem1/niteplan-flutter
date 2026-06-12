import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

enum AuthState { loading, authenticated, unauthenticated }

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;

  AuthState _state = AuthState.loading;
  AuthState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? get currentUser => _authService.currentUser;
  bool get isGuest => _authService.isGuest;

  AuthViewModel() {
    _authService.authStateChanges.listen((user) {
      _state = user != null ? AuthState.authenticated : AuthState.unauthenticated;
      notifyListeners();
    });
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.signInWithGoogle();

    _isLoading = false;
    if (result.isSuccess) {
      _state = AuthState.authenticated;
    } else if (!result.cancelled) {
      _errorMessage = result.error;
    }
    notifyListeners();
    return result.isSuccess;
  }

  Future<bool> signInAsGuest() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.signInAsGuest();

    _isLoading = false;
    if (result.isSuccess) {
      _state = AuthState.authenticated;
    } else {
      _errorMessage = result.error;
    }
    notifyListeners();
    return result.isSuccess;
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    await _authService.signOut();
    _state = AuthState.unauthenticated;
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> deleteAccount() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.deleteAccount();

    _isLoading = false;
    if (!result.isSuccess) {
      _errorMessage = result.error;
    }
    notifyListeners();
    return result.isSuccess;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
