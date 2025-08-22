import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percon_case_project/model/app_user.dart';

class Auth {
  // Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  //  Register (Email & Password)
  Future<UserCredential> register(
    String email,
    String password,
    String fullName,
  ) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('users').doc(cred.user!.uid).set({
      'fullName': fullName,
      'email': cred.user!.email,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    });

    return cred;
  }

  // Login (Email & Password)
  Future<UserCredential> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('users').doc(cred.user!.uid).update({
      'lastLogin': FieldValue.serverTimestamp(),
    });

    return cred;
  }

  //  Reset password
  Future<void> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  //  Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // kullanıcı iptal etti

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final cred = await _auth.signInWithCredential(credential);

      // Firestore’a kullanıcı bilgilerini kaydet/güncelle
      await _firestore.collection('users').doc(cred.user!.uid).set({
        'fullName': cred.user!.displayName ?? '',
        'email': cred.user!.email,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return cred;
    } catch (e) {
      throw FirebaseAuthException(
        code: "google-sign-in-failed",
        message: e.toString(),
      );
    }
  }

  //  Sign out
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }
}

// extension -> pull user data from firestore
extension FirestoreAuthExtension on Auth {
  Future<AppUser?> getUserFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          return AppUser.fromMap({
            'uid': uid,
            'fullName': data['fullName'],
            'email': data['email'],
            'createdAt': data['createdAt'],
            'lastLogin': data['lastLogin'],
          });
        }
      }
      return null;
    } catch (e) {
      print("Firestore user fetch error: $e");
      return null;
    }
  }
}
