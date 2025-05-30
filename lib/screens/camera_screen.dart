import 'package:flutter/material.dart';
import 'package:insta_clone/widgets/my_gallery.dart';
import 'package:provider/provider.dart';
// import 'package:insta_clone/screens/profile_screen.dart'; // 필요 없는 import일 수 있음

import '../models/camera_state.dart';
import '../widgets/take_photo.dart';

class CameraScreen extends StatefulWidget {

  CameraState _cameraState = CameraState();

  @override
  State<CameraScreen> createState(){
    _cameraState.getReadyToTakePhoto();
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> {
  int _currentIndex = 1;
  late PageController _pageController;
  String _title = 'Photo';
  final Duration _animationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    widget._cameraState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CameraState>.value(value: widget._cameraState),
        //겹치지 않는 <type>의 provider을 제공 가능
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(_title),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: PageView( // <--- PageView만 사용
          controller: _pageController,
          children: <Widget>[
            MyGallery(),
            TakePhoto(), // <--- _currentIndex 전달
            Container(
              color: Colors.grey[900],
              child: Center(child: Text('Video Placeholder', style: TextStyle(color: Colors.white))),
            )
          ],
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
              switch (_currentIndex) {
                case 0:
                  _title = 'Gallery';
                  break;
                case 1:
                  _title = 'Photo';
                  break;
                case 2:
                  _title = 'Video';
                  break;
              }
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          iconSize: 0,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.radio_button_checked),
              label: 'GALLERY',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radio_button_checked),
              label: 'PHOTO',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radio_button_checked),
              label: 'VIDEO',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: _onItemTabbed,
        ),
      ),
    );
  }

  void _onItemTabbed(index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        _currentIndex,
        duration: _animationDuration,
        curve: Curves.fastOutSlowIn,
      );
    });
  }
}