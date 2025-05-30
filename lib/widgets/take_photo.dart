import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/camera_state.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../constants/screen_size.dart';
import '../screens/share_post_screen.dart';
import 'my_progress_indicator.dart';

class TakePhoto extends StatefulWidget {
  @override
  State<TakePhoto> createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {

  Widget get _myProgressIndicator {
    final double progressContainerSize = size?.width ?? 100.0;
    return MyProgressIndicator(containerSize: progressContainerSize);
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<CameraState>(
      builder: (BuildContext context, CameraState cameraState, Widget? child) {
        return Column(
          children: [
            Expanded( // 카메라 프리뷰 영역을 Expanded로 감쌉니다.
              flex: 4, // 예시: 전체 수직 공간의 4/5를 차지하도록 설정 (비율은 조절 가능)
              child: Container(
                width: size?.width, // 사용 가능한 전체 너비를 사용
                // 높이는 Expanded 위젯에 의해 결정됩니다.
                color: Colors.black,
                child: (cameraState.isReadyToTakePhoto)
                // 수정: _getPreview의 첫 번째 인자를 context로 올바르게 전달
                    ? _getPreview(cameraState)
                    : _myProgressIndicator, // 카메라 준비 중일 때 프로그레스 인디케이터 표시
              ),
            ),
            Expanded( // 버튼 영역
              flex: 1, // 예시: 전체 수직 공간의 1/5를 차지하도록 설정
              child: Center( // 버튼을 할당된 공간의 중앙에 배치
                child: OutlinedButton(
                  onPressed: () {
                    if(cameraState.isReadyToTakePhoto){
                      _attemptTakePhoto(cameraState,context);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20.0), // 버튼 내부 여백 추가 (버튼 크기 및 터치 영역 확보)
                    side: const BorderSide(color: Colors.black12, width: 2.0), // 테두리 두께 조정 (기존 20은 매우 큼)
                  ),
                  child: const Icon(Icons.camera_alt, size: 30.0, color: Colors.grey),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _getPreview(CameraState cameraState) {

    return ClipRect(
        child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Container(
                  width: size?.width,
                  height: size!.width / cameraState.controller.value.aspectRatio,
                  child: CameraPreview(cameraState.controller)
              ),
            )
        )
    );
  }

  void _attemptTakePhoto(CameraState cameraState, BuildContext context) async{

    final String timeInmilli = DateTime.now().millisecondsSinceEpoch.toString();
    try{
      final XFile imageXFile = await cameraState.controller.takePicture();

      File imageFile = File(imageXFile.path);

      if (!mounted) return; // 현재 State가 위젯 트리에 아직 있는지 확인
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => SharePostScreen(imageFile, )));
      // final path = join((await getTemporaryDirectory()).path, '$timeInmilli.png');
      // await cameraState.controller.takePicture(path);
      //
      // File imageFile = File(path);
      // Navigator.of(context).push(MaterialPageRoute(builder: (_) => SharePostScreen(imageFile, key: key)));
    }catch(e){
      print("사진 촬영 중 오류 발생: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("사진 촬영에 실패했습니다: $e")),
      );
    }


  }
}
