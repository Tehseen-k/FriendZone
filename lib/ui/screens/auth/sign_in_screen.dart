import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:code_structure/core/constants/app_asset.dart';
import 'package:code_structure/core/constants/auth_text_feild.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/custom_widgets/buttons/custom_button.dart';
import 'package:code_structure/custom_widgets/buttons/social_button.dart';
import 'package:code_structure/main.dart';
import 'package:code_structure/models/User.dart';
import 'package:code_structure/ui/screens/auth/sign_up_screen.dart';
import 'package:code_structure/ui/screens/root_screen/root_screen.dart';
import 'package:code_structure/ui/screens/setup_profile/setup_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final result = await Amplify.Auth.signIn(
        username: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (result.isSignedIn) {
        await _checkUserProfile();
      }
    } on AuthException catch (e) {
      Get.snackbar("Error", e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithSocial(AuthProvider provider) async {
    setState(() => _isLoading = true);
    try {
      final result = await Amplify.Auth.signInWithWebUI(provider: provider);
      if (result.isSignedIn) {
        await _checkUserProfile();
      }
    } on AuthException catch (e) {
      Get.snackbar("Error", e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _checkUserProfile() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      final request = ModelQueries.get(
        User.classType,
        UserModelIdentifier(id: user.userId),
      );
      final response = await Amplify.API.query(request: request).response;
      if (response.data != null) {
        userModel = response.data;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => RootScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => SetupProfileScreen()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('')));
      Get.snackbar("Error", "Error checking profile");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                'Sign in to continue to your account',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                decoration:
                    authFieldDecoration.copyWith(hintText: "Enter your Email"),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Email is required';
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value))
                    return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: authFieldDecoration.copyWith(
                    hintText: "Enter your Password"),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Password is required';
                  if (value.length < 6) return 'Minimum 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      name: "  Login",
                      onPressed: _signInWithEmail,
                      textColor: blackColor,
                    ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "OR",
                      style: style16B.copyWith(color: blackColor),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 40),
              CustomSocialIconButton(
                  onPressed: () {
                    _signInWithSocial(AuthProvider.google);
                  },
                  imagePath: AppAssets().GoogleIcon,
                  textcolor: blackColor,
                  name: "SignIn With Google",
                  color: whiteColor),
              20.verticalSpace,
              CustomSocialIconButton(
                  onPressed: () {
                    _signInWithSocial(AuthProvider.google);
                  },
                  imagePath: AppAssets().FacebookIcon,
                  textcolor: whiteColor,
                  name: "Login with Facebook",
                  color: textFilledColor),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Get.offAll(SignupScreen());
                    },
                    child: Text(
                      "Sign Up",
                      style: style16B.copyWith(color: blackColor),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
