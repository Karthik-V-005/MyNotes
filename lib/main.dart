import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email.dart';
//import 'dart:developer' as devtools show log; 



void main() {
  WidgetsFlutterBinding.ensureInitialized(); // to ensure that all widegets are initialized 
                                            // before the firebase app is initialised (useful for mutiple buttons)
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute : (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute : (context) => const NotesView(),
        verifyEmailRoute : (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute : (context) => const CreateUpdateNoteView(),
      }
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder( // builds the future for the firebase authentication to happen all before the widget is built
        future: AuthService.firebase().initialize(),
        builder:(context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.done: //when the connection state is successful then the appscreen is built
              final user = AuthService.firebase().currentUser;
              if (user!=null){
                if (user.isEmailVerified){
                  return const NotesView();
                } else {
                return const VerifyEmailView();
                } 
              } else {
                return const LoginView();
              }
            default: //else a loading text is displayed until the future is built
              return const CircularProgressIndicator(); 
          }
        },
      );
  }
}





