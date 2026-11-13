abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFail extends LoginState {
  String errorMessage = "";
  LoginFail({required this.errorMessage});
}
