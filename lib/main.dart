import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/providers/user_picked_image_provider.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:provider/provider.dart';

import 'utils/colors.dart' as util_color;
import './responsive/responsive_layout.dart';
import './responsive/mobile_screen_layout.dart';
import './responsive/web_screen_layout.dart';

import '../providers/user_provider.dart';

import './screens/login_screen.dart';
import './screens/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyCajz27TEswye-Y7VCNFlcaYNkO2btwJ7E",
      appId: "1:1052522110050:web:abbab0bec0e9b99f32853b",
      messagingSenderId: "1052522110050",
      projectId: "instagram-clone-33b2d",
      storageBucket: "instagram-clone-33b2d.appspot.com",
    ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UserPickedProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram clone',
        theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: util_color.mobileBackgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // If user has been authenticated
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
                // If there was some kind of error.
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("{$snapshot.error}"),
                );
                
              }

              // If it's waiting for the auth state to come back
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: util_color.primaryColor,
                  ),
                );
              }
            }
            // If user hasn't been authenticated and connectionstate is not working go to log in screen
            return LogInScreen();
          },
        ),
        routes: {
          LogInScreen.routeName: (context) => LogInScreen(),
          SignUpScreen.routeName: (context) => SignUpScreen(),
          CommentScreen.routeName: (_)=>CommentScreen(),
        },
      ),
    );
  }
}
