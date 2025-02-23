import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group("Mock Auth Provider", () {
    final provider = MockAuthProvider();
    test("Cannot be initialised to beign with", () {
      expect(provider.isInitialised, false);
    });

    test("Cannot log out if initialised", () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitialisedException>()));
    });

    test("Should be able to be initialised", () async {
      await provider.initialize();
      expect(provider.isInitialised, true);
    });

    test("User should be null after initialisation", () {
      expect(provider.currentUser, null);
    });

    test('Should be able to initialise in less than 2 seconds', () async {
      await provider.initialize();
      expect(provider.isInitialised, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test("Create user should delegate to logIN function", () async {
      final badEmailuser = provider.createUser(
        email: 'foo@bar.com',
        password: 'anypassword',
      );

      expect(badEmailuser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPasswordUser = provider.createUser(
        email: 'someone@bar.com',
        password: 'foobar',
      );

      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: 'foo',
        password: 'bar',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test("Logged in user must be verified user", () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("Should be able to log in and log out again", () async {
      await provider.logOut();
      await provider.logIN(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitialisedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialised = false;
  bool get isInitialised => _isInitialised;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialised) throw NotInitialisedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIN(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialised = true;
  }

  @override
  Future<AuthUser> logIN({
    required String email,
    required String password,
  }) {
    if (!isInitialised) throw NotInitialisedException();
    if (email == "foo@bar.com") throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialised) throw NotInitialisedException();
    if (_user == null) throw UserNotLoggedInException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialised) throw NotInitialisedException();
    final user = _user;
    if (user == null) throw UserNotLoggedInException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
