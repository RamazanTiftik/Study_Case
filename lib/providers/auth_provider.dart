import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percon_case_project/model/app_user.dart';
import 'package:percon_case_project/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final AppUser? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({AppUser? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Auth _authService;

  AuthNotifier(this._authService) : super(AuthState()) {
    _init(); // when provider exists -> hydrate to user
  }

  Future<void> _init() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      try {
        final appUser = await _authService.getUserFromFirestore(
          firebaseUser.uid,
        );
        state = state.copyWith(user: appUser);
      } catch (e) {
        state = state.copyWith(error: e.toString());
      }
    }
  }

  // user register
  Future<void> register(String email, String password, String fullName) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final cred = await _authService.register(email, password, fullName);
      if (cred.user != null) {
        final appUser = await _authService.getUserFromFirestore(cred.user!.uid);
        state = state.copyWith(user: appUser, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // user login
  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final cred = await _authService.login(email, password);
      if (cred.user != null) {
        final appUser = await _authService.getUserFromFirestore(cred.user!.uid);
        state = state.copyWith(user: appUser, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // google sign in
  Future<void> loginWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final cred = await _authService.signInWithGoogle();
      if (cred?.user != null) {
        final appUser = await _authService.getUserFromFirestore(
          cred!.user!.uid,
        );
        state = state.copyWith(user: appUser, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  // sign out
  Future<void> logout() async {
    await _authService.signOut();
    state = AuthState();
  }
}

// Service provider
final authServiceProvider = Provider<Auth>((ref) => Auth());

// State provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});
