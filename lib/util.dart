/// Utility functions for Zefyr.
library zefyr.util;

import 'dart:math' as math;

import 'package:zefyrka/quill_format/src/quill_delta.dart';

export 'src/fast_diff.dart';

int getPositionDelta(Delta user, Delta actual) {
  final userIter = DeltaIterator(user);
  final actualIter = DeltaIterator(actual);
  var diff = 0;
  while (userIter.hasNext || actualIter.hasNext) {
    final length = math.min(userIter.peekLength(), actualIter.peekLength());
    final userOp = userIter.next(length);
    final actualOp = actualIter.next(length);
    assert(userOp.length == actualOp.length);
    if (userOp.key == actualOp.key) continue;
    if (userOp.isInsert && actualOp.isRetain) {
      diff -= userOp.length;
    } else if (userOp.isDelete && actualOp.isRetain) {
      diff += userOp.length;
    } else if (userOp.isRetain && actualOp.isInsert) {
      final opText = actualOp.data is String ? (actualOp.data as String?)! : '';
      if (opText.startsWith('\n')) {
        // At this point user input reached its end (retain). If a heuristic
        // rule inserts a new line we should keep cursor on it's original position.
        continue;
      }
      diff += actualOp.length;
    } else {
      // TODO: this likely needs to cover more edge cases.
    }
  }
  return diff;
}

extension LinkValidation on Uri {
  bool get isWww => path.length > 3 && path.substring(0, 3).toLowerCase() == 'www';

  bool get hasValidScheme => ['https', 'http'].contains(scheme);

  bool get isValid {
    // TODO: might need a more robust way of validating links here.
    return hasValidScheme || isWww;
  }
}
