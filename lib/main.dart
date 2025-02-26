import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:code_structure/core/constants/colors.dart';
import 'package:code_structure/firebase_options.dart';
import 'package:code_structure/models/ModelProvider.dart';
import 'package:code_structure/ui/screens/auth/setup_profile/setup_profile_screen.dart';
import 'package:code_structure/ui/screens/root_screen/root_screen.dart';
import 'package:code_structure/ui/start_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'amplifyconfiguration.dart';
//AKIAVY2PGWXN3VQV5QQX
//UDxa5iyjraG9RgGpQO1GrLkPg5jOF9AQkZkIk6wC
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  //grfEY3W[
  //AKIAVY2PGWXNXCRJM3WM
  //588rjI9Bheu18wnNaliHbnPGmHgUJ6lFnkM3nJx+
  // await setupLocator();
  await _configureAmplify();


  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ///
    /// ScreenUtilInit
    ///
    return ScreenUtilInit(
        designSize: Size(MediaQuery.sizeOf(context).width,
            MediaQuery.sizeOf(context).height),
        minTextAdapt: true,
        splitScreenMode: true,
        child: Authenticator(
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  bottomAppBarTheme: BottomAppBarTheme(
                      color: Colors.white,
                      shadowColor: Colors.white,
                      surfaceTintColor: Colors.white),
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor: whiteColor,
                  ),
                  scaffoldBackgroundColor: whiteColor,
                  appBarTheme: AppBarTheme(
                      backgroundColor: whiteColor,
                      surfaceTintColor: whiteColor,
                      shadowColor: whiteColor,
                      foregroundColor: whiteColor),
          
                  ///
                  /// Font Family
                  ///
                  fontFamily: "Nunito"),
          
              ///
              /// Start Screen
              ///
              home: AuthWrapper(),
              builder: Authenticator.builder(),
              ),
        ));
  }
}
// main.dart


Future<void> _configureAmplify() async {
  try {
    final auth = AmplifyAuthCognito();
    final storage = AmplifyStorageS3();
    final api = AmplifyAPI( options: APIPluginOptions(modelProvider: ModelProvider.instance),); // Add this line
    await Amplify.addPlugins([auth, api,storage]); // Add both plugins
    await Amplify.configure(amplifyconfig);
  } catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}


User? userModel;
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
    return StreamBuilder<AuthSession>(
      stream: Amplify.Auth.fetchAuthSession().asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final authState = snapshot.data!;
          if (authState.isSignedIn) {
            return FutureBuilder(
              future: getUser(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.data != null) {
                  return  RootScreen(); // Navigate to root screen if user exists
                }
                return  SetupProfileScreen(); // Show setup profile if user doesn't exist
              },
            );
          }
        }
        return Authenticator(child: AuthScreen());
      },
    );
  }
}



// // Sign Up/In Screens
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  // Future<void> _signUpWithEmail(
  //     String email, String password, String name) async {
  //   try {
  //     await Amplify.Auth.signUp(
  //       username: email,
  //       password: password,
  //       options: CognitoSignUpOptions(
  //         userAttributes: {
  //           CognitoUserAttributeKey.email: email,
  //           CognitoUserAttributeKey.name: name,
  //         },
  //       ),
  //     );
  //   } on AuthException catch (e) {
  //     print('Sign up failed: ${e.message}');
  //   }
  // }

  Future<void> _signInWithEmail(String email, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );
      if (result.isSignedIn) {
        // Navigate to home
      }
    } on AuthException catch (e) {
      print('Sign in failed: ${e.message}');
    }
  }

 Future<void> _signInWithSocial(AuthProvider provider) async {
  try {
    final result = await Amplify.Auth.signInWithWebUI(provider: provider);
    if (result.isSignedIn) {
      // Get user attributes
      final attributes = await Amplify.Auth.fetchUserAttributes();
      String? profileImageUrl;
      
      for (final attribute in attributes) {
        if (attribute.userAttributeKey == CognitoUserAttributeKey.picture) {
          profileImageUrl = attribute.value;
        }
      }

      // If using Facebook and URL isn't direct
      if (provider == AuthProvider.facebook && profileImageUrl != null) {
        profileImageUrl = "$profileImageUrl?width=400&height=400";
      }

      print("Profile image URL: $profileImageUrl");
      // Navigate to profile screen with image URL
    }
  } on AuthException catch (e) {
    print('Social sign in failed: ${e.message}');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _signInWithSocial(AuthProvider.google),
              child: const Text('Sign in with Google'),
            ),
            ElevatedButton(
              onPressed: () => _signInWithSocial(AuthProvider.facebook),
              child: const Text('Sign in with Facebook'),
            ),
          ],
        ),
      ),
    );
  }
}


// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   String _name = '';
//   String _email = '';
//   String _fcmToken = '';
//   List<String> _interests = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserProfile();
//   }

//   Future<void> _loadUserProfile() async {
//     try {
//       print("hereee1");
//       final user = await Amplify.Auth.getCurrentUser();
//       print("hereee2");
//       _email = user.userId;
//       print("hereee3");
//       final attributes = await Amplify.Auth.fetchUserAttributes();
//       print("hereee4");
//       for (final attribute in attributes) {
//         if (attribute.userAttributeKey == CognitoUserAttributeKey.name) {
//           _name = attribute.value;
//         }
//       }
// print("hereee5");
//       // Load additional data from DynamoDB using the correct API call syntax
//       try {
//         final restOperation = Amplify.API.get(
          
//            '/items/${user.userId}',
//            apiName: 'friendzone',
//         );
        
//         final response = await restOperation.response;
//         print("heree 2 ${response.statusCode}");
//           print("heree 02 ${response.body.first}");
//             print("heree 12 ${response.bodyBytes}");
//               print("heree 22 ${restOperation.requestProgress}");
//                print("heree 22 ${restOperation.responseProgress}");
//         final userData = response.decodeBody();
//         print("heree 3${userData}");
//         setState(() {
//           // _fcmToken = userData['fcmToken'] ?? '';
//           // _interests = List<String>.from(userData['interests'] ?? []);
//            _isLoading = false;
//         });
//       } on ApiException catch (e) {
//         print('API call failed: $e');
//         setState(() => _isLoading = false);
//       }
//     } catch (e) {
//       print('Error loading profile: $e');
//       setState(() => _isLoading = false);
//     }
//   }

//   Future<void> _signOut() async {
//     try {
//       await Amplify.Auth.signOut();
//     } catch (e) {
//       print('Error signing out: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: _signOut,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Name: $_name', style: const TextStyle(fontSize: 18)),
//             Text('Email: $_email', style: const TextStyle(fontSize: 18)),
//             Text('FCM Token: $_fcmToken', style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 20),
//             const Text('Interests:', style: TextStyle(fontSize: 18)),
//             ..._interests.map((interest) => Text('- $interest')),
//           ],
//         ),
//       ),
//     );
//   }
// }


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Authenticator(
//       child: MaterialApp(
//         title: 'Friend Zone',
//         theme: ThemeData(primarySwatch: Colors.blue),
//         home: const AuthWrapper(),
//         builder: Authenticator.builder(),
//       ),
//     );
//   }
// }


// main.dart
// import 'dart:convert';



// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await _configureAmplify();
//   runApp(const MyApp());
// }


// GraphQL endpoint: https://a35oicbrirauvdio5aszncqnui.appsync-api.us-east-1.amazonaws.com/graphql
// GraphQL API KEY: da2-4g4yshhdu5grdipswwcphrnzlm


      //  10.verticalSpace,
      //           TextFormField(
      //             decoration: authFieldDecoration.copyWith(
      //                 prefixIcon: Icon(
      //                   Icons.search,
      //                   color: greyColor,
      //                 ),
      //                 hintText: "Search Interests",
      //                 hintStyle: style14B.copyWith(color: greyColor),
      //                 fillColor: blackColor.withOpacity(0.04)),
      //           ),
      //           GridView.builder(
      //             padding: EdgeInsets.all(8.0),
      //             physics: NeverScrollableScrollPhysics(),
      //             shrinkWrap: true,
      //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //                 crossAxisCount: 3,
      //                 childAspectRatio: 1.4,
      //                 mainAxisSpacing: 10,
      //                 crossAxisSpacing: 10),
      //             itemCount: 9,
      //             itemBuilder: (BuildContext context, int index) {
      //               return GestureDetector(
      //                 onTap: () {},
      //                 child: Column(
      //                   children: [
      //                     CircleAvatar(
      //                       radius: 30.r,
      //                       backgroundImage:
      //                           AssetImage("$dynamicAssets/woman.png"),
      //                     ),
      //                     Text(
      //                       "Hiking",
      //                       style: style14B.copyWith(
      //                           color: blackColor, fontSize: 12),
      //                     )
      //                   ],
      //                 ),
      //               );
      //             },
      //           ),
           