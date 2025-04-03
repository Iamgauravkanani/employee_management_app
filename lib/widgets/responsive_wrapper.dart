import 'package:flutter/material.dart';
import '../utils/responsive_layout.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool centerContent;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.backgroundColor,
    this.centerContent = true,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = ResponsiveLayout.getMaxContentWidth(context);
    final isWide = MediaQuery.of(context).size.width > maxWidth;

    if (!isWide) return child;

    return Container(
      color: backgroundColor,
      child: Center(
        child: SizedBox(
          width: maxWidth,
          child: child,
        ),
      ),
    );
  }
} 