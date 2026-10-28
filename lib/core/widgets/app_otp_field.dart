import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:darsak_app/core/theme/app_fonts.dart';
import 'package:darsak_app/core/theme/app_palette.dart';
import '../helper/responsive_extension.dart';

class AppOtpField extends StatefulWidget {
  const AppOtpField({
    super.key,
    this.length = 6,
    this.controller,
    this.onChanged,
    this.onCompleted,
    this.validator,
    this.autofocus = false,
    this.enabled = true,
    this.reserveErrorSpace = false,
    this.height,
    this.radius,
    this.spacing,
    this.activeColor,
    this.fillColor,
    this.borderColor,
    this.textStyle,
  });

  final int length;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final FormFieldValidator<String>? validator;
  final bool autofocus;
  final bool enabled;
  final bool reserveErrorSpace;
  final double? height;
  final double? radius;
  final double? spacing;
  final Color? activeColor;
  final Color? fillColor;
  final Color? borderColor;
  final TextStyle? textStyle;

  @override
  State<AppOtpField> createState() => _AppOtpFieldState();
}

class _AppOtpFieldState extends State<AppOtpField>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final bool _ownsController;
  late final AnimationController _blink;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _blink = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    _focus.dispose();
    _blink.dispose();
    super.dispose();
  }

  Widget _buildBox({
    required int index,
    required String text,
    required bool focused,
    required int cursor,
    required bool hasError,
    required double height,
    required BorderRadius radius,
    required Color active,
    required Color idleFill,
    required Color idleBorder,
    required Color errorColor,
    required TextStyle style,
  }) {
    final filled = index < text.length;
    final isActive = focused && index == cursor;
    final digit = filled ? text[index] : '';

    final Color border;
    final Color fill;
    if (hasError) {
      border = errorColor;
      fill = errorColor.withValues(alpha: 0.06);
    } else if (isActive) {
      border = active;
      fill = active.withValues(alpha: 0.1);
    } else if (filled) {
      border = active.withValues(alpha: 0.5);
      fill = active.withValues(alpha: 0.08);
    } else {
      border = idleBorder;
      fill = idleFill;
    }

    return AnimatedScale(
      scale: isActive ? 1.05 : 1,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: radius,
          border: Border.all(color: border, width: isActive ? 2 : 1.5),
        ),
        child: filled
            ? AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.easeOutBack,
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Text(digit, key: ValueKey('$index$digit'), style: style),
              )
            : isActive
            ? Opacity(
                opacity: _blink.value,
                child: Container(width: 2, height: height * 0.4, color: active),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final boxHeight = widget.height ?? 54.h;
    final radius = BorderRadius.circular(widget.radius ?? 14.r);
    final gap = widget.spacing ?? 8.w;
    final active = widget.activeColor ?? palette.primary;
    final idleFill = widget.fillColor ?? palette.track.withValues(alpha: 0.45);
    final idleBorder =
        widget.borderColor ?? palette.primary.withValues(alpha: 0.15);
    final style =
        widget.textStyle ??
        AppFonts.headlineMedium.copyWith(color: palette.textPrimary);

    return FormField<String>(
      initialValue: _controller.text,
      validator: widget.validator,
      enabled: widget.enabled,
      builder: (state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.enabled ? _focus.requestFocus : null,
              child: Stack(
                children: [
                  ListenableBuilder(
                    listenable: Listenable.merge([_controller, _focus, _blink]),
                    builder: (context, _) {
                      final text = _controller.text;
                      final cursor = text.length.clamp(0, widget.length - 1);

                      return Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          children: [
                            for (var i = 0; i < widget.length; i++) ...[
                              if (i > 0) SizedBox(width: gap),
                              Expanded(
                                child: _buildBox(
                                  index: i,
                                  text: text,
                                  focused: _focus.hasFocus,
                                  cursor: cursor,
                                  hasError: state.hasError,
                                  height: boxHeight,
                                  radius: radius,
                                  active: active,
                                  idleFill: idleFill,
                                  idleBorder: idleBorder,
                                  errorColor: palette.error,
                                  style: style,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0,
                      child: TextField(
                        controller: _controller,
                        focusNode: _focus,
                        autofocus: widget.autofocus,
                        enabled: widget.enabled,
                        showCursor: false,
                        enableInteractiveSelection: false,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(widget.length),
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        onChanged: (value) {
                          state.didChange(value);
                          widget.onChanged?.call(value);
                          if (value.length == widget.length) {
                            widget.onCompleted?.call(value);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (state.hasError)
              Padding(
                padding: EdgeInsetsDirectional.only(top: 4.h, start: 12.w),
                child: Text(
                  state.errorText!,
                  style: AppFonts.bodySmall.copyWith(color: palette.error),
                ),
              )
            else if (widget.reserveErrorSpace)
              SizedBox(height: 22.h),
          ],
        );
      },
    );
  }
}
