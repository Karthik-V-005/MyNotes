// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'dart:developer' as devtools show log;
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email; // to get email and password later (waits for user input)
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController(); // initialising the email and pwd vars to accept input
    _password = TextEditingController();
    super.initState();
  }
  
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        foregroundColor: Colors.greenAccent.shade700,
        backgroundColor: Colors.black,
      ),
      body: Column(
            children: [
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Please enter your email here",
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: "Please enter your password here",
                ),
              ),
              TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email
                  , password: password
                );
                final user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified ?? false){
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                (route) => false,
                );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
                }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'invalid-credential'){
                    await showErrorDialog(context, "Invalid Credentials",);
                  } else {
                  await showErrorDialog(context, "Error : ${e.code}",);
                  }
                } catch (e) {
                  await showErrorDialog(context, e.toString(),);
                }
              },
              child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute,
                    (route) => false
                  );
                }, 
              child: const Text("Not registered yet? Register here!"))
            ],
          ),
    );
  }  
}












