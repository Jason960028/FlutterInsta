import 'package:flutter/material.dart';

class MyProgressIndicator extends StatelessWidget {
  final double containerSize;
  final double progressSize;

  const MyProgressIndicator({
    Key? key,
    required this.containerSize, // Make it explicit
    this.progressSize = 60
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: containerSize,
      height: containerSize,
      child: Center(
          child: SizedBox(
            height: progressSize,
            width: progressSize,
            child: CircularProgressIndicator(),
          )
      ),
    );
  }
}


