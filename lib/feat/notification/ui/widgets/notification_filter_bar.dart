import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../data/models/notification_filter.dart';
import '../../data/notification_icons.dart';
import '../../../../core/helper/responsive_extension.dart';

class NotificationFilterBar extends StatelessWidget {
  const NotificationFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final NotificationFilter selected;
  final ValueChanged<NotificationFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    const filters = NotificationFilter.values;

    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: filters.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          return _FilterChip(
            filter: filter,
            selected: filter == selected,
            onTap: () {
              if (filter == selected) return;
              HapticFeedback.selectionClick();
              onChanged(filter);
            },
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final NotificationFilter filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final foreground = selected ? palette.onPrimary : palette.textPrimary;

    return Material(
      color: selected ? palette.primary : palette.surface,
      shape: StadiumBorder(
        side: BorderSide(color: selected ? palette.primary : palette.track),
      ),
      clipBehavior: Clip.antiAlias,
      animationDuration: const Duration(milliseconds: 220),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                NotificationIcons.ofFilter(filter),
                size: 18.r,
                color: foreground,
              ),
              SizedBox(width: 6.w),
              Text(
                filter.label,
                style: AppFonts.bodyMedium.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  color: foreground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
