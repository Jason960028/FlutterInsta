import 'package:flutter/material.dart';
import 'package:insta_clone/widgets/sign_in_form.dart';
import 'package:insta_clone/widgets/sign_up_form.dart';

import '../screens/profile_screen.dart';

class FadeStack extends StatefulWidget {

  final int selectedForm;
  const FadeStack({
    super.key,
    required this.selectedForm,
  });

  @override
  State<FadeStack> createState() => _FadeStackState();
}

class _FadeStackState extends State<FadeStack> with SingleTickerProviderStateMixin{
  late AnimationController _animationController;
  List<Widget> forms = [SignUpForm(), SignInForm()];


  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: duration);
    _animationController.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(FadeStack oldWidget) {
    if(widget.selectedForm != oldWidget.selectedForm){
      _animationController.forward(from: 0.0);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: IndexedStack(
        index: widget.selectedForm,
        children: forms,
      ),
    );
  }
}
