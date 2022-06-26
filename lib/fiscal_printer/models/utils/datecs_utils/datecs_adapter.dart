import 'dart:convert';
import 'dart:typed_data';

import '../../../../utils/globals.dart';
import '../../../../utils/helper.dart';
import 'datecs_commans.dart';

class DatecsAdapter {
  static Uint8List generateCommand({required int command}) {
    var cmd = BytesBuilder();
    cmd.addByte(DatecsCommands.offset);
    cmd.addByte(DatecsCommands.offset);
    //command >> 4 -> get first 4 bits
    cmd.addByte((command >> 4) + DatecsCommands.offset);
    //command & 0x0F -> get last 4 bits
    cmd.addByte((command & 0x0F) + DatecsCommands.offset);
    return cmd.toBytes();
  }

  static Uint8List convertStringToHex({required String value}) =>
      Uint8List.fromList(utf8.encode(Helper.replaceDiacritics(value)));

  static Uint8List convertDoubleToHex(
      {required double value, int decimalsNo = 2}) {
    var valueString = value.toStringAsFixed(decimalsNo);
    var list = BytesBuilder();
    valueString.split('').forEach((item) {
      if (item.codeUnitAt(0) >= "0".codeUnitAt(0) &&
          item.codeUnitAt(0) <= "9".codeUnitAt(0)) {
        var hex = item.codeUnitAt(0);
        list.addByte(hex);
      }
      if (item == ".") {
        list.addByte(".".codeUnitAt(0));
      }
      if (item == "-") {
        list.addByte("-".codeUnitAt(0));
      }
    });
    if (value.toInt().toDouble() - value == 0) {
      var list1 = list.toBytes().sublist(0, list.toBytes().length - 2);
      return Uint8List.fromList(list1);
    }
    return list.toBytes();
  }

  static String convertHexListToString({required Uint8List list}) {
    List<String> result = [];
    for (var item in list) {
      if (item >= 0 && item <= 9) {
        result.add("0$item");
      } else {
        result.add(item.toRadixString(16).toUpperCase());
      }
    }
    return result.join(" ");
  }

  static String convertHexToString({required int item}) {
    String result = "";
    var character = utf8.decode([item]).toUpperCase();
    if (character.codeUnits.first >= "0".codeUnits.first &&
        item <= "9".codeUnits.first) {
      result += character;
    }
    if (character == ".") {
      result += ".";
    }
    if (character == "-") {
      result += "-";
    }
    return result;
  }

  static int getNextSeqNumber() {
    var globals = Globals();
    globals.datecsLastSequenceNumber++;
    if ((globals.datecsLastSequenceNumber + 0x20) > 255) {
      globals.datecsLastSequenceNumber = 1;
    }
    var sequence = globals.datecsLastSequenceNumber + 0x20;
    return sequence;
  }

  static Uint8List calculateLength(int value) {
    var len = BytesBuilder();
    var length = value + 0x20;
    len.addByte(DatecsCommands.offset);
    len.addByte(DatecsCommands.offset);
    len.addByte((length >> 4) + DatecsCommands.offset);
    len.addByte((length & 0x0F) + DatecsCommands.offset);
    return len.toBytes();
  }

  static Uint8List calculateCheckSum(Uint8List message) {
    int sum = 0;
    for (var item in message) {
      sum += item;
    }
    return checkSum(sum);
  }

  static Uint8List checkSum(int value) {
    var crc = BytesBuilder();
    var b = value;
    var crc3 = (b & 0x0F) + DatecsCommands.offset;
    var crc2 = ((b & 0xF0) >> 4) + DatecsCommands.offset;

    b = value >> 8;
    var crc1 = (b & 0x0F) + DatecsCommands.offset;
    var crc0 = ((b & 0xF0) >> 4) + DatecsCommands.offset;

    crc.addByte(crc0);
    crc.addByte(crc1);
    crc.addByte(crc2);
    crc.addByte(crc3);
    return crc.toBytes();
  }
}
