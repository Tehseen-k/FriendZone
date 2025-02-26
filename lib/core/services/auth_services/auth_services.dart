import 'dart:math';

import 'package:code_structure/core/model/app_user.dart';
import 'package:code_structure/core/model/custom_auth_result.dart';
import 'package:code_structure/core/services/auth_services/auth_exception.dart';
import 'package:code_structure/core/services/db_services/database_services.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices extends ChangeNotifier {
  final _dbSerivices = DatabaseServices();
 // final _auth = FirebaseAuth.instance;
  final CustomAuthResult _authResult = CustomAuthResult();

  ///
  /// [SignUp] with email and password function
  ///

  Future<CustomAuthResult> signUpWithEmailAndPassword(AppUser appUser) async {
    // final credentials = await _auth.signInWithEmailAndPassword(
    //     email: appUser.email!, password: appUser.password!);
    try {
      /// If user signup fails without any exception and error code
      // if (credentials.user == null) {
      //   _authResult.status = false;
      //   _authResult.errorMessage =
      //       AuthExceptionsService.generateExceptionMessage(e);
      //   return _authResult;
      // }
      // if (credentials.user != null) {
      //   _authResult.status = true;
      //   _authResult.user = credentials.user;
      //   appUser.id = credentials.user!.uid;
      // }
    } catch (e) {
      debugPrint('Exception @sighupWithEmailPassword: $e');
      _authResult.status = false;
      _authResult.errorMessage =
          AuthExceptionsService.generateExceptionMessage(e);
    }

    return _authResult;
  }
}
