import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';



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
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( // the actual backbone on which the app features sit
      appBar: AppBar( // top bar that says the name of the current page
        title: const Text('Home'),
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
              final user = FirebaseAuth.instance.currentUser;
              if (user?.emailVerified ?? false){
                print("Verified");
              } else {
                print("Unverified");
              }
              return const Text("Done");
            default: //else a loading text is displayed until the future is built
              return const Text("Loading...");
          }
        },
      ),
    );
  }
}





