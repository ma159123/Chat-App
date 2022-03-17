import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import '../componants.dart';
import '../layout.dart';
import '../register/social_register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ChatLoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text(state.error),
          // ));
          showSnackBar(
            text: state.error,
            state: ToastStates.ERROR,
            context: context,
          );
        }
        if (state is LoginSuccessState) {
          // CacheHelper.saveData(
          //     key: 'uId',
          //     value: state.uId)
          //     .then((value) {
            navigateAndFinish(
              context,
               Layout(),
            );
          // });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        'login now to communicate with friends',
                        style:
                            Theme.of(context).textTheme.bodyText1!.copyWith(
                                  color: Colors.grey,
                                ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      defaultTextFormField(
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validate: (value) {
                          if (value.isEmpty) {
                            return 'please enter your email address';
                          }
                          return null;
                        },
                        label: 'Email Address',
                        prefix: Icons.email_outlined,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      defaultTextFormField(
                        controller: passwordController,
                        type: TextInputType.visiblePassword,
                        suffix: LoginCubit.get(context).suffix,
                        // onSubmit: (value) {
                        //   if (formKey.currentState!.validate()) {
                        //     SocialLoginCubit.get(context).userLogin(
                        //     email: emailController.text,
                        //     password: passwordController.text,
                        //     );
                        //   }
                        // },
                        isPassword: LoginCubit.get(context).isPassword,
                        suffixPressed: () {
                          LoginCubit.get(context)
                              .changePasswordVisibility();
                        },
                        validate: (value) {
                          if (value.isEmpty) {
                            return 'password is too short';
                          }
                          return null;
                        },
                        label: 'Password',
                        prefix: Icons.lock_outline,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Conditional.single(
                        context: context,
                        conditionBuilder: (BuildContext context) =>
                            state is! LoginLoadingState,
                        widgetBuilder: (BuildContext context) =>
                            defaultButton(
                          function: () {
                            if (formKey.currentState!.validate()) {
                              LoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          text: 'login',
                          isUpperCase: true,
                        ),
                        fallbackBuilder: (BuildContext context) =>
                            const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account? '),
                          defaultTextButton(
                            function: () {
                              navigateTo(
                                context,
                                ChatRegisterScreen(),
                              );
                            },
                            text: 'register',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
