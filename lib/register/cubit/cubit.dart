import 'package:chat_app/register/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../chat_user_model.dart';

class RegisterCubit extends Cubit<RegisterStates>
{
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context)=>BlocProvider.of(context);

  void userRegister({
  required String email,
    required String name,
    required String phone,
    required String password,
})
  {
    emit(RegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value){
     print(value.user!.email);
     print(value.user!.uid);
     userCreate(
         uId: value.user!.uid,
         phone: phone,
         name: name,
       email: email,
     );

    }).catchError((error){
     emit(RegisterErrorState(error.toString()));
    });
  }
//to save users in firestore
  void userCreate({
    required String email,
    required String name,
    required String phone,
    required String uId,
  }) {
    SocialUserModel model=SocialUserModel(
        email: email,
        name: name,
        phone: phone,
        uId: uId,
      image: 'https://i.pinimg.com/474x/65/25/a0/6525a08f1df98a2e3a545fe2ace4be47.jpg',
      cover: 'https://bs-uploads.toptal.io/blackfish-uploads/blog/article/content/cover_image_file/cover_image/14578/cover-default-cover-4-95d4849f3246988bcc15c655ffee1b9a.png',
      bio:'write your bio',
      isEmailVerified: false,
    );
    FirebaseFirestore.instance.collection('users').doc(uId)
        .set(model.toMap())
        .then((value) {
          emit(CreateUserSuccessState());
    })
        .catchError((error){
          emit(CreateUserErrorState(error.toString()));
    });
  }
  IconData suffix=Icons.visibility_outlined;
  bool isPassword=true;
  void changePasswordVisibility()
  {
    isPassword=!isPassword;
    suffix=isPassword?Icons.visibility_outlined:Icons.visibility_off_outlined;
    emit(RegisterChangePasswordVisibilityState());
  }

}

