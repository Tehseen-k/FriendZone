// ignore_for_file: unnecessary_string_interpolations

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:code_structure/core/constants/auth_text_feild.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/custom_widgets/buttons/custom_button.dart';
import 'package:code_structure/main.dart';
import 'package:code_structure/ui/screens/auth/opt_screen.dart';
import 'package:code_structure/ui/screens/auth/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final result = await Amplify.Auth.signUp(
        username: _emailController.text.trim(),
        password: _passwordController.text,
        options: SignUpOptions(
          userAttributes: {
            CognitoUserAttributeKey.email: _emailController.text.trim(),
            CognitoUserAttributeKey.name: _fullNameController.text.trim(),
          },
        ),
      );

      if (result.isSignUpComplete) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'userEmail', "${_emailController.text}"); // or any other value
        await prefs.setBool('isSignedIn', true);

        Get.snackbar(
            "Success", "Verification complete! Please complete your profile.");
        Get.offAll(AuthWrapper());
      }

      // if (result.isSignUpComplete == false) {
      //   Get.snackbar("Sucess", "Check your email otp send sucessfully");
      //   // Navigate to OTP screen
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (_) => OTPScreen(
      //         email: _emailController.text.trim(),
      //       ),
      //     ),
      //   );
      // }
    } on AuthException catch (e) {
      Get.snackbar("Signup Failed", e.message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Icon(Icons.lock, size: 80, color: buttonColor),
                const SizedBox(height: 20),
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: buttonColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sign Up to continue to your account',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _fullNameController,
                  decoration:
                      authFieldDecoration.copyWith(hintText: "Full Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Full Name is required';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: authFieldDecoration.copyWith(hintText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email required';
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value))
                      return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration:
                      authFieldDecoration.copyWith(hintText: "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Password required';
                    if (value.length < 6) return 'Minimum 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        name: "Sign Up",
                        onPressed: _signUp,
                        textColor: blackColor),
                30.verticalSpace,
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Get.offAll(AuthScreen());
                    },
                    child: Text(
                      "Sign In",
                      style: style16B.copyWith(color: blackColor),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
