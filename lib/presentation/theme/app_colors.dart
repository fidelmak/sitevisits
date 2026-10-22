import 'dart:ui';

class AppColors {
  // Base
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color background = Color(0xFFFFFFFF);
  static const Color headerBackground = Color(0xFFF3F5F7);

  // Text
  static const Color textPrimary = Color(0xFF1B2430);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color searchHint = Color(0xFF4B5563);

  // Borders and dividers
  static const Color divider = Color(0xFFE5E7EB);
  static const Color searchBorder = Color(0xFFD9DEE3);
  static const Color checkboxOutline = Color(0xFF3D4756);

  // Success (selected / synced check)
  static const Color success = Color(0xFF0B7A4B);

  // Pending / unsynced (orange badge)
  static const Color pendingText = Color(0xFFC2540A);
  static const Color pendingBackground = Color(0xFFFDEBDD);

  // Error (Not saved · Retry badge)
  static const Color errorText = Color(0xFFC62828);
  static const Color errorBackground = Color(0xFFFDE4E4);
}
