import 'dart:ui';
import 'package:flutter/material.dart';

class PrivacyBlur extends StatelessWidget {
  final Widget child;
  final bool isBlurred;

  const PrivacyBlur({
    super.key,
    required this.child,
    this.isBlurred = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isBlurred) return child;

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
