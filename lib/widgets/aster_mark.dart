import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AsterMark extends StatelessWidget {
  const AsterMark({
    super.key,
    this.size = 42,
    this.backgroundColor = AppColors.primary,
    this.foregroundColor = AppColors.accent,
  });

  final double size;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(size * 0.34),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.auto_awesome_rounded,
        color: foregroundColor,
        size: size * 0.53,
      ),
    );
  }
}
