import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:quartermaster/authentication/authentication.dart';
import 'package:quartermaster/authentication/user.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  UserModel user;

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
    if (event is Authorized) {
      yield Authenticated(user: user, organizations: event.organizations);
    }
    if (event is Login) {
      final user = await _userRepository.getUser();
      yield* _handleLogin(user.uid);
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
    final DocumentReference userReference =
        Firestore.instance.collection('users').document(uid);
    final DocumentSnapshot userSnapshot = await userReference.get();
    user = UserModel.fromSnapshot(userSnapshot);
    Firestore.instance
        .collection('user_access')
        .where('userReference', isEqualTo: userReference)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      Map<String, String> organizations = Map.fromIterable(snapshot.documents,
          key: (doc) => doc.data['organizationReference'].documentID,
          value: (doc) => 'admin');
      print(organizations);
      dispatch(Authorized(organizations));
    });
    yield Authenticated(user: user);
  }
}
