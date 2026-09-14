abstract class SplashState {}

// اول ما يفتح
class SplashInitial extends SplashState {}

// بيحمل
class SplashLoading extends SplashState {}

// اول مره يفتح البرنامج
class FirstTimeState extends SplashState {}

// لو الجلسه لسه شغاله
class AuthenticatedState extends SplashState {}

// لو الجلسه انتهت وهنبدا من الاول نعمل لوج ان
class UnauthenticatedState extends SplashState {}
