class ClassroomStudent {
  const ClassroomStudent({required this.id, required this.name, this.username});

  final String id;
  final String name;
  final String? username;

  bool get hasAccount => username != null;
}
