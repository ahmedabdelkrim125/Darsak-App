import 'package:flutter/widgets.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../../core/session/app_session.dart';

class SubjectIcons {
  SubjectIcons._();

  static const List<(IconData, List<String>)> _rules = [
    (SolarIconsOutline.calculator, ['رياض', 'حساب', 'جبر', 'هندس', 'math']),
    (SolarIconsOutline.magnet, ['فيزياء', 'physics']),
    (SolarIconsOutline.testTube, ['كيمياء', 'chem']),
    (SolarIconsOutline.dna, ['أحياء', 'احياء', 'bio']),
    (
      SolarIconsOutline.translation,
      ['لغة', 'عربي', 'انجليز', 'إنجليز', 'فرنس', 'english', 'arabic'],
    ),
    (SolarIconsOutline.map, ['تاريخ', 'جغراف', 'دراسات']),
    (SolarIconsOutline.monitor, ['حاسب', 'برمج', 'كمبيوتر', 'تكنولوجيا']),
    (SolarIconsOutline.palette, ['رسم', 'فن']),
    (SolarIconsOutline.atom, ['علوم', 'science']),
  ];

  static IconData of(String subject) {
    final text = AppSession.normalize(subject).toLowerCase();
    for (final rule in _rules) {
      if (rule.$2.any(text.contains)) return rule.$1;
    }
    return SolarIconsOutline.book;
  }
}
