abstract class FingerprintState {}

class FingerprintInitialState extends FingerprintState {}

class FingerprintLoadingState extends FingerprintState {}

class FingerprintSuccessState extends FingerprintState {}

class FingerprintErrorState extends FingerprintState {
  final String message;
  
  // شلنا الـ const من هنا
  FingerprintErrorState(this.message);
}