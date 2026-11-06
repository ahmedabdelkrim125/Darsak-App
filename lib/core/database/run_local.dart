import 'dart:async';
import 'package:flutter/foundation.dart';
import 'sync_signal.dart';

void runLocal(Future<void> Function() task) {
  unawaited(
    task()
        .then<void>((_) => SyncSignal.onLocalWrite?.call())
        .catchError((Object error) {
          if (kDebugMode) debugPrint('[DB] $error');
        }),
  );
}
