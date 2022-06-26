import 'dart:typed_data';

import 'package:intl/intl.dart';

import '../../../../utils/helper.dart';
import 'datecs_adapter.dart';
import 'datecs_command_type.dart';
import 'datecs_discount_type.dart';
import 'datecs_report_type.dart';
import 'datecs_separator_line_type.dart';
import 'datecs_text_align.dart';

class DatecsCommands {
  static const int _separator = 0x09; //Horizontal tab is separator "\t"
  static int preAmble = 0x01;
  static int postAmble = 0x05;
  static int terminator = 0x03;
  static int offset = 0x30;
  static final Uint8List _commandPaperFeed =
      DatecsAdapter.generateCommand(command: 0x2C);

  static Uint8List paperFeed({required int lines}) {
    var list = BytesBuilder();
    list.add(_commandPaperFeed);
    if (lines > 0 && lines <= 9) {
      list.addByte(lines + offset);
    } else {
      list.addByte(0x01 + offset);
    }
    list.addByte(_separator);
    return list.toBytes();
  }

  static final Uint8List _commandReadStatus =
      DatecsAdapter.generateCommand(command: 0x4A);

  static Uint8List readStatus() {
    var list = BytesBuilder();
    list.add(_commandReadStatus);
    return list.toBytes();
  }

  static final Uint8List _commandOpenNonFiscalReceipt =
      DatecsAdapter.generateCommand(command: 0x26);

  static Uint8List openNonFiscalReceipt() {
    var list = BytesBuilder();
    list.add(_commandOpenNonFiscalReceipt);
    return list.toBytes();
  }

  static final Uint8List _commandCloseNonFiscalReceipt =
      DatecsAdapter.generateCommand(command: 0x27);

  static Uint8List closeNonFiscalReceipt() {
    var list = BytesBuilder();
    list.add(_commandCloseNonFiscalReceipt);
    return list.toBytes();
  }

  static final Uint8List _commandAddFreeTextLine =
      DatecsAdapter.generateCommand(command: 0x36);

  static Uint8List addFreeTextLine(
      {required String line,
      required DatecsTextAlign align,
      required bool bold,
      required bool italic,
      required bool doubleHeight,
      required bool underline}) {
    var list = BytesBuilder();

    list.add(_commandAddFreeTextLine);
    list.add(DatecsAdapter.convertStringToHex(value: line));
    list.addByte(_separator);

    if (bold) {
      list.addByte(0x01 + offset);
    } else {
      list.addByte(0x00 + offset);
    }
    list.addByte(_separator);

    if (italic) {
      list.addByte(0x01 + offset);
    } else {
      list.addByte(0x00 + offset);
    }
    list.addByte(_separator);

    if (doubleHeight) {
      list.addByte(0x01 + offset);
    } else {
      list.addByte(0x00 + offset);
    }
    list.addByte(_separator);

    if (underline) {
      list.addByte(0x01 + offset);
    } else {
      list.addByte(0x00 + offset);
    }
    list.addByte(_separator);

    list.addByte(align.value + offset);
    list.addByte(_separator);

    return list.toBytes();
  }

  static final Uint8List _commandAddNonFiscalItem =
      DatecsAdapter.generateCommand(command: 0x2A);

  static Uint8List addNonFiscalItem(
      {required String line,
      required DatecsTextAlign align,
      required bool bold,
      required bool italic,
      required bool doubleHeight,
      required bool underline}) {
    var list = BytesBuilder();

    list.add(_commandAddNonFiscalItem);
    list.add(DatecsAdapter.convertStringToHex(value: line));
    list.addByte(_separator);

    if (bold) {
      list.addByte(0x01 + offset);
    } else {
      list.addByte(0x00 + offset);
    }
    list.addByte(_separator);

    if (italic) {
      list.addByte(0x01 + offset);
    } else {
      list.addByte(0x00 + offset);
    }
    list.addByte(_separator);

    if (doubleHeight) {
      list.addByte(0x01 + offset);
    } else {
      list.addByte(0x00 + offset);
    }
    list.addByte(_separator);

    if (underline) {
      list.addByte(0x01 + offset);
    } else {
      list.addByte(0x00 + offset);
    }
    list.addByte(_separator);
    list.addByte(align.value + offset);
    list.addByte(_separator);
    return list.toBytes();
  }

