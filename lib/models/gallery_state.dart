// ../models/gallery_state.dart

import 'dart:io';
import 'package:flutter/foundation.dart'; // ChangeNotifier를 위해 여전히 필요
import 'package:photo_manager/photo_manager.dart'; // photo_manager import

class GalleryState extends ChangeNotifier {
  List<File> _images = [];
  bool _hasPermission = false;
  bool _isLoading = false; // 로딩 상태를 UI에 알리기 위함

  List<File> get images => _images;
  bool get hasPermission => _hasPermission;
  bool get isLoading => _isLoading;

  // 생성자에서 바로 이미지를 로드하지 않도록 변경 (MyGallery의 initState에서 호출)
  // GalleryState() {
  //   loadImages();
  // }

  Future<bool> loadImages({int count = 50}) async { // 한 번에 불러올 이미지 수
    print("GalleryState: loadImages() 호출됨"); // <--- 추가
    if (_isLoading) return _hasPermission; // 중복 실행 방지

    _isLoading = true;
    notifyListeners(); // 로딩 시작 알림

    print("GalleryState: PhotoManager.requestPermissionExtend() 호출 직전"); // <--- 추가
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    _hasPermission = ps.hasAccess;
    print("GalleryState: 권한 상태: $_hasPermission"); // <--- 추가


    if (_hasPermission) {
      try {
        final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
          type: RequestType.image, // 이미지만 가져오기
          // 최신 항목이 위로 오도록 정렬 (선택 사항)
          filterOption: FilterOptionGroup(
            orders: [
              const OrderOption(type: OrderOptionType.createDate, asc: false),
            ],
          ),
        );

        if (albums.isNotEmpty) {
          // 보통 첫 번째 앨범이 '최근 항목' 또는 '모든 사진' 입니다.
          final List<AssetEntity> assets = await albums.first.getAssetListPaged(
            page: 0, // 첫 페이지
            size: count, // 지정된 수만큼 가져오기
          );

          List<File> tempImages = [];
          for (AssetEntity asset in assets) {
            // 썸네일 대신 원본 파일을 가져옵니다.
            // 썸네일을 원하면 asset.thumbnailData 또는 asset.thumbnailFile 등을 사용할 수 있습니다.
            File? file = await asset.file;
            if (file != null) {
              tempImages.add(file);
            }
          }
          _images = tempImages;
        } else {
          _images = [];
        }
      } catch (e) {
        print('photo_manager로 이미지 로드 중 오류: $e');
        _images = [];
      }
    } else {
      _images = [];
      print('갤러리 접근 권한이 거부되었습니다.');
    }

    _isLoading = false;
    notifyListeners(); // 로딩 완료 및 데이터 변경 알림
    return _hasPermission;
  }
}