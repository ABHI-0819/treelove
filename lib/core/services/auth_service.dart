/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  signInWithGoogle() async {
// begin interactive sign in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await googleUser!.authentication;

    // create a new credential for user
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);

    // finally, lets sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

/// Model to hold the signed-in user's info and tokens.
class GoogleUser {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoURL;
  final String? accessToken;
  final String? idToken;
  final bool  isNewUser;

  GoogleUser({
    required this.uid,
    this.displayName,
    this.email,
    this.photoURL,
    this.accessToken,
    this.idToken,
    required this.isNewUser
  });
}

class AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthService({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
      : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  /// Initializes Firebase if not already initialized.
  Future<void> _initializeFirebaseIfNeeded() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  }

  /// Signs in the user using Google Sign-In and Firebase Auth.
  /// Returns a [GoogleUser] with user details and tokens on success.
  /// Returns null if user cancels the sign-in or if an error occurs.
  Future<GoogleUser?> signInWithGoogle() async {
    try {
      await _initializeFirebaseIfNeeded();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in flow.
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      final bool isNewUser = userCredential.additionalUserInfo!.isNewUser ?? false;

      if (user == null) {
        // Sign-in failed, no user returned.
        return null;
      }

      return GoogleUser(
        uid: user.uid,
        displayName: user.displayName,
        email: user.email,
        photoURL: user.photoURL,
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
        isNewUser: isNewUser
      );
    } catch (e, stackTrace) {
      // Log errors for monitoring, or send to your error tracking system
      print('Error during Google sign-in: $e');
      print(stackTrace);
      return null;
    }
  }

  /// Signs out the user from both Firebase and Google.
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.disconnect(), // ✅ full revoke
    ]);
  }
  /*
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

   */
}
