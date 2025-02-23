//login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}



//register exceptions
class WeakPasswordException implements Exception {}

class EmailAlreadyInUseExecption implements Exception {}

class InvalidMailException implements Exception {}

//generic exceptions
class GenericException implements Exception {}

class UserNotLoggedInException implements Exception {}
