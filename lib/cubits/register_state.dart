abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterFaliur extends RegisterState {
  String errorMessage = "";
  RegisterFaliur({required this.errorMessage});
}
