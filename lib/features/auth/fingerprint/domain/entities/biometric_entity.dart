class BiometricEntity {
  const BiometricEntity({
    required this.isEnabled,
    required this.biometricToken,
  });

  final bool isEnabled;
  final String? biometricToken;
}