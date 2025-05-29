import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:security/components/my_button.dart';
import 'package:security/components/my_text_field.dart';
import 'package:security/components/square_tile.dart';
import 'package:security/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function()? registerTap;

  const LoginPage({super.key, required this.registerTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  Future<void> signInTap() async {
    if (emailTextController.text.isEmpty ||
        passwordTextController.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and password cannot be empty")),
      );
      return;
    }

    // show loading circle
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    try {
      // try sign in
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailTextController.text,
            password: passwordTextController.text,
          );

      if (!mounted) return;
      if (Navigator.canPop(context)) Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Welcome ${userCredential.user?.email}!")),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      if (Navigator.canPop(context)) Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Authentication error")),
      );
    } catch (e) {
      if (!mounted) return;
      if (Navigator.canPop(context)) Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Unexpected error occurred")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // logo
                Image.asset(
                  'lib/assets/logo2.png',
                  width: 200,
                  // Set the desired width
                  height: 200,
                  // Set the desired height
                  fit: BoxFit.cover,
                  // How the image should be inscribed into the box
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback widget if the image fails to load
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 50),
                // welcome, .. you've been missed!
                Text(
                  "Welcome!",
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),

                const SizedBox(height: 25),

                // username password text fields
                MyTextField(
                  hintText: "email",
                  obscureText: false,
                  controller: emailTextController,
                ),

                const SizedBox(height: 10),
                MyTextField(
                  hintText: "password",
                  obscureText: true,
                  controller: passwordTextController,
                ),
                const SizedBox(height: 5),

                // forgot password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                //sign in button
                MyButton(text: "Sign In", onTap: () => signInTap()),
                const SizedBox(height: 25),

                // alternative google + apple sign in
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey[400]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Or continue with",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google
                    SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      assetPath: 'lib/assets/google_logo2.png',
                    ),
                    SizedBox(width: 25),
                    SquareTile(
                      onTap: () => {},
                      assetPath: 'lib/assets/apple_logo.png',
                    ),
                    // apple
                  ],
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.registerTap,
                      child: const Text(
                        "Register Now",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // not  a member? register now
              ],
            ),
          ),
        ),
      ),
    );
  }
}
