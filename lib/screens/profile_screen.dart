import 'package:flutter/material.dart';

import '../constants/screen_size.dart';
import '../widgets/profile_body.dart';
import '../widgets/profile_side_menu.dart';

final duration = Duration(milliseconds: 300);

class ProfileScreen extends StatefulWidget {

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final duration = Duration(milliseconds: 200);
  double bodyXPos = 0;

  MenuStatus _menuStatus = MenuStatus.closed;
  final menuWidth = size!.width/3*2;
  double menuXPos = size!.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            AnimatedContainer(
              duration : duration,
              curve: Curves.fastOutSlowIn,
              transform: Matrix4.translationValues(bodyXPos,0,0),
              child: ProfileBody(onMenuChanged: (){
                setState(() {
                  _menuStatus = (_menuStatus == MenuStatus.closed)
                      ? MenuStatus.open
                      : MenuStatus.closed;
                  switch(_menuStatus){
                    case MenuStatus.open:
                      bodyXPos = -menuWidth;
                      menuXPos = size!.width - menuWidth;
                      break;
                    case MenuStatus.closed:
                      bodyXPos = 0;
                      menuXPos = size!.width;
                      break;
                  }
                });
              }),
            ),
            AnimatedContainer(
              duration : duration,
              transform: Matrix4.translationValues(menuXPos,0,0),
              child: ProfileSideMenu(menuWidth: menuWidth,),
            ),
          ],
        )
    );
  }
}

enum MenuStatus{
  closed,
  open,
}