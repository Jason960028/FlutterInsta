import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:insta_clone/widgets/my_progress_indicator.dart';
import 'package:insta_clone/widgets/rounded_avatar.dart';

import '../constants/common_size.dart';
import 'comment.dart';

class Post extends StatelessWidget {
  final int index;

  Post(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _postHeader(),
          _postImage(),
          _postActions(),
          _postLikes(),
          _postCaption(),

        ],
      ),
    );
  }

  Widget _postCaption(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap, vertical: common_xxs_gap),
      child: Comment(
        showImage: false,
        username: 'testingUser',
        text: 'I have money',
        dateTime: DateTime.now(),
      ),
    );
  }

  Padding _postLikes() {
    return Padding(
        padding: const EdgeInsets.only(left: common_gap),
        child: Text(
          '1234 likes',
          style: TextStyle(fontWeight: FontWeight.bold),

        ),
      );
  }

  Row _postActions() {
    return Row(
        children: <Widget>[
          IconButton(
            onPressed: null,
            icon: ImageIcon(AssetImage('assets/images/bookmark.png')),
            iconSize: 20,
            color: Colors.black87,
          ),
          IconButton(
            onPressed: null,
            icon: ImageIcon(AssetImage('assets/images/comment.png')),
            iconSize: 20,
            color: Colors.black87
          ),
          IconButton(
            onPressed: null,
            icon: ImageIcon(AssetImage('assets/images/react_message.png')),
            iconSize: 20,
            color: Colors.black87,
          ),
          Spacer(),
          IconButton(
            onPressed: null,
            icon: ImageIcon(AssetImage('assets/images/heart.png')),

            color: Colors.black87
          ),
        ]
      );
  }

  Widget _postHeader(){
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(common_xxs_gap),
          child: RoundedAvatar(),
        ),
        Expanded(child: Text('username')),
        IconButton(
          onPressed: null,
          icon: Icon(
            Icons.more_horiz,
            color: Colors.black87,
          ),
        )
      ],
    );
  }

  CachedNetworkImage _postImage() {
    return CachedNetworkImage(
        imageUrl: 'https://picsum.photos/id/$index/1000/1000',
        placeholder: (BuildContext context, String url) {
          return MyProgressIndicator(
            containerSize: MediaQuery.of(context).size.width, // Provide required parameter
          );
        },
        imageBuilder: (BuildContext context, ImageProvider imageProvider) {
          return AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          );
        },
      );
  }
}

