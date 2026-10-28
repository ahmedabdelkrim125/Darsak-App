enum StudentGrade {
  primary('ابتدائي'),
  preparatory('إعدادي'),
  secondary('ثانوي'),
  university('جامعي');

  const StudentGrade(this.label);

  final String label;
}
