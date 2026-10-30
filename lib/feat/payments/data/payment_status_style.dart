import 'package:flutter/widgets.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../core/theme/app_palette.dart';
import 'models/payment_status.dart';

extension PaymentStatusStyle on PaymentStatus {
  Color color(AppPalette palette) {
    return switch (this) {
      PaymentStatus.paid => palette.success,
      PaymentStatus.partial => const Color(0xFFF59E0B),
      PaymentStatus.unpaid => palette.error,
    };
  }

  IconData get icon {
    return switch (this) {
      PaymentStatus.paid => SolarIconsBold.checkCircle,
      PaymentStatus.partial => SolarIconsBold.clockCircle,
      PaymentStatus.unpaid => SolarIconsBold.dangerCircle,
    };
  }
}
