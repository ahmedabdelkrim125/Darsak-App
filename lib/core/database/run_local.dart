import 'dart:async';
import 'package:flutter/foundation.dart';

void runLocal(Future<void> Function() task) {
  unawaited(
    task().catchError((Object error) {
      if (kDebugMode) debugPrint('[DB] $error');
    }),
  );
}
