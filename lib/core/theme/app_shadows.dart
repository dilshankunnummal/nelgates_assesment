import 'package:flutter/material.dart';

class AppShadows {
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x24000000),
      blurRadius: 24,
      offset: Offset(0, 10),
    ),
  ];

  static const List<BoxShadow> glow = [
    BoxShadow(
      color: Color(0x330F766E),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];
}
