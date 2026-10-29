import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';

enum HomeTone {
  primary,
  accent,
  violet;

  Color resolve(AppPalette palette) {
    return switch (this) {
      HomeTone.primary => palette.primary,
      HomeTone.accent => palette.accent,
      HomeTone.violet => const Color(0xFFB83FD6),
    };
  }
}
