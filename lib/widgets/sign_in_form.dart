import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/common_size.dart';
import '../home_page.dart';
import '../models/firebase_auth_state.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(common_gap),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(
                height: 260,
                child: Image.asset(
                  'assets/images/instagram_text_logo.png',
                  fit: BoxFit.contain,
                )
              ),
              TextFormField(
                controller: _emailController,
                cursorColor: Colors.black54,
                decoration: _textinputDecor("Email"),
                validator: (text) {
                  if (text != null && text.isNotEmpty && text.contains('@')) {
                    return null;  // 유효한 경우
                  }
                  return 'Invalid Email';  // 그 외
                }
              ),
              const SizedBox(
                height: common_xs_gap
              ),
              TextFormField(
                controller: _passwordController,
                cursorColor: Colors.black54,
                obscureText: true,
                decoration: _textinputDecor("Password"),
                validator: (text) {
                  if (text != null && text.isNotEmpty && text.length > 5) {
                    return null; // 유효한 경우
                  }
                  return 'Invalid Password'; // 그
                },// 외
              ),
              TextButton(
                onPressed: (){


                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Passowrd?',
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ),
              SizedBox(
                height: common_xs_gap,
              ),
              _submitButton(context),
              SizedBox(
                height: common_xs_gap,
              ),
              _orDivider(),
              TextButton.icon(
                onPressed: (){
                },
                icon: Image.asset('assets/images/Facebook-logo.png', width: 40, height: 40,),
                label: Text(
                  'Login with Facebook',
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ]
          )
        )
      )
    );
  }

  InputDecoration _textinputDecor(String hint) {
    return InputDecoration(
        hintText: hint,
        enabledBorder: _activeInputBorder(Colors.grey),
        errorBorder: _activeInputBorder(Colors.redAccent),
        focusedBorder: _activeInputBorder(Colors.grey),
        focusedErrorBorder: _activeInputBorder(Colors.redAccent),
        filled: true,
        fillColor: Colors.grey[100]
    );
  }

  OutlineInputBorder _activeInputBorder(Color color) {
    return OutlineInputBorder(
        borderSide: BorderSide(color: color),
        borderRadius: BorderRadius.circular(common_s_gap)
    );
  }

  Stack _orDivider() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          left: 0,
          right: 0,
          height: 1,
          child: Container(
              color: Colors.grey[300],
              height: 1
          ),
        ),
        Container(
            color: Colors.grey[50],
            height: 3,
            width: 60
        ),
        Text(
          'OR',
          style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold,),
        ),
      ],
    );
  }

  Widget _submitButton(BuildContext context) { // 반환 타입을 Widget으로 변경
    // FirebaseAuthState의 상태를 watch하여 로딩 중일 때 버튼을 비활성화하거나 인디케이터를 표시할 수 있습니다.
    final authState = context.watch<FirebaseAuthState>();

    return TextButton(
      style: TextButton.styleFrom(
          backgroundColor: authState.firebaseAuthStatus == FirebaseAuthStatus.progress
              ? Colors.grey // 로딩 중일 때 비활성화된 것처럼 보이게
              : Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(common_s_gap),
          )),
      onPressed: authState.firebaseAuthStatus == FirebaseAuthStatus.progress
          ? null // 로딩 중일 때 버튼 비활성화
          : () {
        if (_formKey.currentState!.validate()) {
          print('Validation success, attempting login...');
          // ✅ FirebaseAuthState의 login 메서드 호출
          Provider.of<FirebaseAuthState>(context, listen: false).login(
              email: _emailController.text.trim(), // trim() 추가 권장
              password: _passwordController.text);
          // ❗️ 직접적인 화면 이동 로직은 제거합니다.
          // 상태 변경에 따라 MyApp 위젯의 Consumer가 화면을 전환할 것입니다.
          // Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(builder: (context) => Homepage()));
        }
      },
      child: authState.firebaseAuthStatus == FirebaseAuthStatus.progress
          ? const SizedBox( // 로딩 중일 때 인디케이터 표시
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      )
          : const Text( // const 추가
        'Login',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
