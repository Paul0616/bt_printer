import 'dart:typed_data';

import 'datecs_response_adapter.dart';

class DatecsAnswer {
  String errorCode = "";
  Uint8List answer;

  DatecsAnswer({required this.answer});
}

class DatecsAnswerReadStatus extends DatecsAnswer {
  DatecsAnswerReadStatus({required Uint8List answer}) : super(answer: answer) {
    //errorCode = "";
    //this.answer = answer;

    //errorCode is always
    errorCode = DatecsResponseAdapter.getFirstParameter(answer: this.answer);
    this.answer =
        DatecsResponseAdapter.removeFirstParameter(answer: this.answer);
  }
}

class DatecsAnswerFreeTextLine extends DatecsAnswer {
  DatecsAnswerFreeTextLine({required Uint8List answer})
      : super(answer: answer) {
    // errorCode = "";
    // this.answer = answer;

    //errorCode is always
    errorCode = DatecsResponseAdapter.getFirstParameter(answer: this.answer);
    this.answer =
        DatecsResponseAdapter.removeFirstParameter(answer: this.answer);
  }
}

class DatecsAnswerSeparatorLine extends DatecsAnswer {
  DatecsAnswerSeparatorLine({required Uint8List answer})
      : super(answer: answer) {
    // errorCode = "";
    // this.answer = answer;

    //errorCode is always
    errorCode = DatecsResponseAdapter.getFirstParameter(answer: this.answer);
    this.answer =
        DatecsResponseAdapter.removeFirstParameter(answer: this.answer);
  }
}

class DatecsAnswerOpenFiscalReceipt extends DatecsAnswer {
  int slipNumber = 0;
  int numberOfZReport = 0;
  int numberOfFiscalReceipt = 0;

  DatecsAnswerOpenFiscalReceipt({required Uint8List answer})
      : super(answer: answer) {
    // errorCode = "";
    // this.answer = answer;
    slipNumber = 0;
    numberOfFiscalReceipt = 0;
    numberOfZReport = 0;

    //errorCode is always
    errorCode = DatecsResponseAdapter.getFirstParameter(answer: this.answer);
    this.answer =
        DatecsResponseAdapter.removeFirstParameter(answer: this.answer);
    List<int> listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      slipNumber = int.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }

    listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      numberOfZReport = int.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }

    listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      numberOfFiscalReceipt = int.tryParse(
              DatecsResponseAdapter.getFirstParameter(
                  answer: Uint8List.fromList(listInt))) ??
          0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }
  }
}

class DatecsAnswerOpenNonFiscalReceipt extends DatecsAnswer {
  int slipNumber = 0;

  DatecsAnswerOpenNonFiscalReceipt({required Uint8List answer})
      : super(answer: answer) {
    // errorCode = "";
    // this.answer = answer;
    slipNumber = 0;

    //errorCode is always
    errorCode = DatecsResponseAdapter.getFirstParameter(answer: this.answer);
    this.answer =
        DatecsResponseAdapter.removeFirstParameter(answer: this.answer);
    List<int> listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      slipNumber = int.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }
  }
}

class DatecsAnswerAddItemOnFiscalReceipt extends DatecsAnswer {
  int slipNumber = 0;
  int numberOfZReport = 0;
  int numberOfFiscalReceipt = 0;

  DatecsAnswerAddItemOnFiscalReceipt({required Uint8List answer})
      : super(answer: answer) {
    // errorCode = "";
    // this.answer = answer;
    slipNumber = 0;
    numberOfFiscalReceipt = 0;
    numberOfZReport = 0;

    //errorCode is always
    errorCode = DatecsResponseAdapter.getFirstParameter(answer: this.answer);
    this.answer =
        DatecsResponseAdapter.removeFirstParameter(answer: this.answer);
    List<int> listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      slipNumber = int.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }

    listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      numberOfZReport = int.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }

    listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      numberOfFiscalReceipt = int.tryParse(
              DatecsResponseAdapter.getFirstParameter(
                  answer: Uint8List.fromList(listInt))) ??
          0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }
  }
}

