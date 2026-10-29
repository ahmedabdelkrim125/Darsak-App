import '../../../core/const/student_grade.dart';
import '../../classroom/data/classroom_store.dart';
import '../../classroom/data/models/classroom_group.dart';
import '../../classroom/data/subject_icons.dart';
import '../../home/data/models/home_tone.dart';
import 'models/group_card_model.dart';

class GroupsMapper {
  GroupsMapper._();

  static List<GroupCardModel> cards(
    ClassroomStore store, {
    String query = '',
    StudentGrade? stage,
  }) {
    final text = query.trim().toLowerCase();
    final groups = store.groups;
    final result = <GroupCardModel>[];
    for (var i = 0; i < groups.length; i++) {
      final group = groups[i];
      if (stage != null && group.year.stage != stage) continue;
      if (text.isNotEmpty && !_matches(group, text)) continue;
      result.add(
        GroupCardModel(
          id: group.id,
          title: '${group.subject} - ${group.name}',
          yearLabel: group.year.label,
          studentsCount: group.students.length,
          lessonsCount: store.weeklyLessonsOf(group.id),
          icon: SubjectIcons.of(group.subject),
          tone: HomeTone.values[i % HomeTone.values.length],
        ),
      );
    }
    return result;
  }

  static bool _matches(ClassroomGroup group, String text) {
    if (group.name.toLowerCase().contains(text)) return true;
    if (group.subject.toLowerCase().contains(text)) return true;
    if (group.year.label.contains(text)) return true;
    return group.students.any(
      (student) =>
          student.name.toLowerCase().contains(text) ||
          (student.username?.contains(text) ?? false),
    );
  }
}
