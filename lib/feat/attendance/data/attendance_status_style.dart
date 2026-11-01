import 'package:flutter/material.dart';
import '../../../core/theme/app_palette.dart';
import 'models/attendance_status.dart';

extension AttendanceStatusStyle on AttendanceStatus {
  Color color(AppPalette palette) {
    return switch (this) {
      AttendanceStatus.present => palette.success,
      AttendanceStatus.absent => palette.error,
    };
  }

  IconData get icon {
    return switch (this) {
      AttendanceStatus.present => Icons.check_circle_rounded,
      AttendanceStatus.absent => Icons.cancel_rounded,
    };
  }
}
