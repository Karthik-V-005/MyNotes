// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'dart:developer' as devtools show log;
import 'package:mynotes/utilities/show_error_dialog.dart';


import 'package:mynotes/constants/routes.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  
  late final TextEditingController _email; // to get email and password later (waits for user input)
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController(); // initialising the email and pwd vars to accept input
    _password = TextEditingController();// TODO: implement initState
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
        title: const Text("Register"),
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
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email
                  , password: password
                  );
                  final user = FirebaseAuth.instance.currentUser;
                  user?.sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on FirebaseAuthException catch (e) {
                  if(e.code == 'weak-password'){
                    await showErrorDialog(context, "Weak Password. Please enter a stronger password");
                  } else if (e.code == 'email-already-in-use'){
                    await showErrorDialog(context, "Email is already in use");
                  } else if (e.code == 'invalid-email'){
                    await showErrorDialog(context, "Invalid E-Mail. Please provide a valid E-mail");
                  }
                } catch (e) {
                  await showErrorDialog(context, e.toString());
                }

              },
              child: const Text('Register'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute, 
                  (route) => false
                  );
                }, 
                child: const Text("Already Registered? Login Here!"),
              )
            ],
          ),
    );
  }
}