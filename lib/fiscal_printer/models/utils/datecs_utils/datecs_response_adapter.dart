import 'dart:typed_data';

import 'datecs_adapter.dart';
import 'datecs_error_codes.dart';

class DatecsResponseAdapter {
  static int separator = 0x09;
  final int _secondSeparator = 0x04;
  final int _preAmble = 0x01;
  final int _postAmble = 0x05;
  final int _terminator = 0x03;
  final int _nak = 0x15;
  final int _syn = 0x16;

  bool _isOk = true;
  bool _waitToGetResponse = false;
  Uint8List _data = BytesBuilder().toBytes();
  Uint8List _status = BytesBuilder().toBytes();
  Uint8List _cmd = BytesBuilder().toBytes();
  int? _seq;

  DatecsResponseAdapter(
      {required Uint8List response, required int sequenceNumber}) {
    _isOk = true;
    _waitToGetResponse = false;
    _data = BytesBuilder().toBytes();
    _status = BytesBuilder().toBytes();
    _cmd = BytesBuilder().toBytes();
    var res = _formatResponse(response: response);

    if (_isOk) {
      if (_waitToGetResponse) {
        return;
      }
      if (res.length > 5) {
        List<int> res1 = res.toList();
        for (int i = 0; i < 5; i++) {
          res1.removeAt(0);
        }
        res = Uint8List.fromList(res1);
      }

      ///<SEQ>
      if (res.length > 1) {
        List<int> res1 = res.toList();
        _seq = res[0];
        res1.removeAt(0);
        res = Uint8List.fromList(res1);
      }

      if (_seq != sequenceNumber) {
        _waitToGetResponse = true;
        return;
      }

      ///<CMD>
      if (res.length > 4) {
        List<int> res1 = res.toList();
        var cmd1 = BytesBuilder();
        for (int i = 0; i < 4; i++) {
          cmd1.addByte(res1[0]);
          res1.removeAt(0);
        }
        res = Uint8List.fromList(res1);
        _cmd = cmd1.toBytes();
      }

      _data = _getDataFromResponse(response: res);
      List<int> res1 = res.toList();
      for (var i = 0; i < _data.length; i++) {
        if (res1.isNotEmpty) {
          res1.removeAt(0);
        }
      }
      res = Uint8List.fromList(res1);
      res1 = res.toList();
      if (res1.isNotEmpty && res1[0] == _secondSeparator) {
        res1.removeAt(0);
      }
      res = Uint8List.fromList(res1);

      _status = _getStatusFromResponse(response: res);
      if (_status.length == 8) {
        //print("PrinterStatus(HEX)= ->${DatecsAdapter.convertHexListToString(list: _status)}");
      }
    } else {
      _waitToGetResponse = false;
    }

    // print("isOK: $_isOk");
    // print("wait: $_waitToGetResponse");
  }

  Uint8List _formatResponse({required Uint8List response}) {
    List<int> res = response.toList();
    if (res.contains(_nak)) {
      _isOk = false;
    }

    if (!res.contains(_terminator)) {
      _waitToGetResponse = true;
      return Uint8List.fromList(res);
    }
    while (res.isNotEmpty && res[0] == _syn) {
      res.removeAt(0);
    }

    var list = BytesBuilder();
    while (res.isNotEmpty && res[0] != _terminator) {
      list.addByte(res[0]);
      res.removeAt(0);
    }
    list.addByte(_terminator);
    return list.toBytes();
  }

  Uint8List _getStatusFromResponse({required Uint8List response}) {
    var status = BytesBuilder();
    for (var item in response) {
      if (item != _postAmble) {
        status.addByte(item);
      } else {
        return status.toBytes();
      }
    }
    return status.toBytes();
  }

  Uint8List _getDataFromResponse({required Uint8List response}) {
    var answer = BytesBuilder();
    for (var item in response) {
      if (item != _secondSeparator) {
        answer.addByte(item);
      } else {
        return answer.toBytes();
      }
    }
    return answer.toBytes();
  }

