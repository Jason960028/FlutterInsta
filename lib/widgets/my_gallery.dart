// ../widgets/my_gallery.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/gallery_state.dart';
import '../screens/share_post_screen.dart';

class MyGallery extends StatefulWidget {
  const MyGallery({super.key});

  @override
  State<MyGallery> createState() => _MyGalleryState();
}

class _MyGalleryState extends State<MyGallery> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final galleryState = Provider.of<GalleryState>(context, listen: false);
      // loadImages가 GalleryState 생성자에서 호출되지 않도록 했다면 여기서 호출
      if (galleryState.images.isEmpty && !galleryState.isLoading) { // 이미 로드된 이미지가 없고, 로딩 중도 아닐 때만 호출
        galleryState.loadImages().then((hasPermission) {
          if (!hasPermission && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('갤러리 접근 권한이 필요합니다.')),
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GalleryState>(
      builder: (BuildContext context, GalleryState galleryState, Widget? child) {
        if (galleryState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!galleryState.hasPermission && galleryState.images.isEmpty) {
          // 권한이 없고, 이미지도 없을 때 (로딩 후 상태)
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("갤러리 접근 권한이 필요합니다."),
                ElevatedButton(
                  onPressed: () {
                    // 다시 권한 요청 및 이미지 로드 시도
                    galleryState.loadImages();
                  },
                  child: const Text("권한 요청 및 새로고침"),
                )
              ],
            ),
          );
        }

        if (galleryState.images.isEmpty) {
          return const Center(child: Text("표시할 이미지가 없습니다."));
        }

        return GridView.builder( // GridView.count 대신 builder 사용 (성능에 더 좋을 수 있음)
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 한 줄에 3개
            crossAxisSpacing: 2, // 아이템 간 가로 간격
            mainAxisSpacing: 2, // 아이템 간 세로 간격
          ),
          itemCount: galleryState.images.length,
          itemBuilder: (context, index) {
            final imageFile = galleryState.images[index];
            return GestureDetector(
              onTap: () {
                // 이미지를 탭 시 SharePostScreen으로 이동하고 선택된 imageFile 전달
                final imageProvider = FileImage(imageFile); // FileImage 생성

                // precacheImage를 사용하여 이미지를 미리 로드
                precacheImage(imageProvider, context).then((_) {
                  // 미리 로드가 (시작 또는 완료)된 후 화면 이동
                  if (mounted) { // 위젯이 여전히 트리에 있는지 확인
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        // SharePostScreen에는 imageFile을 그대로 전달하거나,
                        // 이미 FileImage를 만들었으니 그것을 활용할 수도 있습니다.
                        // 여기서는 imageFile을 그대로 전달하겠습니다.
                        builder: (context) => SharePostScreen(imageFile),
                      ),
                    );
                  }
                }).catchError((e) {
                  // 오류 발생 시에도 일단 화면 이동 (선택적이지만 사용자 경험상 네비게이션은 해주는 것이 좋을 수 있음)
                  print("이미지 미리 로드 중 오류: $e");
                  if (mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SharePostScreen(imageFile),
                      ),
                    );
                  }
                });
              },
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}