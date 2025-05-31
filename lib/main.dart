import 'package:flutter/material.dart';
import 'package:insta_clone/constants/material_white.dart';
import 'package:insta_clone/home_page.dart';
import 'package:insta_clone/screens/auth_screen.dart';
import 'package:insta_clone/widgets/my_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/firebase_auth_state.dart';

// A global flag to track if Firebase has been initialized by this Dart isolate
bool _firebaseInitialized = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!_firebaseInitialized) {
    try {
      // Attempt to initialize Firebase.
      // Even if Firebase.app() or Firebase.apps.isEmpty might seem to indicate
      // no app from Dart's perspective after a hot restart,
      // we will only try to initialize once per Dart isolate's lifetime.
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBxL3JnaMtfEdqOqkhuzGaaowHj84IfnHQ", // Firebase 프로젝트 설정 > 일반 > 웹 API 키
          appId: "1:325836223963:ios:e4b2a261f69d550afce3fe",   // Firebase 프로젝트 설정 > 일반 > 내 앱 > 앱 ID (플랫폼별로 다를 수 있음)
          messagingSenderId: "325836223963", // Firebase 프로젝트 설정 > 클라우드 메시징 > 발신자 ID
          projectId: "instaclone-aa851", // Firebase 프로젝트 설정 > 일반 > 프로젝트 ID

        ),
      );
      print("Firebase.initializeApp executed.");
      _firebaseInitialized = true; // Set the flag after successful initialization
    } catch (e) {
      if (e is FirebaseException && e.code == 'duplicate-app') {
        print("Firebase app '[DEFAULT]' already existed natively, Dart flag updated.");
        _firebaseInitialized = true; // Assume it's initialized if native layer says so
      } else {
        print("An error occurred during Firebase initialization: $e");
        // Handle other potential initialization errors
      }
    }
  } else {
    print("Firebase already marked as initialized by Dart flag.");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuthState _firebaseAuthState = FirebaseAuthState();
  late Widget _currentWidget;

  @override
  Widget build(BuildContext context) {
    _firebaseAuthState.watchAuthChange();
    return ChangeNotifierProvider<FirebaseAuthState>.value(
      value: _firebaseAuthState,
      child: MaterialApp(
        home: Consumer<FirebaseAuthState>(
          builder: (BuildContext context, FirebaseAuthState firebaseAuthState, Widget? child) {
            switch(firebaseAuthState.firebaseAuthStatus){
              case FirebaseAuthStatus.signOut:
                _currentWidget = AuthScreen();
              case FirebaseAuthStatus.progress:
                MyProgressIndicator(containerSize: 30,);
              case FirebaseAuthStatus.signIn:
                _currentWidget = Homepage();
            }
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _currentWidget,
            );
          },
        ),
        theme: ThemeData(primarySwatch: white),
      ),
    );
  }
}