import 'package:flutter/material.dart';
import '../theme/app_fonts.dart';
import '../theme/app_palette.dart';
import 'app_pressable.dart';
import '../helper/responsive_extension.dart';

class AppChoiceItem<T> {
  const AppChoiceItem({required this.value, required this.label});

  final T value;
  final String label;
}

class AppChoiceChips<T> extends FormField<T> {
  AppChoiceChips({
    super.key,
    required List<AppChoiceItem<T>> items,
    T? value,
    ValueChanged<T>? onChanged,
    super.validator,
    super.enabled,
    bool reserveErrorSpace = false,
    double? height,
    double? radius,
    double? spacing,
    Color? selectedColor,
    Color? selectedTextColor,
    Color? backgroundColor,
    Color? borderColor,
    TextStyle? textStyle,
  }) : super(
         initialValue: value,
         builder: (state) {
           final palette = state.context.palette;
           final chipHeight = height ?? 44.h;
           final chipRadius = radius ?? 14.r;
           final gap = spacing ?? 8.w;
           final selectedBackground = selectedColor ?? palette.primary;
           final selectedForeground = selectedTextColor ?? palette.onPrimary;
           final idleBackground =
               backgroundColor ?? palette.track.withValues(alpha: 0.45);
           final idleBorder =
               borderColor ?? palette.primary.withValues(alpha: 0.15);
           final labelStyle = textStyle ?? AppFonts.bodyMedium;
           final hasError = state.hasError;

           return Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
               Row(
                 children: [
                   for (var i = 0; i < items.length; i++) ...[
                     if (i > 0) SizedBox(width: gap),
                     Expanded(
                       child: AppPressable(
                         onTap: enabled
                             ? () {
                                 state.didChange(items[i].value);
                                 onChanged?.call(items[i].value);
                               }
                             : null,
                         pressedScale: 0.95,
                         child: AnimatedContainer(
                           duration: const Duration(milliseconds: 200),
                           curve: Curves.easeOut,
                           height: chipHeight,
                           alignment: Alignment.center,
                           decoration: BoxDecoration(
                             color: state.value == items[i].value
                                 ? selectedBackground
                                 : idleBackground,
                             borderRadius: BorderRadius.circular(chipRadius),
                             border: Border.all(
                               color: state.value == items[i].value
                                   ? selectedBackground
                                   : (hasError ? palette.error : idleBorder),
                               width: 1.5,
                             ),
                           ),
                           child: Text(
                             items[i].label,
                             style: labelStyle.copyWith(
                               color: state.value == items[i].value
                                   ? selectedForeground
                                   : palette.textPrimary,
                             ),
                           ),
                         ),
                       ),
                     ),
                   ],
                 ],
               ),
               if (hasError)
                 Padding(
                   padding: EdgeInsetsDirectional.only(top: 4.h, start: 12.w),
                   child: Text(
                     state.errorText!,
                     style: AppFonts.bodySmall.copyWith(color: palette.error),
                   ),
                 )
               else if (reserveErrorSpace)
                 SizedBox(height: 22.h),
             ],
           );
         },
       );
}
