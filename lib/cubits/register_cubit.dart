import 'package:bloc/bloc.dart';
import 'package:chatApp/cubits/register_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> RegisterUser(
      {required String name,
      required String email,
      required String password,
      required String confirm}) async {
    emit(RegisterLoading());

    if (password != confirm) {
      emit(RegisterFaliur(errorMessage: 'password dont match'));
      return;
    }

    try {
      // Create user with Firebase
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      // Save user's data in Firestore by his UID in document in the user collection
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Optional: send email verification
      // await userCredential.user?.sendEmailVerification();

      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      String message = 'Registration error';
      if (e.code == 'email-already-in-use') {
        emit(RegisterFaliur(errorMessage: 'email-already-in-use'));
      } else if (e.code == 'weak-password') {
        emit(RegisterFaliur(errorMessage: 'weak-password'));
      } else if (e.code == 'invalid-email') {
        emit(RegisterFaliur(errorMessage: 'invalid-email'));
      } else if (e.message != null) {
        emit(RegisterFaliur(errorMessage: 'somthing went wrong'));
      }
    }
  }
}
