import 'package:flutter/material.dart';
import '../../../core/const/student_grade.dart';
import '../../../core/helper/responsive_extension.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/session/app_session.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_palette.dart';
import '../../classroom/data/classroom_store.dart';
import '../../classroom/ui/add_group_sheet.dart';
import '../../classroom/ui/group_details_sheet.dart';
import '../../classroom/ui/widgets/group_actions_sheet.dart';
import '../../home/data/home_content.dart';
import '../../home/ui/home_actions.dart';
import '../../home/ui/widgets/home_header.dart';
import '../../schedule/ui/widgets/schedule_add_button.dart';
import '../data/groups_content.dart';
import '../data/groups_mapper.dart';
import 'widgets/group_card.dart';
import 'widgets/groups_empty.dart';
import 'widgets/groups_search_field.dart';
import 'widgets/groups_stage_filter.dart';
import 'widgets/groups_summary.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  String _query = '';
  StudentGrade? _stage;

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
            final hasGroups = store.groups.isNotEmpty;
            final cards = GroupsMapper.cards(
              store,
              query: _query,
              stage: _stage,
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
                  Row(
                    children: [
                      Text(
                        GroupsContent.title,
                        style: AppFonts.headlineMedium.copyWith(
                          color: palette.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      ScheduleAddButton(
                        label: GroupsContent.addGroup,
                        onTap: () => AddGroupSheet.show(context),
                      ),
                    ],
                  ),
                  verticalSpace(height: 14),
                  GroupsSummary(
                    groups: store.groups.length,
                    students: store.studentsTotal,
                    lessons: store.weeklyLessonsCount,
                  ),
                  verticalSpace(height: 16),
                  if (hasGroups) ...[
                    GroupsSearchField(
                      onChanged: (value) => setState(() => _query = value),
                    ),
                    verticalSpace(height: 12),
                    GroupsStageFilter(
                      selected: _stage,
                      onChanged: (stage) => setState(() => _stage = stage),
                    ),
                    verticalSpace(height: 14),
                  ],
                  if (cards.isEmpty)
                    GroupsEmpty(
                      searching: hasGroups,
                      onAdd: () => AddGroupSheet.show(context),
                    )
                  else
                    for (final card in cards) ...[
                      GroupCard(
                        group: card,
                        onTap: () => GroupDetailsSheet.show(context, card.id),
                        onMenu: () => GroupActionsSheet.show(context, card.id),
                      ),
                      verticalSpace(height: 10),
                    ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
