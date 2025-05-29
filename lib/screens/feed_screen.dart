import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/widgets/post.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   onPressed: null,
        //   icon: Icon(Icons.camera_alt, color: Colors.black),
        // ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 11.0),
          child: Text(
              'Instagram',
            style: TextStyle(fontFamily: 'VeganStyle', color: Colors.black87, fontSize: 18),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              onPressed: null,
                icon: ImageIcon(
                  AssetImage('assets/images/heart.png'),
                  color: Colors.black87,
                ),
            ),
            IconButton(
              onPressed: null,
              iconSize: 24,
              icon: ImageIcon(
                AssetImage('assets/images/messenger.png'), //gonna be message button
                color: Colors.black87,
              ),
            )
          ]
        )
      ),
      body: ListView.builder(
        itemBuilder: feedListBuilder,
        itemCount: 30,
      ),
    );
  }
  Widget feedListBuilder(BuildContext context, int index){
    return Post(index);
  }
}