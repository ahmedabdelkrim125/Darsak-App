import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';

enum MoreTone {
  primary,
  accent,
  amber;

  Color resolve(AppPalette palette) {
    return switch (this) {
      MoreTone.primary => palette.primary,
      MoreTone.accent => palette.accent,
      MoreTone.amber => const Color(0xFFF59E0B),
    };
  }
}
