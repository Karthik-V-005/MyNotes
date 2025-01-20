import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

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
    return Scaffold( // the actual backbone on which the app features sit
      appBar: AppBar( // top bar that says the name of the current page
        title: const Text('Login'),
        foregroundColor: Colors.greenAccent.shade700,
        backgroundColor: Colors.black,    
      ),
      body: FutureBuilder( // builds the future for the firebase authentication to happen all before the widget is built
        future: Firebase.initializeApp( 
              options: DefaultFirebaseOptions.currentPlatform,
              ),
        builder:(context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.done: //when the connection state is successful then the appscreen is built
            return Column(
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
                final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email
                , password: password
              );
              print(userCredential);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'invalid-credential'){
                  print("Invalid Credentials");
                }
              }
            },
            child: const Text('Login'),
            ),
          ],
        );
            default: //else a loading text is displayed until the future is built
            return const Text("Loading...");
          }
        },
      ),
    );
  }  
}






//login before going on with vid





