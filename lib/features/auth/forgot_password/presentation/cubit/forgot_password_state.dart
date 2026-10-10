abstract class ForgotPasswordState {}

class ForgotPasswordInitialState extends ForgotPasswordState {}

class SendOtpLoadingState extends ForgotPasswordState {}

class SendOtpSuccessState extends ForgotPasswordState {
  SendOtpSuccessState(this.email);

  final String email;
}

class SendOtpErrorState extends ForgotPasswordState {
  SendOtpErrorState(this.message);

  final String message;
}


class VerifyOtpLoadingState extends ForgotPasswordState {}

class VerifyOtpSuccessState extends ForgotPasswordState {
  VerifyOtpSuccessState(this.resetToken);

  final String resetToken;
}

class VerifyOtpErrorState extends ForgotPasswordState {
  VerifyOtpErrorState(this.message);

  final String message;
}


class ResendOtpLoadingState extends ForgotPasswordState {}

class ResendOtpSuccessState extends ForgotPasswordState {
  ResendOtpSuccessState(this.message);

  final String message;
}

class ResendOtpErrorState extends ForgotPasswordState {
  ResendOtpErrorState(this.message);

  final String message;
}