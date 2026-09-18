// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
// import 'package:workwise/generated/app_localizations.dart';
// class LoginHeaderWidget extends StatelessWidget {
//   const LoginHeaderWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//         final localization = AppLocalizations.of(context);

//     return  Column(
//         children: [
//           Container(
//           width: double.infinity,
//           color: Theme.of(context).colorScheme.primary,
//           padding:  EdgeInsets.symmetric(vertical: 10.h),
//             child: Center(
//               child: Image.asset(
//                 'assets/images/logo2.jpeg',
//                 height: 150.h,
//                 width: 150.w,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//          Container(
//           width: double.infinity,
//           color: Theme.of(context).colorScheme.onSurface,
//           padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
//           child:  Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 localization.welcomeBack,
//                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onPrimary
//                 ),
//               ),
//               Text(
//                 localization.signInWithCorporateCredentials,
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

















import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:workwise/core/design_system/widgets/inputs/language_selector.dart';
import 'package:workwise/generated/app_localizations.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Column(
      children: [
        // الجزء العلوي الذي يحتوي على اللوجو وزر تغيير اللغة
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo2.jpeg',
                  height: 150.h,
                  width: 150.w,
                  fit: BoxFit.contain,
                ),
              ),

              Positioned(
                top: 0,
                left: 10.w,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: IconThemeData(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  child: const LanguageSelector(),
                ),
              ),
            ],
          ),
        ),

        // الجزء السفلي الذي يحتوي على نصوص الترحيب
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.onSurface,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.welcomeBack,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              Text(
                localization.signInWithCorporateCredentials,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}