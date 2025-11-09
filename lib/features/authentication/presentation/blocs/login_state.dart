part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class InitialState extends LoginState {}

final class LoadingState extends LoginState {}

final class SuccessState extends LoginState {
  final String message, token;
  SuccessState({this.message = "success", this.token = ''});
}

final class FailureState extends LoginState {
  final String message;

  FailureState(this.message);
}
