abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginErrorState extends LoginState {
  final String message;
  LoginErrorState(this.message);
}

// لو هظهر او اخفي الباسوورد
class LoginPasswordVisibilityState extends LoginState {}

// الشيك لوكس بتاع ال keep me signed in
class LoginKeepMeSignedInState extends LoginState {}