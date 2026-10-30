import '../../../../core/const/school_year.dart';
import 'classroom_student.dart';

class ClassroomGroup {
  const ClassroomGroup({
    required this.id,
    required this.name,
    required this.subject,
    required this.year,
    required this.monthlyFee,
    this.students = const [],
  });

  final String id;
  final String name;
  final String subject;
  final SchoolYear year;
  final int monthlyFee;
  final List<ClassroomStudent> students;

  ClassroomGroup copyWith({List<ClassroomStudent>? students}) {
    return ClassroomGroup(
      id: id,
      name: name,
      subject: subject,
      year: year,
      monthlyFee: monthlyFee,
      students: students ?? this.students,
    );
  }
}
