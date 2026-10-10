abstract class ResetPasswordState {}

class ResetPasswordInitialState extends ResetPasswordState {}

class ResetPasswordLoadingState extends ResetPasswordState {}

class ResetPasswordSuccessState extends ResetPasswordState {
  ResetPasswordSuccessState(this.message);

  final String message;
}

class ResetPasswordErrorState extends ResetPasswordState {
  ResetPasswordErrorState(this.message);

  final String message;
}