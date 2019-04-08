import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  AuthenticationEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthenticationEvent {
  @override
  String toString() => 'AppStarted';
}

class Authorized extends AuthenticationEvent {
  final Map organizations;

  Authorized(this.organizations);

  @override
  String toString() => 'Authorized';
}

class Login extends AuthenticationEvent {
  @override
  String toString() => 'Login';
}

class Logout extends AuthenticationEvent {
  @override
  String toString() => 'Logout';
}
