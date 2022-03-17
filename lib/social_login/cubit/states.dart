abstract class LoginStates{}
class LoginInitialState extends LoginStates{}

class LoginLoadingState extends LoginStates{}

class LoginSuccessState extends LoginStates{
  final String uId;

  LoginSuccessState(this.uId);
}
class LogoutSuccessState extends LoginStates{}
class LoginErrorState extends LoginStates {
  final String error;

  LoginErrorState(this.error);
}
class AddDataLoadingState extends LoginStates{}
class AddDataErrorState extends LoginStates{}
class AddDataSuccessState extends LoginStates{}
class ChangePasswordVisibilityState extends LoginStates{}

class GetDataLoadingState extends LoginStates{}
class GetDataSuccessState extends LoginStates{}
class GetDataErrorState extends LoginStates{}
