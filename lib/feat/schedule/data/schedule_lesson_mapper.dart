import '../../../core/helper/time_formatter.dart';
import '../../classroom/data/classroom_store.dart';
import '../../classroom/data/subject_icons.dart';
import '../../home/data/models/home_tone.dart';
import 'models/schedule_lesson_model.dart';

class ScheduleLessonMapper {
  ScheduleLessonMapper._();

  static List<ScheduleLessonModel> forDay(ClassroomStore store, DateTime day) {
    final lessons = store.lessonsOn(day.weekday);
    final result = <ScheduleLessonModel>[];
    for (var i = 0; i < lessons.length; i++) {
      final lesson = lessons[i];
      final group = store.groupById(lesson.groupId);
      if (group == null) continue;
      result.add(
        ScheduleLessonModel(
          id: lesson.id,
          title: '${lesson.subject} - ${group.name}',
          grade: group.year.label,
          studentsCount: group.students.length,
          startTime: formatTime(lesson.time),
          endTime: formatTime(lesson.endTime),
          placeLabel: lesson.placeLabel,
          placeType: lesson.placeType,
          icon: SubjectIcons.of(lesson.subject),
          tone: HomeTone.values[i % HomeTone.values.length],
        ),
      );
    }
    return result;
  }

  static bool hasLessons(ClassroomStore store, DateTime day) {
    return store.lessonsOn(day.weekday).isNotEmpty;
  }
}
