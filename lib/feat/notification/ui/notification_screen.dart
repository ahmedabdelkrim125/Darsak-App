import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_palette.dart';
import '../data/models/notification_filter.dart';
import '../data/models/notification_model.dart';
import '../data/notification_format.dart';
import '../data/notification_store.dart';
import 'widgets/notification_empty_state.dart';
import 'widgets/notification_filter_bar.dart';
import 'widgets/notification_header.dart';
import 'widgets/notification_section_header.dart';
import 'widgets/notification_tile.dart';
import '../../../core/helper/responsive_extension.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationStore _store = NotificationStore.instance;
  NotificationFilter _filter = NotificationFilter.all;

  List<Widget> _entries(List<NotificationModel> items) {
    final now = DateTime.now();
    final entries = <Widget>[];
    DateTime? lastDay;

    for (final item in items) {
      final isNewDay =
          lastDay == null || !NotificationFormat.sameDay(lastDay, item.time);
      if (isNewDay) {
        if (lastDay != null) entries.add(SizedBox(height: 8.h));
        entries.add(
          NotificationSectionHeader(
            heading: NotificationFormat.heading(item.time, now),
            date: NotificationFormat.date(item.time),
          ),
        );
        entries.add(SizedBox(height: 10.h));
        lastDay = item.time;
      }
      entries.add(
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: NotificationTile(
            key: ValueKey(item.id),
            item: item,
            onTap: () => _store.setRead(item.id, true),
            onToggleRead: () => _store.setRead(item.id, !item.read),
            onDelete: () => _store.remove(item.id),
          ),
        ),
      );
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = palette.background.computeLuminance() < 0.5;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
          .copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: palette.background,
        body: SafeArea(
          bottom: false,
          child: ListenableBuilder(
            listenable: _store,
            builder: (context, _) {
              final items = _store.filtered(_filter);

              return Column(
                children: [
                  NotificationHeader(
                    unreadCount: _store.unreadCount,
                    onBack: () => Navigator.of(context).maybePop(),
                    onMarkAllRead: _store.markAllRead,
                  ),
                  NotificationFilterBar(
                    selected: _filter,
                    onChanged: (value) => setState(() => _filter = value),
                  ),
                  SizedBox(height: 14.h),
                  Expanded(
                    child: items.isEmpty
                        ? const NotificationEmptyState()
                        : ListView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.fromLTRB(
                              20.w,
                              0,
                              20.w,
                              bottom + 24.h,
                            ),
                            children: _entries(items),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
