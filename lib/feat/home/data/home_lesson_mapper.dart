import '../../../core/helper/time_formatter.dart';
import '../../classroom/data/classroom_store.dart';
import 'models/home_lesson_model.dart';
import 'models/home_tone.dart';

class HomeLessonMapper {
  HomeLessonMapper._();

  static List<HomeLessonModel> today(ClassroomStore store, DateTime now) {
    final lessons = store.lessonsOn(now.weekday);
    final result = <HomeLessonModel>[];
    for (var i = 0; i < lessons.length; i++) {
      final lesson = lessons[i];
      final group = store.groupById(lesson.groupId);
      if (group == null) continue;
      result.add(
        HomeLessonModel(
          id: lesson.id,
          title: '${lesson.subject} - ${group.name}',
          grade: group.year.label,
          studentsCount: group.students.length,
          time: formatTime(lesson.time),
          tone: HomeTone.values[i % HomeTone.values.length],
        ),
      );
    }
    return result;
  }
}
