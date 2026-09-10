// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:workwise/core/utils/app_validator.dart';
// import 'package:workwise/features/login/logic/login_cubit.dart';
// import 'package:workwise/features/login/logic/login_state.dart';
// //  import 'package:workwise/lib\features\login\logic\login_cubit.dart';
// //  import 'package:workwise/features/splash/logic/login_state.dart';

// class LoginForm extends StatelessWidget {
//   const LoginForm({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.read<LoginCubit>();

//     return Form(
//       key: cubit.formKey,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Work Email',
//               style: TextStyle(color: Color(0xff202B33), fontSize: 13, fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(height: 8),
//             TextFormField(
//               controller: cubit.emailController,
//               style: const TextStyle(color:  Color(0xff202B33)),
//               keyboardType: TextInputType.emailAddress,
//               validator: AppValidators.email(
//                 emptyMessage: 'Please enter your work email',
//                 invalidMessage: 'Invalid work email format',
//               ),
//               decoration: _inputDecoration(
//                 hintText: 'name@company.com',
//                 prefixIcon: Icons.email_outlined,
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Password',
//               style: TextStyle(color:  Color(0xff202B33), fontSize: 13, fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(height: 8),
//             BlocBuilder<LoginCubit, LoginState>(
//               buildWhen: (_, current) => current is LoginPasswordVisibilityState,
//               builder: (context, state) {
//                 return TextFormField(
//                   controller: cubit.passwordController,
//                   obscureText: cubit.isPasswordHidden,
//                   style: const TextStyle(color: Colors.white),
//                   validator: AppValidators.password(
//                     emptyMessage: 'Please enter your password',
//                   ),
//                   decoration: _inputDecoration(

//                     hintText: 'Enter your password',
//                     prefixIcon: Icons.lock_outline,
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         cubit.isPasswordHidden
//                             ? Icons.visibility_off_outlined
//                             : Icons.visibility_outlined,
//                         color: Colors.white54,
//                         size: 20,
//                       ),
//                       onPressed: () => cubit.togglePasswordVisibility(),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     BlocBuilder<LoginCubit, LoginState>(
//                       buildWhen: (_, current) => current is LoginKeepMeSignedInState,
//                       builder: (context, state) {
//                         return SizedBox(
//                           width: 24,
//                           height: 24,
//                           child: Checkbox(
//                             value: cubit.keepMeSignedIn,
//                             activeColor: const Color(0xFF2B5278),
//                             checkColor:  Color(0xff202B33),
//                             side: const BorderSide(color: Colors.white54),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             onChanged: (val) => cubit.toggleKeepMeSignedIn(val),
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(width: 8),
//                     const Text(
//                       'Keep me signed in',
//                       style: TextStyle(color:  Color(0xff202B33), fontSize: 13),
//                     ),
//                   ],
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                  TODO: Go to Forgot Password Screen
//                   },
//                   child: const Text(
//                     'Forgot Password',
//                     style: TextStyle(
//                       color: Color(0xff202B33),
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             BlocBuilder<LoginCubit, LoginState>(
//               builder: (context, state) {
//                 final isLoading = state is LoginLoadingState;
//                 return SizedBox(
//                   width: double.infinity,
//                   height: 48,
//                   child: ElevatedButton(
//                     onPressed: isLoading ? null : () => cubit.login(),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF22364F),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         side: const BorderSide(color: Colors.white24, width: 0.8),
//                       ),
//                     ),
//                     child: isLoading
//                         ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                         : const Text(
//                             'Sign In',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   InputDecoration _inputDecoration({
//     required String hintText,
//     required IconData prefixIcon,
//     Widget? suffixIcon,
//   }) {
//     return InputDecoration(
//       hintText: hintText,
//       hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
//       prefixIcon: Icon(prefixIcon, color: Colors.white54, size: 20),
//       suffixIcon: suffixIcon,
//       filled: true,
//       fillColor: const Color(0xFF1B2A3B),
//       contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: Colors.white12),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: Colors.white12),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: Colors.blueAccent),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: Colors.redAccent),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workwise/core/utils/app_validator.dart';
import 'package:workwise/features/auth/login/logic/login_cubit.dart';
import 'package:workwise/features/auth/login/logic/login_state.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  // الألوان الرئيسية المستخرجة من التصميم
  static const Color _textColor = Color(0xFF1E293B);
  static const Color _hintColor = Color(0xFF94A3B8);
  static const Color _borderColor = Color(0xFFE2E8F0);
  static const Color _inputFillColor = Colors.white;
  static const Color _buttonColor = Color(0xFF223A53);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return Form(
      key: cubit.formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Work Email Label & Field
            const Text(
              'Work Email',
              style: TextStyle(
                color: _textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: cubit.emailController,
              style: const TextStyle(color: _textColor, fontSize: 14),
              keyboardType: TextInputType.emailAddress,
              validator: AppValidators.email(
                emptyMessage: 'Please enter your work email',
                invalidMessage: 'Invalid work email format',
              ),
              decoration: _inputDecoration(
                hintText: 'name@company.com',
                prefixIcon: Icons.mail_outline_rounded,
              ),
            ),
            const SizedBox(height: 16),

            // Password Label & Field
            const Text(
              'Password',
              style: TextStyle(
                color: _textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            BlocBuilder<LoginCubit, LoginState>(
              buildWhen: (_, current) =>
                  current is LoginPasswordVisibilityState,
              builder: (context, state) {
                return TextFormField(
                  controller: cubit.passwordController,
                  obscureText: cubit.isPasswordHidden,
                  style: const TextStyle(color: _textColor, fontSize: 14),
                  validator: AppValidators.password(
                    emptyMessage: 'Please enter your password',
                  ),
                  decoration: _inputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        cubit.isPasswordHidden
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: _hintColor,
                        size: 20,
                      ),
                      onPressed: () => cubit.togglePasswordVisibility(),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Keep me signed in & Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    BlocBuilder<LoginCubit, LoginState>(
                      buildWhen: (_, current) =>
                          current is LoginKeepMeSignedInState,
                      builder: (context, state) {
                        return SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: cubit.keepMeSignedIn,
                            activeColor: _buttonColor,
                            checkColor: Colors.white,
                            side: const BorderSide(
                              color: _hintColor,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (val) => cubit.toggleKeepMeSignedIn(val),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Keep me signed in',
                      style: TextStyle(
                        color: _textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: Go to Forgot Password Screen
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Color(0xFF3B82F6), // Blue accent text
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sign In Button
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                final isLoading = state is LoginLoadingState;
                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () => cubit.login(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _buttonColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: _hintColor, fontSize: 14),
      prefixIcon: Icon(prefixIcon, color: _hintColor, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: _inputFillColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: _borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: _borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: _buttonColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}