  static final Uint8List _commandSeparatorLine =
      DatecsAdapter.generateCommand(command: 0x5C);

  static Uint8List separatorLine(DatecsSeparatorLineType type) {
    var list = BytesBuilder();
    list.add(_commandSeparatorLine);
    list.addByte(type.value + offset);
    list.addByte(_separator);
    return list.toBytes();
  }

  static final Uint8List _commandOpenDrawer =
      DatecsAdapter.generateCommand(command: 0x6A);

  static Uint8List openDrawer() {
    var list = BytesBuilder();
    list.add(_commandOpenDrawer);
    list.add(DatecsAdapter.convertDoubleToHex(value: 2000));
    list.addByte(_separator);
    return list.toBytes();
  }

  static final Uint8List _commandDailySum =
      DatecsAdapter.generateCommand(command: 0x70);

  static Uint8List dailySum({required String operatorCode}) {
    var list = BytesBuilder();
    list.add(_commandDailySum);
    list.add(DatecsAdapter.convertStringToHex(value: operatorCode));
    list.addByte(_separator);
    return list.toBytes();
  }

  static final Uint8List _commandCloseFiscalReceipt =
      DatecsAdapter.generateCommand(command: 0x38);

  static Uint8List closeFiscalReceipt() {
    var list = BytesBuilder();
    list.add(_commandCloseFiscalReceipt);
    return list.toBytes();
  }

  static final Uint8List _commandOpenFiscalReceipt =
      DatecsAdapter.generateCommand(command: 0x30);

  static Uint8List openFiscalReceipt(
      {required String operatorCode,
      required String password,
      String? clientUniqueCode}) {
    var list = BytesBuilder();

    list.add(_commandOpenFiscalReceipt);
    list.add(DatecsAdapter.convertStringToHex(value: operatorCode));
    list.addByte(_separator);
    list.add(DatecsAdapter.convertStringToHex(value: password));
    list.addByte(_separator);
    //number of point of sale
    list.addByte(0x01 + offset);
    list.addByte(_separator);

    if (clientUniqueCode != null) {
      if (clientUniqueCode.isNotEmpty) {
        list.add(DatecsAdapter.convertStringToHex(value: "I"));
        list.addByte(_separator);
        list.add(DatecsAdapter.convertStringToHex(value: clientUniqueCode));
        list.addByte(_separator);
      }
    }
    return list.toBytes();
  }

  static final Uint8List _commandCancelFiscalReceipt =
      DatecsAdapter.generateCommand(command: 0x3C);

  static Uint8List cancelFiscalReceipt() {
    var list = BytesBuilder();
    list.add(_commandCancelFiscalReceipt);
    return list.toBytes();
  }

  static final Uint8List _commandCashInOrOut =
      DatecsAdapter.generateCommand(command: 0x46);

  static Uint8List cashIn({required double amount}) {
    var list = BytesBuilder();
    double value = Helper.roundDouble(amount, 2);
    list.add(_commandCashInOrOut);
    list.addByte(0x00 + offset);
    list.addByte(_separator);
    list.add(DatecsAdapter.convertDoubleToHex(value: value));
    list.addByte(_separator);
    return list.toBytes();
  }

  static Uint8List cashOut({required double amount}) {
    var list = BytesBuilder();
    double value = Helper.roundDouble(amount, 2);
    list.add(_commandCashInOrOut);
    list.addByte(0x01 + offset);
    list.addByte(_separator);
    list.add(DatecsAdapter.convertDoubleToHex(value: value));
    list.addByte(_separator);
    return list.toBytes();
  }

  static final Uint8List _commandReport =
      DatecsAdapter.generateCommand(command: 0x45);

  static Uint8List report(DatecsReportType reportType) {
    var list = BytesBuilder();
    list.add(_commandReport);
    list.add(DatecsAdapter.convertStringToHex(value: reportType.value));
    list.addByte(_separator);
    return list.toBytes();
  }

