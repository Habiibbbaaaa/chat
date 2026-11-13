import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chatApp/cubits/home_page_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(UserInitial());
  StreamSubscription? _usersSubscription; // مخزن للـ Stream
  void getUsers() {
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    //snapshot->StreamSubscription<QuerySnapshot>
    _usersSubscription =
        FirebaseFirestore.instance.collection('users').snapshots().listen(
      (snapshot) {
        final currentUserDoc =
            snapshot.docs.firstWhere((doc) => doc.id == myUid);
        final myName = currentUserDoc['name'];

        final users = snapshot.docs.where((doc) => doc.id != myUid).toList();

        emit(UserSuccess(myName, users));
      },
      onError: (error) {
        emit(UserFail(errorMessage: error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _usersSubscription
        ?.cancel(); // بنقفل الـ Stream لما الـ Cubit يتمسح من الذاكرة
    return super.close();
  }
}
