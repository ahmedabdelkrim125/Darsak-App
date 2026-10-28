import 'dart:async';
import 'package:flutter/material.dart';
import 'package:darsak_app/core/theme/app_fonts.dart';
import 'package:darsak_app/core/theme/app_palette.dart';
import 'package:darsak_app/core/widgets/app_text_button.dart';
import '../../../../../core/helper/responsive_extension.dart';

class ForgotResendRow extends StatefulWidget {
  const ForgotResendRow({super.key, required this.onResend, this.seconds = 45});

  final VoidCallback onResend;
  final int seconds;

  @override
  State<ForgotResendRow> createState() => _ForgotResendRowState();
}

class _ForgotResendRowState extends State<ForgotResendRow> {
  Timer? _timer;
  late int _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining <= 1) {
        timer.cancel();
        setState(() => _remaining = 0);
        return;
      }
      setState(() => _remaining--);
    });
  }

  void _resend() {
    widget.onResend();
    setState(() => _remaining = widget.seconds);
    _start();
  }

  String get _time {
    final minutes = (_remaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remaining % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final padding = EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'لم يصلك الرمز؟',
          style: AppFonts.bodySmall.copyWith(color: palette.textSecondary),
        ),
        if (_remaining > 0)
          Padding(
            padding: padding,
            child: Text(
              'أعد الإرسال بعد $_time',
              style: AppFonts.labelMedium.copyWith(
                color: palette.textSecondary,
              ),
            ),
          )
        else
          AppTextButton(
            label: 'إعادة الإرسال',
            onPressed: _resend,
            color: palette.primary,
            style: AppFonts.labelMedium,
            padding: padding,
          ),
      ],
    );
  }
}
