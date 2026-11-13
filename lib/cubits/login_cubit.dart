import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> LoginUser(
      {required String email, required String password}) async {
    emit(LoginLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFail(errorMessage: 'user-not-found'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFail(errorMessage: "wrong-password"));
      } else if (e.message != null) {
        emit(LoginFail(errorMessage: "somthing went wrong"));
      }
    }
  }
}
