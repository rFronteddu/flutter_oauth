import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async {
    // begin interactive sign in process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    // obtain a uth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create ne credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // finally, sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
