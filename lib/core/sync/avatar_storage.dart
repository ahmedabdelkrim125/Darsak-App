import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AvatarStorage {
  AvatarStorage._();

  static Future<Directory> _directory() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}${Platform.pathSeparator}avatars');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  static Future<String> persist(String sourcePath, String userId) async {
    final dir = await _directory();
    if (sourcePath.startsWith(dir.path)) return sourcePath;
    final target = File(
      '${dir.path}${Platform.pathSeparator}${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await File(sourcePath).copy(target.path);
    return target.path;
  }

  static Future<String> saveBytes(List<int> bytes, String userId) async {
    final dir = await _directory();
    final target = File(
      '${dir.path}${Platform.pathSeparator}${userId}_remote_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    await target.writeAsBytes(bytes, flush: true);
    return target.path;
  }
}
