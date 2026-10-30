import 'package:flutter/material.dart';
import '../theme/app_palette.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Switch(
      value: value,
      onChanged: onChanged,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      thumbColor: WidgetStateProperty.resolveWith<Color?>((states) => Colors.white),
      trackColor: WidgetStateProperty.resolveWith<Color?>(
        (states) =>
            states.contains(WidgetState.selected) ? palette.primary : palette.track,
      ),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
        (states) => Colors.transparent,
      ),
    );
  }
}