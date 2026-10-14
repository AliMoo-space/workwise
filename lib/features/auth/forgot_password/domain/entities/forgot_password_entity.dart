class ForgotPasswordEntity {
  const ForgotPasswordEntity({
    required this.email,
    required this.resetToken,
  });

  final String email;
  final String resetToken;
}