// ../screens/share_post_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart'; // transparent_image 패키지 추가 필요

class SharePostScreen extends StatelessWidget {
  final File imageFile;

  const SharePostScreen(this.imageFile, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Share Post"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: FadeInImage(
          // placeholder: AssetImage('assets/your_placeholder_image.png'), // 로컬 에셋 플레이스홀더
          placeholder: MemoryImage(kTransparentImage), // 투명 플레이스홀더 (transparent_image 패키지)
          image: FileImage(imageFile), // Image.file 대신 FileImage 사용
          fit: BoxFit.contain, // 또는 원하는 fit 설정
          fadeInDuration: const Duration(milliseconds: 200), // 페이드인 지속 시간
          // 이미지 로딩 중 에러 발생 시 표시할 위젯 (선택 사항)
          // imageErrorBuilder: (context, error, stackTrace) {
          //   return Center(child: Icon(Icons.error));
          // },
        ),
      ),
    );
  }
}