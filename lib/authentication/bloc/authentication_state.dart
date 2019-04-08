import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
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
  final Map organizations;

  Authenticated({@required this.user, this.organizations})
      : super([user, organizations]);

  @override
  String toString() =>
      'Authenticated { uid: ${user.uid}, organizations: $organizations }';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}
