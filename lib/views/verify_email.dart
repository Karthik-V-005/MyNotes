import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
// import 'dart:developer' as devtools show log;

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
        foregroundColor: Colors.greenAccent.shade700,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const Text("We've sent you an email verification. Please open the link to verify"),
          const Text("If you haven't received an email verification press this button here"),
            Center(
              child: 
              TextButton(onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              }, 
              child: const Text("Send Email Verification")
              ),
            ),
            Center(
              child: TextButton(onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route)=>false);
                },
                child: const Text("Restart"),
                ),
            )
        ],
      ),
    );
  }
}