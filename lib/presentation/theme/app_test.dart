import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sitevisits/presentation/theme/app_colors.dart';

class AppText extends StatelessWidget {
  const AppText({
    super.key,
    required this.title,
    this.size = 16,
    this.weight = FontWeight.normal,
    this.color = AppColors.black,
    this.align = TextAlign.left,
    this.overflow,
    this.maxLines,
  });

  final String title;
  final TextAlign align;
  final double size;
  final FontWeight weight;
  final Color color;
  final TextOverflow? overflow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: align,
      overflow: overflow,
      maxLines: maxLines,
      style: GoogleFonts.lato(fontSize: size, fontWeight: weight, color: color),
    );
  }
}