  static String getFirstParameter({required Uint8List answer}) {
    var list = BytesBuilder();
    for (var item in answer) {
      if (item != separator) {
        list.addByte(item);
      } else {
        break;
      }
    }
    return convertParameterToString(list: list.toBytes());
  }

  static Uint8List removeFirstParameter({required Uint8List answer}) {
    var list = answer.toList();
    var index = 0;
    for (var item in list) {
      if (item != separator) {
        index++;
      } else {
        break;
      }
    }
    list.removeRange(0, index);

    return Uint8List.fromList(list);
  }

  static String convertParameterToString({required Uint8List list}) {
    String value = "";
    for (var item in list) {
      value += DatecsAdapter.convertHexToString(item: item);
    }
    return value;
  }

  static bool checkIfExistParameter({required Uint8List answer}) {
    var list = answer.toList();
    if (list.isNotEmpty && list[0] == separator) {
      list.removeAt(0);
    } else {
      return false;
    }
    if (list.isEmpty) {
      return false;
    }
    return true;
  }

  static bool noErrorCode({required String errorCode}) {
    if (errorCode == DatecsErrorCodes.noError.value) {
      return true;
    }
    return false;
  }

  static String getErrorCodeInformation({required String errorCode}) {
    switch (errorCode) {
      case "-111000":
        return "Common error followed by deleting all data for the command";
      case "-111001":
        return "Common error followed by partly deleting data for the command";
      case "-111002":
        return "Check the parameters of the command";
      case "-111003":
        return "Cannot do operation";
      case "-111005":
        return "Forbidden VAT";
      case "-111006":
        return "Overflow in multiplication of quantity and price";
      case "-111009":
        return "Department is not in range";
      case "-111015":
        return "Receipt is opened";
      case "-111016":
        return "Receipt is closed";
      case "-111017":
        return "No cash in ECR";
      case "-111018":
        return "Payment is initiated";
      case "-111019":
        return "Maximum number of sales in receipt";
      case "-111020":
        return "No transactions";
      case "-111021":
        return "Possible negative turnover";
      case "-111023":
        return "Transaction is not found in the receipt";
      case "-111024":
        return "End of 24 hour blocking. Print report Z";
      case "-111025":
        return "Invalid invoice range";
      case "-111031":
        return "Value is too big";
      case "-111032":
        return " Value is bad";
      case "-111033":
        return "Price is too big";
      case "-111034":
        return "Price is bad";
      case "-111046":
        return "Non-fiscal receipt is opened";
      case "-111047":
        return "Fiscal receipt is opened";
      case "-111050":
        return "Payment is not initiated";
      case "-111051":
        return "Receipt type mismatch";
      case "-111052":
        return "Receipt total limit is reached";
      case "-111054":
        return "Sum must be <= payment amount";
      case "-111060":
        return "Drawer opening is disabled";
      case "-111061":
        return "Forbidden payment";
      case "-111062":
        return "Forbidden key for surcharge/discount";
      case "-111063":
        return "Entered sum is bigger than receipt sum";
      case "-111064":
        return "Entered sum is smaller than receipt sum";
      case "-111065":
        return "Sum of receipt is 0. Operation 'void' is needed";
      case "-111066":
        return "Operation 'void' is executed. Close receipt is needed";
      case "-111067":
        return "Storno receipt is opened";
      case "-111068":
        return "Sum is not entered";
      case "-111071":
        return "Negative price is forbidden";
      case "-110104":
        return "Device is not fiscalized";
      case "-112006":
        return "No paper";
      case "-112007":
        return "Cover is open";
      case "-112101":
        return "Syntax error at first parameter. Check payments methods codes.";
      case "-102005":
        return "Display is not connected";
      default:
        return "Error with code: $errorCode";
    }
  }

  Uint8List getAnswer() => _data;
  int? getSeqNo() => _seq;
  Uint8List getCommand() => _cmd;
  bool isOk() => _isOk;
  bool checkWaitToGetResponse() => _waitToGetResponse;
}
