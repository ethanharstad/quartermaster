import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:quartermaster/authentication/user.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  AuthenticationState([List props = const []]) : super(props);
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthenticationState {
  final UserModel user;

  Authenticated({this.user}) : super([user]);

  @override
  String toString() => 'Authenticated { uid: ${user.uid} }';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}
