import 'package:flutter/material.dart';
import 'package:insta_clone/screens/camera_screen.dart';
import 'package:insta_clone/screens/feed_screen.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as AppSettings;
import 'constants/screen_size.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    super.key,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: ''
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: ''
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.add),
        label: ''
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.video_call),
        label: ''
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: ''
    ),
  ];

  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    FeedScreen(),
    Container(
      color : Colors.black,
    ),
    Container(
      color : Colors.red,
    ),
    Container(
      color : Colors.green,
    ),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    size ??= MediaQuery.of(context).size;
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: btmNavItems,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black87,
        currentIndex: _selectedIndex,
        onTap: _onBtmItemClick,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white, // 배경색을 흰색으로 명시
        elevation: 0,                // 그림자(선) 제거

      ),
    );
  }

  void _onBtmItemClick(int index){
    switch(index){
      case 2:
        _openCamera();
        break;
      default:
        setState(() {
          _selectedIndex = index;
        });
    }

  }

  void _openCamera() async{
    // if(await _checkIfPermissionGranted(context)) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CameraScreen()));
    // }
    // else {
      // SnackBar snackBar = SnackBar(
      //   content: Text('Photo, File, Microphone 권한이 필요합니다'),
      //   action: SnackBarAction(
      //       label: 'Ok',
      //       onPressed: (){
      //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //         AppSettings.openAppSettings();
      //       }
      //   ),
      // );
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // }
  }

  Future<bool> _checkIfPermissionGranted(BuildContext context) async {
    print("권한 확인 시작..."); // <--- 로그 추가
    // 요청 전 상태 확인
    PermissionStatus cameraStatusBefore = await Permission.camera.status;
    PermissionStatus micStatusBefore = await Permission.microphone.status;
    print("요청 전 카메라 상태: $cameraStatusBefore"); // <--- 로그 추가
    print("요청 전 마이크 상태: $micStatusBefore"); // <--- 로그 추가

    // 이미 허용된 경우
    if (cameraStatusBefore.isGranted && micStatusBefore.isGranted) {
      print("이미 모든 권한이 허용되어 있습니다.");
      return true;
    }

    // 영구적으로 거부된 경우 (팝업 안 뜸)
    if (cameraStatusBefore.isPermanentlyDenied || micStatusBefore.isPermanentlyDenied) {
      print("권한이 영구적으로 거부되었습니다. 설정으로 이동해야 합니다.");
      // 여기에 openAppSettings()를 호출하여 설정으로 유도하는 로직을 추가할 수 있습니다.
      // 예: openAppSettings();
      return false;
    }

    print("권한 요청 시도..."); // <--- 로그 추가
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    print("권한 요청 결과: $statuses"); // <--- 로그 추가

    bool permitted = true;
    statuses.forEach((permission, permissionStatus) {
      print("${permission.toString()} 상태: $permissionStatus"); // <--- 로그 추가
      if (!permissionStatus.isGranted) {
        permitted = false;
      }
    });

    print("최종 권한 허용 여부: $permitted"); // <--- 로그 추가
    return permitted;
  }
}