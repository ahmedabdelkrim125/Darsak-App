import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:darsak_app/core/theme/app_fonts.dart';
import 'package:darsak_app/core/theme/app_palette.dart';
import 'package:darsak_app/core/widgets/app_pressable.dart';

import '../helper/responsive_extension.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.reserveErrorSpace = false,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffix,
    this.obscureText = false,
    this.showPasswordToggle,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    this.autofillHints,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.autovalidateMode,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.radius,
    this.contentPadding,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.borderWidth,
    this.iconColor,
    this.iconSize,
    this.textStyle,
    this.hintStyle,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final bool reserveErrorSpace;
  final IconData? prefixIcon;
  final Widget? prefix;
  final IconData? suffixIcon;
  final Widget? suffix;
  final bool obscureText;
  final bool? showPasswordToggle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final AutovalidateMode? autovalidateMode;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final double? radius;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final double? borderWidth;
  final Color? iconColor;
  final double? iconSize;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      _obscure = widget.obscureText;
    }
  }

  OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radius ?? 16.r),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget? _buildPrefix() {
    if (widget.prefix != null) return widget.prefix;
    final icon = widget.prefixIcon;
    if (icon == null) return null;
    return Icon(icon, size: widget.iconSize ?? 22.r);
  }

  Widget? _buildSuffix() {
    if (widget.suffix != null) return widget.suffix;
    if (widget.obscureText && (widget.showPasswordToggle ?? true)) {
      return AppPressable(
        onTap: () => setState(() => _obscure = !_obscure),
        pressedScale: 0.85,
        haptic: false,
        child: SizedBox(
          width: 48.w,
          height: 44.h,
          child: Icon(
            _obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: widget.iconSize ?? 22.r,
          ),
        ),
      );
    }
    final icon = widget.suffixIcon;
    if (icon == null) return null;
    return Icon(icon, size: widget.iconSize ?? 22.r);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final errorColor = widget.errorBorderColor ?? palette.error;
    final borderWidth = widget.borderWidth ?? 1.5;
    final idleColor =
        widget.borderColor ?? palette.primary.withValues(alpha: 0.15);
    final focusedColor = widget.focusedBorderColor ?? palette.primary;
    final iconColor = WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.error)) return errorColor;
      if (states.contains(WidgetState.focused)) return focusedColor;
      return widget.iconColor ?? palette.textSecondary;
    });
    final iconConstraints = BoxConstraints(minWidth: 48.w, minHeight: 44.h);

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      initialValue: widget.initialValue,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      textDirection: widget.textDirection,
      textAlign: widget.textAlign,
      inputFormatters: widget.inputFormatters,
      autofillHints: widget.autofillHints,
      obscureText: _obscure,
      maxLines: _obscure ? 1 : widget.maxLines,
      minLines: _obscure ? null : widget.minLines,
      maxLength: widget.maxLength,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      cursorColor: focusedColor,
      style:
          widget.textStyle ??
          AppFonts.bodyLarge.copyWith(color: palette.textPrimary, height: 1.3),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: widget.fillColor ?? palette.track.withValues(alpha: 0.45),
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText:
            widget.helperText ?? (widget.reserveErrorSpace ? ' ' : null),
        errorText: widget.errorText,
        errorMaxLines: 1,
        helperMaxLines: 1,
        hintStyle:
            widget.hintStyle ??
            AppFonts.bodyLarge.copyWith(
              color: palette.textSecondary.withValues(alpha: 0.75),
              height: 1.3,
            ),
        labelStyle: AppFonts.bodyMedium.copyWith(color: palette.textSecondary),
        helperStyle: AppFonts.bodySmall.copyWith(color: palette.textSecondary),
        errorStyle: AppFonts.bodySmall.copyWith(color: errorColor),
        contentPadding:
            widget.contentPadding ??
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        prefixIcon: _buildPrefix(),
        suffixIcon: _buildSuffix(),
        prefixIconConstraints: iconConstraints,
        suffixIconConstraints: iconConstraints,
        prefixIconColor: iconColor,
        suffixIconColor: iconColor,
        border: _border(idleColor, borderWidth),
        enabledBorder: _border(idleColor, borderWidth),
        disabledBorder: _border(idleColor.withValues(alpha: 0.08), borderWidth),
        focusedBorder: _border(focusedColor, borderWidth),
        errorBorder: _border(errorColor, borderWidth),
        focusedErrorBorder: _border(errorColor, borderWidth),
      ),
    );
  }
}
