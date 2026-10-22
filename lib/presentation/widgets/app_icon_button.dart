import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size,
    this.tooltip,
    this.padding,
    this.splashRadius,
    this.constraints,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;
  final String? tooltip;
  final EdgeInsetsGeometry? padding;
  final double? splashRadius;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color, size: size),
      onPressed: onPressed,
      tooltip: tooltip,
      padding: padding,
      splashRadius: splashRadius,
      constraints: constraints,
    );
  }
}
