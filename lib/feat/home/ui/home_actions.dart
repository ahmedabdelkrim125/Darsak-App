import 'package:flutter/material.dart';
import '../../../core/widgets/app_toast.dart';
import '../../classroom/data/classroom_store.dart';
import '../../classroom/ui/add_group_sheet.dart';
import '../../classroom/ui/add_lesson_sheet.dart';
import '../../classroom/ui/add_student_sheet.dart';
import '../../classroom/ui/lesson_details_sheet.dart';
import '../data/home_content.dart';
import '../data/models/home_quick_action_model.dart';

class HomeActions {
  HomeActions._();

  static void quickAction(BuildContext context, HomeQuickActionId id) {
    switch (id) {
      case HomeQuickActionId.addLesson:
        addLesson(context);
      case HomeQuickActionId.addGroup:
        AddGroupSheet.show(context);
      case HomeQuickActionId.addStudent:
        addStudent(context);
      case HomeQuickActionId.uploadContent:
        comingSoon(context);
    }
  }

  static void addLesson(BuildContext context) {
    if (!_ensureGroups(context)) return;
    AddLessonSheet.show(context);
  }

  static void addStudent(BuildContext context) {
    if (!_ensureGroups(context)) return;
    AddStudentSheet.show(context);
  }

  static void openLesson(BuildContext context, String lessonId) {
    LessonDetailsSheet.show(context, lessonId);
  }

  static void comingSoon(BuildContext context) {
    AppToast.show(context, HomeContent.comingSoon);
  }

  static bool _ensureGroups(BuildContext context) {
    if (ClassroomStore.instance.groups.isNotEmpty) return true;
    AppToast.show(context, 'أضف مجموعة أولاً');
    AddGroupSheet.show(context);
    return false;
  }
}
