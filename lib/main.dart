import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';
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
      }
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder( // builds the future for the firebase authentication to happen all before the widget is built
        future: Firebase.initializeApp( 
              options: DefaultFirebaseOptions.currentPlatform,
              ),
        builder:(context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.done: //when the connection state is successful then the appscreen is built
              final user = FirebaseAuth.instance.currentUser;
              if (user!=null){
                if (user.emailVerified){
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

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main UI"),
        foregroundColor: Colors.greenAccent.shade700,
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch(value){
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout){
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                    (_) => false,
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [ PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text("Logout"),
              ),
            ];
            }
          )
        ],
      ),
      body: const Text("Hello World!")
    );
  }
}



Future<bool> showLogOutDialog(BuildContext context){
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
          title: const Text("Sign Out"),
          content: const Text("Are you sure want to Sign Out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              }, child: const Text("Cancel"),
          ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
          }, child: const Text("Sign Out"),
          )
        ],
      );
    }
  ).then((value) => value ?? false);
}

