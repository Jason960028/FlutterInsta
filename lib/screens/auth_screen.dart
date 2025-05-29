import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/widgets/fade_stack.dart';

import '../widgets/sign_in_form.dart';
import '../widgets/sign_up_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>{

  int selectedFrom = 0;
  late final TapGestureRecognizer _tapRecognizer;


  @override
  void initState() {
    super.initState();
    _tapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          selectedFrom = selectedFrom == 0 ? 1 : 0;
        });
      };
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();  // 포커스 해제 → 키보드 내림
        },
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              FadeStack(selectedForm: selectedFrom,),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical:16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey),),
                  ),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: (selectedFrom == 0)
                            ? "Already have an account? "
                            : "Don't have an account? ",
                        style: TextStyle(color: Colors.grey,),
                        children: [
                          TextSpan(
                            text: (selectedFrom == 0) ? "Sign In " : "Sign Up ",
                            style: TextStyle(color: Colors.blue,),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  selectedFrom = selectedFrom == 0 ? 1 : 0;
                                });
                              }
                          )
                        ]
                      )
                    ),
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
