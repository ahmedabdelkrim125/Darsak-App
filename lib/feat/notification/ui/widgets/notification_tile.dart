import 'package:flutter/material.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_palette.dart';
import '../../data/models/notification_model.dart';
import '../../data/notification_format.dart';
import '../../data/notification_icons.dart';
import 'notification_tone_style.dart';
import '../../../../core/helper/responsive_extension.dart';

enum _TileAction { toggleRead, delete }

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.onToggleRead,
    required this.onDelete,
  });

  final NotificationModel item;
  final VoidCallback onTap;
  final VoidCallback onToggleRead;
  final VoidCallback onDelete;

  void _onSelected(_TileAction action) {
    switch (action) {
      case _TileAction.toggleRead:
        onToggleRead();
      case _TileAction.delete:
        onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tone = NotificationToneStyle.of(context, item.type.tone);
    final highlighted = item.pinned && !item.read;
    final dotColor = item.read
        ? palette.primary.withValues(alpha: 0.45)
        : palette.accent;

    return Material(
      color: highlighted
          ? palette.accent.withValues(alpha: 0.1)
          : palette.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.r),
        side: BorderSide(
          color: highlighted
              ? palette.accent.withValues(alpha: 0.3)
              : palette.track.withValues(alpha: 0.7),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(14.w, 12.h, 4.w, 12.h),
          child: Row(
            children: [
              Container(
                width: 46.r,
                height: 46.r,
                decoration: BoxDecoration(
                  color: tone.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  NotificationIcons.ofType(item.type),
                  size: 24.r,
                  color: tone,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.titleMedium.copyWith(
                        fontSize: 15.sp,
                        height: 1.3,
                        color: palette.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      item.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.bodySmall.copyWith(
                        fontSize: 11.5.sp,
                        color: palette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 7.r,
                height: 7.r,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 5.w),
              Text(
                NotificationFormat.time(item.time),
                style: AppFonts.bodySmall.copyWith(
                  fontSize: 11.sp,
                  height: 1.2,
                  color: palette.textSecondary,
                ),
              ),
              SizedBox(
                width: 34.r,
                height: 34.r,
                child: PopupMenuButton<_TileAction>(
                  padding: EdgeInsets.zero,
                  color: palette.surface,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  icon: Icon(
                    Icons.more_vert_rounded,
                    size: 20.r,
                    color: palette.textSecondary,
                  ),
                  onSelected: _onSelected,
                  itemBuilder: (context) => [
                    PopupMenuItem<_TileAction>(
                      value: _TileAction.toggleRead,
                      child: _MenuRow(
                        icon: item.read
                            ? Icons.mark_email_unread_outlined
                            : Icons.done_all_rounded,
                        label: item.read ? 'تحديد كغير مقروء' : 'تحديد كمقروء',
                        color: palette.textPrimary,
                      ),
                    ),
                    PopupMenuItem<_TileAction>(
                      value: _TileAction.delete,
                      child: _MenuRow(
                        icon: Icons.delete_outline_rounded,
                        label: 'حذف',
                        color: palette.error,
                      ),
                    ),
                  ],
                ),
              ),
              if (highlighted)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20.r,
                  color: palette.accent,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20.r, color: color),
        SizedBox(width: 10.w),
        Text(label, style: AppFonts.bodyMedium.copyWith(color: color)),
      ],
    );
  }
}
