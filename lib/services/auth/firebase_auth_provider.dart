import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';

import 'package:firebase_auth/firebase_auth.dart'
        show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider{
  @override
  Future<AuthUser> createUser({
    required String email, 
    required String password,
    }) async {
      try {
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email, 
              password: password,
              );
            final user = currentUser;
            if (user!=null){
              return user;
            } else {
              throw UserNotLoggedInException();
            }
      } on FirebaseAuthException catch(e) {
        if(e.code == 'weak-password'){
          throw WeakPasswordException();
        } else if (e.code == 'email-already-in-use'){
          throw EmailAlreadyInUseExecption();
        } else if (e.code == 'invalid-email'){
          throw InvalidMailException();
        } else {
          throw GenericException();
        }

      } catch (_) {
        throw GenericException();
      }
  }

  @override
  
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null){
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIN({required String email, required String password}) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, 
      password: password,
      );
      final user = currentUser;
      if (user!=null){
        return user;
      } else {
        throw UserNotLoggedInException();
      }
    } on FirebaseAuthException catch(e) {
      if (e.code == 'user-not-found'){
        throw UserNotFoundAuthException();
      } else  if (e.code == 'wrong-password'){
        throw WrongPasswordAuthException();
      }{
        throw GenericException();
      }
    } catch (_) {
      throw GenericException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = currentUser;
    if (user!=null){
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user!=null){
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInException();
    }
  }
  
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp( 
              options: DefaultFirebaseOptions.currentPlatform,
              );
  }

}