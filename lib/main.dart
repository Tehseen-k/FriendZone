// ignore_for_file: unused_element

import 'dart:async';

import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/models/ModelProvider.dart';
import 'package:code_structure/ui/screens/auth/sign_in_screen.dart';
import 'package:code_structure/ui/screens/setup_profile/setup_profile_screen.dart';
import 'package:code_structure/ui/screens/root_screen/root_screen.dart';
import 'package:code_structure/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:get/route_manager.dart';
import 'amplifyconfiguration.dart';

//AKIAVY2PGWXN3VQV5QQX
//UDxa5iyjraG9RgGpQO1GrLkPg5jOF9AQkZkIk6wC
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) => runApp(const MyApp()));

  await _configureAmplify();
}

Future<void> _configureAmplify() async {
  try {
    final auth = AmplifyAuthCognito();
    final storage = AmplifyStorageS3();
    final api = AmplifyAPI(
      options: APIPluginOptions(modelProvider: ModelProvider.instance),
    );
    await Amplify.addPlugins([auth, api, storage]);
    await Amplify.configure(amplifyconfig);
  } catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}

User? userModel;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(
          MediaQuery.sizeOf(context).width, MediaQuery.sizeOf(context).height),
      minTextAdapt: true,
      splitScreenMode: true,
      child:
          // Authenticator(
          //   child:
          GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.white,
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: whiteColor,
          ),
          scaffoldBackgroundColor: whiteColor,
          appBarTheme: AppBarTheme(
            backgroundColor: whiteColor,
            surfaceTintColor: whiteColor,
            shadowColor: whiteColor,
            foregroundColor: whiteColor,
          ),
          fontFamily: "Nunito",
        ),
        home: SplashScreen(),
        //
      ),
      //   ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  Future getUser() async {
    final user = await Amplify.Auth.getCurrentUser();
    try {
      final request = ModelQueries.get(
        User.classType,
        UserModelIdentifier(id: user.userId),
      );
      final response = await Amplify.API.query(request: request).response;
      final data = response.data;
      print("user ${response.data}");
      userModel = data;
      return data;
    } on ApiException catch (e) {
      safePrint('Query failed: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Amplify.Auth.fetchAuthSession(),
      builder: (context, snapshot) {
        print("hereeee");
        if (snapshot.hasData) {
          final authState = snapshot.data!;
          print("hereeee2 ${snapshot.data?.isSignedIn}");
          if (authState.isSignedIn) {
            return FutureBuilder(
              future: getUser(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.data != null) {
                  return RootScreen(); // Navigate to root screen if user exists
                }
                return SetupProfileScreen(); // Show setup profile if user doesn't exist
              },
            );
          }
        }
        return AuthScreen();
      },
    );
  }
}
