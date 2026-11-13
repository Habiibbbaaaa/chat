import 'package:cloud_firestore/cloud_firestore.dart';

abstract class HomeState {}

class UserLoading extends HomeState {}

class UserInitial extends HomeState {}

class UserSuccess extends HomeState {
  final List<QueryDocumentSnapshot> users;
  final myName;
  UserSuccess(this.myName, this.users);
}

class UserFail extends HomeState {
  String errorMessage = "";
  UserFail({required this.errorMessage});
}
