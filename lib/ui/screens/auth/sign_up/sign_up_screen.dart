// ignore_for_file: use_key_in_widget_constructors

import 'package:code_structure/core/constants/app_asset.dart';
import 'package:code_structure/core/constants/auth_text_feild.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/custom_widgets/buttons/custom_button.dart';
import 'package:code_structure/custom_widgets/buttons/social_button.dart';
import 'package:code_structure/ui/screens/auth/login/login_screen.dart';
import 'package:code_structure/ui/screens/auth/setup_profile/setup_profile_screen.dart';
import 'package:code_structure/ui/screens/auth/sign_up/sign_up_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SignUpViewModel(),
      child: Consumer<SignUpViewModel>(
        builder: (context, model, child) => Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    50.verticalSpace,
                    Center(
                      child: Text(
                        "Friend Zone",
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w600, fontSize: 29),
                      ),
                    ),
                    20.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w800, fontSize: 20),
                      ),
                    ),
                    10.verticalSpace,
                    TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: authFieldDecoration.copyWith(
                        hintText: "Name",
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                          RegExp(
                              "[a-zA-Z0-9_]"), // Allows both lowercase and uppercase letters, numbers, and underscores.
                        ),
                      ],
                      onChanged: (val) {},
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Please enter the name";
                        } else if (!RegExp(r"^[a-zA-Z0-9_]+$")
                            .hasMatch(value)) {
                          return "Username must contain only letters, numbers, or underscores";
                        } else {
                          return null;
                        }
                      },
                    ),
                    10.verticalSpace,
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: authFieldDecoration.copyWith(
                        hintText: "Enter your email",
                      ),
                      onChanged: (val) {},
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return "Please enter email";
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                            .hasMatch(val)) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    10.verticalSpace,
                    TextFormField(
                      controller: model.passwordController,
                      obscureText: true, // Hides the text for password input
                      decoration: authFieldDecoration.copyWith(
                        hintText: "Enter your password",
                      ),
                      onChanged: (val) {},
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your password";
                        } else if (value.length < 8) {
                          return "Password must be at least 8 characters";
                        } else if (!RegExp(
                                r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[\W_]).+$')
                            .hasMatch(value)) {
                          return "Password must contain uppercase, lowercase, number, and special character";
                        }
                        return null;
                      },
                    ),
                    10.verticalSpace,
                    TextFormField(
                      controller: model.passwordController,
                      obscureText:
                          true, // Hides the text for confirm password input
                      decoration: authFieldDecoration.copyWith(
                        hintText: "Confirm Password",
                      ),
                      onChanged: (val) {},
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please confirm your password";
                        } else if (!RegExp(
                                r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[\W_]).+$')
                            .hasMatch(value)) {
                          return "Password must contain uppercase, lowercase, number, and special character";
                        } else if (value != model.passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    10.verticalSpace,
                    CustomButton(
                        name: "Sign Up",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // model.signUp();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SetupProfileScreen()));
                          }
                        }),
                    30.verticalSpace,
                    Center(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "Already a member?",
                            style: style14N.copyWith(
                                color: blackColor,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          WidgetSpan(
                              child: SizedBox(
                            width: 5.w,
                          )),
                          TextSpan(
                              text: "Login ",
                              style: style14.copyWith(
                                  color: buttonColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                })
                        ]),
                      ),
                    ),
                    20.verticalSpace,
                    Center(
                      child: Text(
                        "OR",
                        style: style16.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: blackColor),
                      ),
                    ),
                    20.verticalSpace,
                    CustomSocialIconButton(
                      onPressed: () {},
                      imagePath: AppAssets().FacebookIcon,
                      color: buttonColor,
                      name: "Continue with Facebook",
                      textcolor: whiteColor,
                    ),
                    15.verticalSpace,
                    CustomSocialIconButton(
                      name: "Continue with Google",
                      onPressed: () {},
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
            ),
          ),
        ),
      ),
    );
  }
}
