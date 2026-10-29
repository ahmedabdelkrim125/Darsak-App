import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'home_icons.dart';
import 'models/home_file_model.dart';
import 'models/home_lesson_model.dart';
import 'models/home_quick_action_model.dart';
import 'models/home_tone.dart';

class HomeContent {
  HomeContent._();

  static const String userName = 'أحمد';
  static const String greetingNote = 'مستعد ليوم دراسي مميز؟';
  static const int notificationCount = 3;

  static const String bannerTitle = 'نظم دروسك\nبسهولة';
  static const String bannerDescription =
      'أدر حصصك، طلابك، ومواعيدك في مكان واحد.';

  static const String lessonsTitle = 'حصص اليوم';
  static const String lessonsAction = 'عرض الجدول الكامل';
  static const String filesTitle = 'أحدث الملفات';
  static const String filesAction = 'عرض الكل';

  static const List<HomeQuickActionModel> quickActions = [
    HomeQuickActionModel(
      label: 'إضافة حصة',
      icon: HomeIcons.addLesson,
      tone: HomeTone.primary,
    ),
    HomeQuickActionModel(
      label: 'إضافة مجموعة',
      icon: HomeIcons.addGroup,
      tone: HomeTone.accent,
    ),
    HomeQuickActionModel(
      label: 'إضافة طالب',
      icon: HomeIcons.addStudent,
      tone: HomeTone.primary,
    ),
    HomeQuickActionModel(
      label: 'رفع محتوى',
      icon: HomeIcons.uploadContent,
      tone: HomeTone.accent,
    ),
  ];

  static const List<HomeLessonModel> lessons = [
    HomeLessonModel(
      title: 'الرياضيات - مجموعة أ',
      grade: 'الصف الأول الثانوي',
      studentsCount: 12,
      time: '10:00 ص',
      tone: HomeTone.primary,
    ),
    HomeLessonModel(
      title: 'الفيزياء - مجموعة ب',
      grade: 'الصف الثالث الثانوي',
      studentsCount: 15,
      time: '12:30 م',
      tone: HomeTone.accent,
    ),
    HomeLessonModel(
      title: 'مراجعة شاملة',
      grade: 'الصف الثالث الثانوي',
      studentsCount: 20,
      time: '4:00 م',
      tone: HomeTone.violet,
    ),
  ];

  static const List<HomeFileModel> files = [
    HomeFileModel(
      name: 'ملخص الدرس',
      meta: 'PDF - 1.8 MB',
      icon: HomeIcons.document,
      color: AppColors.primary,
    ),
    HomeFileModel(
      name: 'شرح الدرس',
      meta: 'MP4 - 45 MB',
      icon: HomeIcons.video,
      color: Color(0xFF22C55E),
    ),
    HomeFileModel(
      name: 'واجب الأسبوع',
      meta: 'IMG - 1.1 MB',
      icon: HomeIcons.image,
      color: Color(0xFF3B82F6),
    ),
    HomeFileModel(
      name: 'مراجعة نهائية',
      meta: 'PDF - 2.4 MB',
      icon: HomeIcons.pdf,
      color: Color(0xFFEF4444),
    ),
  ];
}