class DatecsAnswerAddItemOnNonFiscalReceipt extends DatecsAnswer {
  DatecsAnswerAddItemOnNonFiscalReceipt({required Uint8List answer})
      : super(answer: answer) {
    // errorCode = "";
    // this.answer = answer;

    //errorCode is always
    errorCode = DatecsResponseAdapter.getFirstParameter(answer: this.answer);
    this.answer =
        DatecsResponseAdapter.removeFirstParameter(answer: this.answer);
  }
}

class DatecsAnswerCloseReceipt extends DatecsAnswer {
  int slipNumber = 0;
  int numberOfZReport = 0;
  int numberOfFiscalReceipt = 0;

  DatecsAnswerCloseReceipt({required Uint8List answer})
      : super(answer: answer) {
    // errorCode = "";
    // this.answer = answer;
    slipNumber = 0;
    numberOfFiscalReceipt = 0;
    numberOfZReport = 0;

    //errorCode is always
    errorCode = DatecsResponseAdapter.getFirstParameter(answer: this.answer);
    this.answer =
        DatecsResponseAdapter.removeFirstParameter(answer: this.answer);
    List<int> listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      slipNumber = int.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }

    listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      numberOfZReport = int.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }

    listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      numberOfFiscalReceipt = int.tryParse(
              DatecsResponseAdapter.getFirstParameter(
                  answer: Uint8List.fromList(listInt))) ??
          0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }
  }
}

class DatecsAnswerCloseNonFiscalReceipt extends DatecsAnswer {
  DatecsAnswerCloseNonFiscalReceipt({required Uint8List answer})
      : super(answer: answer) {
    // errorCode = "";
    // this.answer = answer;

    //errorCode is always
    errorCode = DatecsResponseAdapter.getFirstParameter(answer: this.answer);
    this.answer =
        DatecsResponseAdapter.removeFirstParameter(answer: this.answer);
  }
}

class DatecsAnswerReceiptInfo extends DatecsAnswer {
  bool isOpen = false;
  int numberOfReceipts = 0;
  int numberOfFiscalReceipt = 0;
  int numberOfZReport = 0;
  int numberOfItems = 0;
  double amountForReceipt = 0;
  double payedValue = 0;

  DatecsAnswerReceiptInfo({required Uint8List answer}) : super(answer: answer) {
    // errorCode = "";
    isOpen = false;
    numberOfReceipts = 0;
    numberOfFiscalReceipt = 0;
    numberOfZReport = 0;
    numberOfItems = 0;
    amountForReceipt = 0;
    payedValue = 0;
    // this.answer = answer;

    //errorCode is always
    errorCode = DatecsResponseAdapter.getFirstParameter(answer: this.answer);
    this.answer =
        DatecsResponseAdapter.removeFirstParameter(answer: this.answer);
    List<int> listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      if ((int.tryParse(DatecsResponseAdapter.getFirstParameter(
                  answer: Uint8List.fromList(listInt))) ??
              0) ==
          1) {
        isOpen = true;
      } else {
        isOpen = false;
      }
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }

    listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      numberOfReceipts = int.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }

    listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      numberOfZReport = int.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }

    listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      numberOfFiscalReceipt = int.tryParse(
              DatecsResponseAdapter.getFirstParameter(
                  answer: Uint8List.fromList(listInt))) ??
          0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }

    listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      numberOfItems = int.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }

    listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      amountForReceipt = double.tryParse(
              DatecsResponseAdapter.getFirstParameter(
                  answer: Uint8List.fromList(listInt))) ??
          0.0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }

    listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      payedValue = double.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0.0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }
  }
}

class DatecsAnswerDailySum extends DatecsAnswer {
  int numberOfReceipts = 0;
  double amount = 0;

  DatecsAnswerDailySum({required Uint8List answer}) : super(answer: answer) {
    // errorCode = "";
    numberOfReceipts = 0;
    amount = 0;
    // this.answer = answer;

    //errorCode is always
    errorCode = DatecsResponseAdapter.getFirstParameter(answer: this.answer);
    this.answer =
        DatecsResponseAdapter.removeFirstParameter(answer: this.answer);
    List<int> listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      numberOfReceipts = int.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }

    listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      amount = double.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0.0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }
  }
}

class DatecsAnswerAddPayment extends DatecsAnswer {
  String status = "";
  double amount = 0;

  DatecsAnswerAddPayment({required Uint8List answer}) : super(answer: answer) {
    // errorCode = "";
    status = "";
    amount = 0;
    // this.answer = answer;

    //errorCode is always
    errorCode = DatecsResponseAdapter.getFirstParameter(answer: this.answer);
    this.answer =
        DatecsResponseAdapter.removeFirstParameter(answer: this.answer);
    List<int> listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      status = DatecsResponseAdapter.getFirstParameter(
          answer: Uint8List.fromList(listInt));
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }

    listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      amount = double.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0.0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }
  }
}

class DatecsAnswerCashInOrOut extends DatecsAnswer {
  double cashSum = 0;
  double cashIn = 0;
  double cashOut = 0;

  DatecsAnswerCashInOrOut({required Uint8List answer}) : super(answer: answer) {
    // errorCode = "";
    cashSum = 0;
    cashIn = 0;
    cashOut = 0;
    // this.answer = answer;

    //errorCode is always
    errorCode = DatecsResponseAdapter.getFirstParameter(answer: this.answer);
    this.answer =
        DatecsResponseAdapter.removeFirstParameter(answer: this.answer);
    List<int> listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      cashSum = double.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0.0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }

    listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      cashIn = double.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0.0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }

    listInt = this.answer.toList();
    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      cashOut = double.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0.0;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }
  }
}

class DatecsAnswerReport extends DatecsAnswer {
  int numberOfZReport = 0;

  DatecsAnswerReport({required Uint8List answer}) : super(answer: answer) {
    // errorCode = "";
    numberOfZReport = 0;
    // this.answer = answer;

    //errorCode is always
    errorCode = DatecsResponseAdapter.getFirstParameter(answer: this.answer);
    this.answer =
        DatecsResponseAdapter.removeFirstParameter(answer: this.answer);
    List<int> listInt = this.answer.toList();

    if (DatecsResponseAdapter.checkIfExistParameter(answer: this.answer)) {
      listInt.removeAt(0);
      numberOfZReport = (int.tryParse(DatecsResponseAdapter.getFirstParameter(
              answer: Uint8List.fromList(listInt))) ??
          0.0) as int;
      this.answer = DatecsResponseAdapter.removeFirstParameter(
          answer: Uint8List.fromList(listInt));
    } else {
      return;
    }
  }
}

class DatecsAnswerReportZCopy extends DatecsAnswer {
  DatecsAnswerReportZCopy({required Uint8List answer}) : super(answer: answer) {
    // errorCode = "";
    // this.answer = answer;

    //errorCode is always
    errorCode = DatecsResponseAdapter.getFirstParameter(answer: this.answer);
    this.answer =
        DatecsResponseAdapter.removeFirstParameter(answer: this.answer);
  }
}

class DatecsAnswerOpenDrawer extends DatecsAnswer {
  DatecsAnswerOpenDrawer({required Uint8List answer}) : super(answer: answer) {
    // errorCode = "";
    // this.answer = answer;

    //errorCode is always
    errorCode = DatecsResponseAdapter.getFirstParameter(answer: this.answer);
    this.answer =
        DatecsResponseAdapter.removeFirstParameter(answer: this.answer);
  }
}

class DatecsAnswerReportZInInterval extends DatecsAnswer {
  DatecsAnswerReportZInInterval({required Uint8List answer})
      : super(answer: answer) {
    // errorCode = "";
    // this.answer = answer;

    //errorCode is always
    errorCode = DatecsResponseAdapter.getFirstParameter(answer: this.answer);
    this.answer =
        DatecsResponseAdapter.removeFirstParameter(answer: this.answer);
  }
}
