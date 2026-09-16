abstract class ForgotPasswordState {}

// 1. الحالة الأولية
class ForgotPasswordInitialState extends ForgotPasswordState {}

// --- حالات إرسال كود الـ OTP للبريد الإلكتروني ---
class SendOtpLoadingState extends ForgotPasswordState {}

class SendOtpSuccessState extends ForgotPasswordState {
  final String email;
  SendOtpSuccessState(this.email);
}

class SendOtpErrorState extends ForgotPasswordState {
  final String message;
  SendOtpErrorState(this.message);
}

// --- حالات التحقق من كود الـ OTP ---
class VerifyOtpLoadingState extends ForgotPasswordState {}

class VerifyOtpSuccessState extends ForgotPasswordState {}

class VerifyOtpErrorState extends ForgotPasswordState {
  final String message;
  VerifyOtpErrorState(this.message);
}

// --- حالات إعادة إرسال الكود (Resend Code Timer & Action) ---
class ResendOtpLoadingState extends ForgotPasswordState {}

class ResendOtpSuccessState extends ForgotPasswordState {}

class ResendOtpErrorState extends ForgotPasswordState {
  final String message;
  ResendOtpErrorState(this.message);
}

// --- حالات تغيير كلمة السر الجديدة ---
class ResetPasswordLoadingState extends ForgotPasswordState {}

class ResetPasswordSuccessState extends ForgotPasswordState {}

class ResetPasswordErrorState extends ForgotPasswordState {
  final String message;
  ResetPasswordErrorState(this.message);
}