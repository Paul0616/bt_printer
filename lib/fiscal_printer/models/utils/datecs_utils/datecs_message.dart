import 'dart:typed_data';

import 'datecs_adapter.dart';
import 'datecs_commans.dart';

class DatecsMessage {
  Uint8List command;
  int _seq = 0;

  DatecsMessage({required this.command}) {
    // _command = command;
    _seq = DatecsAdapter.getNextSeqNumber();
  }

  Uint8List getMessage() {
    // 6 = 4(len) + 1 (seq) + 1 (postamble)
    List<int> list = [];
    var len = DatecsAdapter.calculateLength(6 + command.length);

    list.addAll(len);
    list.add(_seq);
    list.addAll(command);
    list.add(DatecsCommands.postAmble);

    list.addAll(DatecsAdapter.calculateCheckSum(Uint8List.fromList(list)));
    list.insert(0, DatecsCommands.preAmble);
    list.add(DatecsCommands.terminator);

    return Uint8List.fromList(list);
  }

  int get seqNo => _seq;
}
