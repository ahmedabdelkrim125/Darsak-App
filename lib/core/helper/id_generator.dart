import 'package:uuid/uuid.dart';
import 'date_key.dart';

class IdGenerator {
  IdGenerator._();

  static const Uuid _uuid = Uuid();

  static String newId() => _uuid.v4();

  static String attendanceId(String studentId, DateTime date) {
    return _uuid.v5(
      Namespace.url.value,
      'attendance:$studentId:${DateKey.of(date)}',
    );
  }
}
