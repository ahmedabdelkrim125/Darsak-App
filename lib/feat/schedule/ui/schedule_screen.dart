import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/const/app_assets.dart';
import '../../../core/helper/date_formatter.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/session/app_session.dart';
import '../../../core/theme/app_palette.dart';
import '../../classroom/data/classroom_store.dart';
import '../../classroom/ui/lesson_actions_sheet.dart';
import '../../home/data/home_content.dart';
import '../../home/ui/home_actions.dart';
import '../../home/ui/widgets/home_banner.dart';
import '../../home/ui/widgets/home_header.dart';
import '../data/models/schedule_view_mode.dart';
import '../data/schedule_content.dart';
import '../data/schedule_lesson_mapper.dart';
import 'widgets/schedule_calendar_card.dart';
import 'widgets/schedule_day_card.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late DateTime _selected = DateFormatter.dateOnly(DateTime.now());
  late DateTime _visibleMonth = DateTime(_selected.year, _selected.month);
  ScheduleViewMode _mode = ScheduleViewMode.week;

  void _setMode(ScheduleViewMode mode) {
    if (mode == _mode) return;
    setState(() {
      _mode = mode;
      _visibleMonth = DateTime(_selected.year, _selected.month);
    });
  }

  void _shift(int step) {
    setState(() {
      if (_mode == ScheduleViewMode.week) {
        _selected = DateTime(
          _selected.year,
          _selected.month,
          _selected.day + 7 * step,
        );
        _visibleMonth = DateTime(_selected.year, _selected.month);
        return;
      }
      final month = DateTime(_visibleMonth.year, _visibleMonth.month + step);
      final day = min(
        _selected.day,
        DateFormatter.daysInMonth(month.year, month.month),
      );
      _visibleMonth = month;
      _selected = DateTime(month.year, month.month, day);
    });
  }

  void _select(DateTime date) {
    setState(() {
      _selected = date;
      _visibleMonth = DateTime(date.year, date.month);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selected,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    _select(DateFormatter.dateOnly(picked));
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final padding = MediaQuery.paddingOf(context);
    final store = ClassroomStore.instance;
    final session = AppSession.instance;

    return ColoredBox(
      color: palette.background,
      child: AdaptiveContentWrapper(
        child: ListenableBuilder(
          listenable: Listenable.merge([store, session]),
          builder: (context, _) {
            final name = session.firstName.isEmpty
                ? HomeContent.userName
                : session.firstName;
            final label = DateFormatter.monthYear(
              _mode == ScheduleViewMode.week ? _selected : _visibleMonth,
            );

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                16.w,
                padding.top + 12.h,
                16.w,
                padding.bottom + 110.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HomeHeader(
                    name: name,
                    onNotifications: () => HomeActions.comingSoon(context),
                  ),
                  verticalSpace(height: 18),
                  const HomeBanner(
                    title: ScheduleContent.bannerTitle,
                    description: ScheduleContent.bannerDescription,
                    image: AppAssets.schedulePlanner,
                  ),
                  verticalSpace(height: 16),
                  ScheduleCalendarCard(
                    mode: _mode,
                    label: label,
                    selected: _selected,
                    visibleMonth: _visibleMonth,
                    hasLessons: (date) =>
                        ScheduleLessonMapper.hasLessons(store, date),
                    onModeChanged: _setMode,
                    onPrevious: () => _shift(-1),
                    onNext: () => _shift(1),
                    onPickDate: _pickDate,
                    onSelect: _select,
                  ),
                  verticalSpace(height: 16),
                  ScheduleDayCard(
                    date: _selected,
                    lessons: ScheduleLessonMapper.forDay(store, _selected),
                    onAdd: () => HomeActions.addLesson(context),
                    onLessonTap: (id) => HomeActions.openLesson(context, id),
                    onLessonMenu: (id) => LessonActionsSheet.show(context, id),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
