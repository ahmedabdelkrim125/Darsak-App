import 'student_grade.dart';

enum SchoolYear {
  primary1(StudentGrade.primary, 'الأول', 'الصف الأول الابتدائي'),
  primary2(StudentGrade.primary, 'الثاني', 'الصف الثاني الابتدائي'),
  primary3(StudentGrade.primary, 'الثالث', 'الصف الثالث الابتدائي'),
  primary4(StudentGrade.primary, 'الرابع', 'الصف الرابع الابتدائي'),
  primary5(StudentGrade.primary, 'الخامس', 'الصف الخامس الابتدائي'),
  primary6(StudentGrade.primary, 'السادس', 'الصف السادس الابتدائي'),
  preparatory1(StudentGrade.preparatory, 'الأول', 'الصف الأول الإعدادي'),
  preparatory2(StudentGrade.preparatory, 'الثاني', 'الصف الثاني الإعدادي'),
  preparatory3(StudentGrade.preparatory, 'الثالث', 'الصف الثالث الإعدادي'),
  secondary1(StudentGrade.secondary, 'الأول', 'الصف الأول الثانوي'),
  secondary2(StudentGrade.secondary, 'الثاني', 'الصف الثاني الثانوي'),
  secondary3(StudentGrade.secondary, 'الثالث', 'الصف الثالث الثانوي'),
  university(StudentGrade.university, 'جامعي', 'المرحلة الجامعية');

  const SchoolYear(this.stage, this.shortLabel, this.label);

  final StudentGrade stage;
  final String shortLabel;
  final String label;

  static List<SchoolYear> of(StudentGrade stage) {
    return values.where((year) => year.stage == stage).toList();
  }
}
