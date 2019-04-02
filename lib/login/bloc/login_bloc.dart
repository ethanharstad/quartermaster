import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quartermaster/login/login.dart';
import 'package:quartermaster/authentication/authentication.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;
  AuthenticationBloc _authenticationBloc;

  LoginBloc(
      {@required UserRepository userRepository,
      @required AuthenticationBloc authenticationBloc})
      : assert(userRepository != null),
        assert(authenticationBloc != null),
        _userRepository = userRepository,
        _authenticationBloc = authenticationBloc;

  @override
  LoginState get initialState => Initial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginPressed) {
      yield* _mapLoginToState(event);
    }
  }

  Stream<LoginState> _mapLoginToState(LoginPressed event) async* {
    yield Loading();
    try {
      await _userRepository.signIn(event.email, event.password);
      _authenticationBloc.dispatch(Login());
    } catch (_) {}
  }
}
