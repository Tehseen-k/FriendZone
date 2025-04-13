import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/core/constants/text_style.dart';
import 'package:code_structure/custom_widgets/buttons/custom_button.dart';
import 'package:code_structure/main.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  const OTPScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  bool _isResendEnabled = false;
  int _seconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _seconds = 30;
    _isResendEnabled = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        setState(() => _isResendEnabled = true);
        _timer?.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  Future<void> _confirmSignUp() async {
    setState(() => _isLoading = true);
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: widget.email,
        confirmationCode: _codeController.text.trim(),
      );

      if (result.isSignUpComplete) {
        Get.snackbar(
            "Success", "Verification complete! Please complete your profile.");

        Get.offAll(AuthWrapper());
      } else {
        Get.snackbar("Error", "Verification not complete.");
      }
    } on AuthException catch (e) {
      Get.snackbar("Error", e.message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resendCode() async {
    try {
      await Amplify.Auth.resendSignUpCode(username: widget.email);
      Get.snackbar("Success", "Confirmation code resent to your email.");
      _startTimer();
    } on AuthException catch (e) {
      Get.snackbar("Error", e.message);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          "Verify OTP",
          style: style18B.copyWith(color: blackColor),
        ),
        centerTitle: true,
        backgroundColor: whiteColor,
        shadowColor: whiteColor,
        foregroundColor: whiteColor,
        surfaceTintColor: whiteColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Enter the 6-digit code sent to your email.",
                style: style18B.copyWith(color: blackColor),
              ),
              const SizedBox(height: 20),
              Pinput(
                length: 6,
                controller: _codeController,
                defaultPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: style18B,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onCompleted: (pin) {
                  _codeController.text = pin;
                },
              ),
              const SizedBox(height: 40),
              _isLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      name: 'Confirm',
                      onPressed: _confirmSignUp,
                    ),
              const SizedBox(height: 20),
              _isResendEnabled
                  ? TextButton(
                      onPressed: _resendCode,
                      child: const Text("Resend Code"),
                    )
                  : Text(
                      "Resend in $_seconds seconds",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
