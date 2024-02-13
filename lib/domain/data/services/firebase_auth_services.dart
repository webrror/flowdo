import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowdo/common/constants/constants.dart';
import 'package:flowdo/domain/data/services/firebase_firestore_services.dart';
import 'package:flowdo/common/utils/utils.dart';
import 'package:flowdo/presentation/views/home_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// [FirebaseAuthMethods] class consists of properties and methods related Firebase Auth
class FirebaseAuthMethods {
  /// FirebaseAuth instance
  final FirebaseAuth _auth;

  // Constructor
  FirebaseAuthMethods(this._auth);

  /// User info getter
  User get user => _auth.currentUser!;

  /// Sate Persistence Stream of authState
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  /// Method used to Sign in with Google
  ///
  /// After signing in, creates a document with `id` same as `user.userId`
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      showSuccessToast(context, Strings.signingIn);
      if (kIsWeb) {
        GoogleAuthProvider provider = GoogleAuthProvider();
        provider.addScope(Strings.profileScope);
        await _auth.signInWithPopup(provider).then((value) {
          if (value.user?.uid != null) {
            showSuccessToast(
              context,
              "${Strings.welcome} ${(value.user?.displayName ?? Strings.user)}!",
            );
          }
        });
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
        if (googleAuth?.accessToken != null) {
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );

          UserCredential creds = await _auth.signInWithCredential(credential);

          if (creds.user != null) {
            if (context.mounted) {
              showSuccessToast(
                context,
                "${Strings.welcome} ${(creds.user?.displayName ?? Strings.user)}!",
              );
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeView(),
                ),
              );
            }
          }
        }
      }
      FirebaseFirestoreMethods().createDocument();
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        showFbAuthExceptionToast(context, e);
      }
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        showErrorToast(context);
      }
    }
  }

  /// Method used to Sign in as a guest/anonymous
  ///
  /// After signing in, creates a document with `id` same as `user.userId`
  Future<void> signInAsAGuest(BuildContext context) async {
    try {
      showSuccessToast(context, Strings.signingIn);
      await _auth.signInAnonymously().then((value) {
        showSuccessToast(
          context,
          "${Strings.welcome} ${Strings.user}!",
        );
        FirebaseFirestoreMethods().createDocument();
      });
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        showErrorToast(context);
      }
    }
  }

  /// Method used to Sign out
  ///
  /// If user is guest/anonymous, their document is deleted before sign out
  Future<void> signOut(BuildContext context) async {
    try {
      if (user.isAnonymous) {
        FirebaseFirestoreMethods().deleteDocument();
      }
      await _auth.signOut().then((value) {
        showSuccessToast(context, Strings.signedOut);
      });
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        showFbAuthExceptionToast(context, e);
      }
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        showErrorToast(context);
      }
    }
  }

  /// Method used to delete account forever
  ///
  /// Their document is deleted before deleting
  Future<bool> deleteAccount(BuildContext context) async {
    try {
      FirebaseFirestoreMethods().deleteDocument();
      await _auth.currentUser!.delete().then((value) {
        showSuccessToast(context, Strings.accountDeleteLoginAgain);
        return true;
      });
      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        showFbAuthExceptionToast(context, e);
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        showErrorToast(context);
      }
      return false;
    }
  }
}