  static final Uint8List _commandReportInIntervalByDate =
      DatecsAdapter.generateCommand(command: 0x5E);

  static Uint8List reportZInInterval(
      {required DateTime startDate,
      required DateTime stopDate,
      required bool detailed}) {
    var list = BytesBuilder();
    var startDateString = DateFormat("dd-MM-yy").format(startDate);
    var stopDateString = DateFormat("dd-MM-yy").format(stopDate);
    list.add(_commandReportInIntervalByDate);
    //0x00 for short and 0x01 for detailed
    if (detailed) {
      list.addByte(0x01 + offset);
    } else {
      list.addByte(0x00 + offset);
    }
    list.addByte(_separator);
    list.add(DatecsAdapter.convertStringToHex(value: startDateString));
    list.addByte(_separator);
    list.add(DatecsAdapter.convertStringToHex(value: stopDateString));
    list.addByte(_separator);
    return list.toBytes();
  }

  static final Uint8List _commandReportInInterval =
      DatecsAdapter.generateCommand(command: 0x5F);

  static Uint8List reportZCopy(
      {required String number, required bool detailed}) {
    var list = BytesBuilder();
    list.add(_commandReportInInterval);
    //0x00 for short and 0x01 for detailed
    if (detailed) {
      list.addByte(0x01 + offset);
    } else {
      list.addByte(0x00 + offset);
    }
    list.addByte(_separator);
    list.add(DatecsAdapter.convertDoubleToHex(
        value: double.tryParse(number) ?? 1.0));
    list.addByte(_separator);
    list.add(DatecsAdapter.convertDoubleToHex(
        value: (double.tryParse(number) ?? 1.0) + 1.0));
    list.addByte(_separator);
    return list.toBytes();
  }

  static final Uint8List _commandAddPayment =
      DatecsAdapter.generateCommand(command: 0x35);

  static Uint8List addPayment(
      {required String payMethod, required double amount}) {
    var list = BytesBuilder();
    double value = Helper.roundDouble(amount, 2);
    list.add(_commandAddPayment);
    list.add(DatecsAdapter.convertStringToHex(value: payMethod));
    list.addByte(_separator);
    if (value != 0) {
      list.add(DatecsAdapter.convertDoubleToHex(value: value));
    }
    list.addByte(_separator);
    return list.toBytes();
  }

  static final Uint8List _commandAddItemOnFiscalReceipt =
      DatecsAdapter.generateCommand(command: 0x31);

  static Uint8List addItemOnFiscalReceipt(
      {required String productName,
      required String vatCode,
      required double unitPrice,
      required double units,
      required double discountValue,
      required String departmentCode,
      required String unitMeasureName}) {
    var list = BytesBuilder();
    var pluName = productName;
    if (pluName.length > 36) {
      pluName = pluName.substring(0, 36);
    }
    var price = Helper.roundDouble(unitPrice, 2);
    var quantity = Helper.roundDouble(units, 3);
    var discount = Helper.roundDouble(discountValue, 2);
    DatecsDiscountType discountType;
    if (discountValue == 0) {
      discountType = DatecsDiscountType.noDiscount;
    } else {
      discountType = DatecsDiscountType.absolutDiscount;
    }
    String department = departmentCode;
    if (department.isEmpty) {
      department = "0";
    }
    String unitMeasure = unitMeasureName;
    if (unitMeasure.isEmpty) {
      unitMeasure = "buc";
    } else if (unitMeasureName.length > 3) {
      unitMeasure = unitMeasureName.substring(0, 3);
    }

    list.add(_commandAddItemOnFiscalReceipt);
    list.add(DatecsAdapter.convertStringToHex(value: pluName));
    list.addByte(_separator);
    list.addByte((int.tryParse(vatCode) ?? 0x00) + offset);
    list.addByte(_separator);
    list.add(DatecsAdapter.convertDoubleToHex(value: price));
    list.addByte(_separator);
    list.add(DatecsAdapter.convertDoubleToHex(value: quantity, decimalsNo: 3));
    list.addByte(_separator);
    list.addByte(discountType.value + offset);
    list.addByte(_separator);
    if (discountType != DatecsDiscountType.noDiscount) {
      list.add(DatecsAdapter.convertDoubleToHex(value: discount));
    }
    list.addByte(_separator);
    list.add(DatecsAdapter.convertStringToHex(value: department));
    list.addByte(_separator);
    list.add(DatecsAdapter.convertStringToHex(value: unitMeasure));
    list.addByte(_separator);
    return list.toBytes();
  }

