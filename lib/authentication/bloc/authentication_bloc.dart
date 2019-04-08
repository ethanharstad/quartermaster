import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:quartermaster/authentication/authentication.dart';
import 'package:quartermaster/authentication/user.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    }
    if (event is Login) {
      final user = await _userRepository.getUser();
      yield* _handleLogin(user.uid);
      // yield Authenticated(uid: user.uid);
    }
    if (event is Logout) {
      yield* _mapLogoutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final user = await _userRepository.getUser();
        yield* _handleLogin(user.uid);
        //yield Authenticated(uid: user.uid, name: 'None');
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLogoutToState() async* {
    await _userRepository.signOut();
    yield Unauthenticated();
  }

  Stream<AuthenticationState> _handleLogin(String uid) async* {
    final DocumentSnapshot userSnapshot =
        await Firestore.instance.collection('users').document(uid).get();
    final UserModel user = UserModel.fromSnapshot(userSnapshot);
    yield Authenticated(user: user);
  }
}
