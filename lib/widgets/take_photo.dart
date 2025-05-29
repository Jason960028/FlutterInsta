import 'package:flutter/material.dart';

// screen_size.dart import는 현재 코드에서는 사용되지 않습니다.
// import '../constants/screen_size.dart';

class TakePhoto extends StatelessWidget {
  final int currentIndex; // <--- CameraScreen으로부터 받을 현재 인덱스

  const TakePhoto({
    super.key,
    required this.currentIndex, // <--- 필수 인자로 변경
  });

  @override
  Widget build(BuildContext context) {
    return Stack( // <--- Stack을 사용하여 위젯을 겹침
      children: <Widget>[
        // 1. 카메라 미리보기 영역 (배경)
        Container(
          color: Colors.black,
          // 여기에 실제 카메라 프리뷰 위젯이 들어가야 합니다 (예: camera 패키지 사용)
        ),

        // 2. 촬영 버튼 (상단)
        _buildTakePhotoButton(), // <--- 버튼 생성 함수 호출
      ],
    );
  }

  // 촬영 버튼을 생성하는 위젯 함수
  Widget _buildTakePhotoButton() {
    return Align(
      alignment: Alignment.bottomCenter, // 하단 중앙에 배치
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25.0), // 하단 여백 추가
        child: Visibility(
          visible: currentIndex == 1, // <--- 전달받은 currentIndex 사용
          child: GestureDetector(
            onTap: () {
              print('사진 촬영 버튼 클릭! (from TakePhoto)');
            },
            child: Container(
              width: 70.0,
              height: 70.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white,
                  width: 5.0,
                ),
              ),
              child: Center(
                child: Container(
                  width: 58.0,
                  height: 58.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}