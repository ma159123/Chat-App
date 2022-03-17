
import 'package:chat_app/social_login/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      print(value.user!.email);
      print(value.user!.uid);

      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorState(error.toString()));
    });
  }

  void userLogout() {
    FirebaseAuth.instance.signOut().then((value) {
      emit(LogoutSuccessState());
    }).catchError((error) {
      print(error.toString());
    });
  }

  void addData({required String message, required String userEmail,var time}) {
    emit(AddDataLoadingState());
    FirebaseFirestore.instance.collection('user-chat').add({
      'message': message,
      'user': userEmail,
      'time':time,
    }).then((value) {
      emit(AddDataSuccessState());
      print('added success');
    }).catchError((error) {
      print(error.toString());
    });
  }

  // void getData() async {
  //   emit(GetDataLoadingState());
  //   try{
  //     await for (var message
  //     in FirebaseFirestore.instance.collection('user-chat').snapshots()) {
  //       for (var data in message.docs) {
  //         //print(data.data());
  //       }
  //     }
  //     emit(GetDataSuccessState());
  //   }catch(error){
  //     emit(GetDataErrorState());
  //       print(error.toString());
  //   }
  // }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibilityState());
  }
}
