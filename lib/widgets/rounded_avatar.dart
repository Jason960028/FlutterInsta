import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/common_size.dart';

class RoundedAvatar extends StatelessWidget {
  final double size;

  const RoundedAvatar({
    super.key, this.size = avatar_size,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl:'https://picsum.photos/500',
        width: size,
        height: size,
      ),
    );
  }
}