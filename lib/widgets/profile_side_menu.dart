import 'package:flutter/material.dart';
import 'package:insta_clone/models/firebase_auth_state.dart';
import 'package:insta_clone/screens/auth_screen.dart';
import 'package:provider/provider.dart';
import '../constants/screen_size.dart';

class ProfileSideMenu extends StatelessWidget {

  final double menuWidth;
  const ProfileSideMenu({Key? key, required this.menuWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: menuWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(
                'Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.black87,
              ),
              title: Text('Logout'),
              onTap: (){
                Provider.of<FirebaseAuthState>(context, listen: false)
                    .signOut();
              }
            )
          ]
        ),
      ),
    );
  }
}
