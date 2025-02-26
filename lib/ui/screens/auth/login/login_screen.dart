import 'package:code_structure/core/constants/app_asset.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/custom_widgets/buttons/custom_button.dart';
import 'package:code_structure/custom_widgets/buttons/social_button.dart';
import 'package:code_structure/custom_widgets/friend_zone/text_feild.dart';
import 'package:code_structure/ui/screens/auth/sign_up/sign_up_screen.dart';
import 'package:code_structure/ui/screens/root_screen/root_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //final _auth = FirebaseAuth.instance;

  // Future<void> register() async {
  //   try {
  //     await _auth.createUserWithEmailAndPassword(
  //         email: emailController.text, password: passwordController.text);
  //   } catch (e) {
  //     print("SignIn failed: $e");
  //   }
  // }

  // TextEditingController emailController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  // final _fromKey = GlobalKey<FormState>();
  // final RegExp _emailRegex = RegExp(
  //   r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  // );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            75.verticalSpace,
            Center(
              child: Text(
                "Login",
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                ),
              ),
            ),
            30.verticalSpace,
            Center(
              child: Text(
                "Friend Zone",
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w600, fontSize: 29),
              ),
            ),
            20.verticalSpace,
            CustomTextFeild(hinttext: "Enter your email or phone number "),
            CustomTextFeild(hinttext: "Enter your password"),
            10.verticalSpace,
            Text(
              "Forgot Password?",
              style: style14.copyWith(
                  color: blackColor, fontWeight: FontWeight.w700),
            ),
            30.verticalSpace,
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: CustomButton(
                  textColor: whiteColor,
                  name: "Login",
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RootScreen()));
                  }),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: "New Member? ",
                  style: style14N.copyWith(
                      color: blackColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: "Sign Up",
                  style: style14.copyWith(
                      color: buttonColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 15),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Add your navigation logic here (e.g., navigate to sign-up screen)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                )
              ]),
            ),
            20.verticalSpace,
            Text(
              "or",
              style: style16.copyWith(
                  fontSize: 18, fontWeight: FontWeight.w500, color: blackColor),
            ),
            20.verticalSpace,
            CustomSocialIconButton(
              onPressed: () {},
              name: "Continue with Facebook",
              imagePath: AppAssets().FacebookIcon,
              color: buttonColor,
              textcolor: whiteColor,
            ),
            15.verticalSpace,
            CustomSocialIconButton(
              onPressed: () {},
              name: "Continue with Google",
              imagePath: AppAssets().GoogleIcon,
              color: whiteColor,
              textcolor: blackColor,
            ),
            15.verticalSpace,
            CustomSocialIconButton(
              name: "Continue with Apple",
              onPressed: () {},
              imagePath: AppAssets().AppleIcon,
              color: blackColor,
              textcolor: whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
