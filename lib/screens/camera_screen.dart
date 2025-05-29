import 'package:flutter/material.dart';
// import 'package:insta_clone/screens/profile_screen.dart'; // 필요 없는 import일 수 있음

import '../widgets/take_photo.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      // body를 Stack에서 PageView로 변경하거나,
      // Stack을 유지하되 버튼 부분만 제거합니다.
      // 여기서는 PageView만 남깁니다.
      body: PageView( // <--- PageView만 사용
        controller: _pageController,
        children: <Widget>[
          Container(
            color: Colors.grey[900],
            child: Center(child: Text('Gallery Placeholder', style: TextStyle(color: Colors.white))),
          ),
          TakePhoto(currentIndex: _currentIndex), // <--- _currentIndex 전달
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