  static final Uint8List _commandSubtotal =
      DatecsAdapter.generateCommand(command: 0x33);

  static Uint8List subtotal(
      {required DatecsDiscountType discountType,
      required double discountValue}) {
    var list = BytesBuilder();
    var discount = Helper.roundDouble(discountValue, 2);
    list.add(_commandSubtotal);
    // 0x01 for print , 0x00 for no print
    list.addByte(0x01 + offset);
    list.addByte(_separator);
    // 0x01 for display , 0x00 for no display
    list.addByte(0x01 + offset);
    list.addByte(_separator);
    list.addByte(discountType.value + offset);
    list.addByte(_separator);
    if (discountType != DatecsDiscountType.noDiscount) {
      list.add(DatecsAdapter.convertDoubleToHex(value: discount));
    }
    list.addByte(_separator);
    return list.toBytes();
  }

  static final Uint8List _commandReceiptInfo =
      DatecsAdapter.generateCommand(command: 0x4C);

  static Uint8List receiptInfo() {
    var list = BytesBuilder();
    list.add(_commandReceiptInfo);
    return list.toBytes();
  }

  static bool sameCommand(
      {required Uint8List firstCommand, required Uint8List secondCommand}) {
    if (firstCommand.length != 4 || secondCommand.length != 4) {
      return false;
    }

    for (var i = 0; i < 4; i++) {
      if (firstCommand[i] != secondCommand[i]) {
        return false;
      }
    }

    return true;
  }

  static DatecsCommandType getCommandType(Uint8List command) {
    if (sameCommand(
        firstCommand: _commandOpenFiscalReceipt, secondCommand: command)) {
      return DatecsCommandType.openFiscalReceipt;
    } else if (sameCommand(
        firstCommand: _commandCloseFiscalReceipt, secondCommand: command)) {
      return DatecsCommandType.closeFiscalReceipt;
    } else if (sameCommand(
        firstCommand: _commandAddItemOnFiscalReceipt, secondCommand: command)) {
      return DatecsCommandType.addItemOnFiscalReceipt;
    } else if (sameCommand(
        firstCommand: _commandAddPayment, secondCommand: command)) {
      return DatecsCommandType.addPayment;
    } else if (sameCommand(
        firstCommand: _commandSubtotal, secondCommand: command)) {
      return DatecsCommandType.subtotal;
    } else if (sameCommand(
        firstCommand: _commandSeparatorLine, secondCommand: command)) {
      return DatecsCommandType.separatorLine;
    } else if (sameCommand(
        firstCommand: _commandAddFreeTextLine, secondCommand: command)) {
      return DatecsCommandType.freeTextLine;
    } else if (sameCommand(
        firstCommand: _commandCancelFiscalReceipt, secondCommand: command)) {
      return DatecsCommandType.cancelFiscalReceipt;
    } else if (sameCommand(
        firstCommand: _commandReceiptInfo, secondCommand: command)) {
      return DatecsCommandType.receiptInfo;
    } else if (sameCommand(
        firstCommand: _commandOpenNonFiscalReceipt, secondCommand: command)) {
      return DatecsCommandType.openNonFiscalReceipt;
    } else if (sameCommand(
        firstCommand: _commandCloseNonFiscalReceipt, secondCommand: command)) {
      return DatecsCommandType.closeNonFiscalReceipt;
    } else if (sameCommand(
        firstCommand: _commandAddNonFiscalItem, secondCommand: command)) {
      return DatecsCommandType.addItemOnNonFiscalReceipt;
    } else if (sameCommand(
        firstCommand: _commandReadStatus, secondCommand: command)) {
      return DatecsCommandType.getStatus;
    }

    return DatecsCommandType.noCommand;
  }
}
