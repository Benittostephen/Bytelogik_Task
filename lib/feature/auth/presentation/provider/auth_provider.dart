import 'package:byte_logik/core/services/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthState { initial, loading, authenticated, unauthenticated }

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial);

  final DatabaseService _databaseService = DatabaseService();

  Future<bool> signUp(String email, String password) async {
    state = AuthState.loading;

    if (await _databaseService.userExists(email)) {
      state = AuthState.unauthenticated;
      return false;
    }

    final success = await _databaseService.createUser(email, password);
    if (success) {
      state = AuthState.authenticated;
      return true;
    } else {
      state = AuthState.unauthenticated;
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    state = AuthState.loading;

    final success = await _databaseService.authenticateUser(email, password);
    if (success) {
      state = AuthState.authenticated;
      return true;
    } else {
      state = AuthState.unauthenticated;
      return false;
    }
  }

  void signOut() {
    state = AuthState.unauthenticated;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
