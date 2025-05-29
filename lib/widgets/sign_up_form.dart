import 'package:flutter/material.dart';
import 'package:insta_clone/constants/common_size.dart';

import '../home_page.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                ),
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
                },
              ),
              SizedBox(
                height: common_xs_gap,
              ),
              TextFormField(
                controller: _passwordController,
                cursorColor: Colors.black54,
                obscureText: true,
                decoration: _textinputDecor("Password"),
                validator: (text) {
                  if (text != null && text.isNotEmpty && text.length > 5) {
                    return null;  // 유효한 경우
                  }
                  return 'Invalid Password';  // 그 외
                },
              ),
              SizedBox(
                height: common_xs_gap,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                cursorColor: Colors.black54,
                obscureText: true,
                decoration: _textinputDecor("Confirm Password"),
                validator: (text) {
                  if (text != null && text.isNotEmpty && _passwordController.text == text) {
                    return null;  // 유효한 경우
                  }
                  return 'Password Does not Match';  // 그 외
                },
              ),
              SizedBox(
                height: common_xs_gap,
              ),
              _submitButton(context),
              SizedBox(
                height: common_gap
              ),
              _orDivider(),
              TextButton.icon(
                icon: Image.asset('assets/images/Facebook-logo.png', width: 40, height: 40,),
                onPressed: (){

                },
                label: Text(
                  'Login with Facebook',
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextButton _submitButton(BuildContext context) {
    return TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(common_s_gap),
                )
              ),
              onPressed: (){
                if(_formKey.currentState!.validate()){
                  print('Validation success');
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => Homepage()
                      )
                  );
                }
              },
              child: Text (
                'Join',
                style: TextStyle(color: Colors.white,),
              ),
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
}
