import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';

import '../../../fiscal_printer_response.dart';
import 'datecs_answer.dart';
import 'datecs_command_type.dart';
import 'datecs_commans.dart';
import 'datecs_error_codes.dart';
import 'datecs_message.dart';
import 'datecs_response_adapter.dart';

class DatecsTcpClientAdapter {
  String? _ip;
  int? _port;
  Socket? _socket;
  List<DatecsMessage> _listOfCommands = [];
  StreamController<DatecsResponseAdapter?>? _responseController;
  int? _currentSeqNumber;
  bool _errorWasEmmit = false;

  Stream<DatecsResponseAdapter?>? get response => _responseController!.stream;

  Stream<FiscalPrinterResponse> get printerResponse =>
      _responseController!.stream.transform(StreamTransformer<
          DatecsResponseAdapter?,
          FiscalPrinterResponse>.fromHandlers(handleData: (response, sink) {
        var fiscalPrinterStatus = _getStatusFromResponse(response);
        if (fiscalPrinterStatus.status != PrinterStatus.failure) {
          // print(fiscalPrinterStatus.status);
          // print(fiscalPrinterStatus.errorMessage ?? "");
          if (!_errorWasEmmit) {
            _errorWasEmmit = true;
            sink.add(fiscalPrinterStatus);
          }
        }
      }));

  DatecsTcpClientAdapter({required String ip, required int port}) {
    _ip = ip;
    _port = port;
    _errorWasEmmit = false;
    _responseController = PublishSubject<DatecsResponseAdapter?>();
  }

  _openConnection() async {
    if (_ip != null && _port != null) {
      try {
        _socket = await Socket.connect(_ip!, _port!,
            timeout: const Duration(seconds: 1));

        _socket!.listen((data) {
          // if(data == null) return;
          var response = DatecsResponseAdapter(
              response: data, sequenceNumber: _currentSeqNumber!);
          if (!response.checkWaitToGetResponse()) {
            _responseController!.sink.add(response);
            var fiscalPrinterStatus = _getStatusFromResponse(response);
            if (fiscalPrinterStatus.status == PrinterStatus.printerError) {
              _listOfCommands.clear();
              _closeConnection();
            }
            if (_listOfCommands.isNotEmpty) {
              _listOfCommands.removeAt(0);
              sendData(commands: _listOfCommands);
            }
          }
        });
        sendData(commands: _listOfCommands);
      } on SocketException catch (_) {
        // print(e);
        _responseController!.sink.add(null);
        _socket?.close();
      }
    }
  }

  FiscalPrinterResponse _getStatusFromResponse(
      DatecsResponseAdapter? response) {
    FiscalPrinterResponse printerResponse = FiscalPrinterResponse();
    String errorCode = DatecsErrorCodes.noError.value;
    if (response != null) {
      //print("getStatus method: ${response.getAnswer()} | ${response.getCommand()} | ${response.getSeqNo()}");
      // print(response.getCommand());
      // print(response.getAnswer());
      // print(response.getSeqNo());
      var commandType = DatecsCommands.getCommandType(response.getCommand());
      //print(commandType);
      switch (commandType) {
        case DatecsCommandType.freeTextLine:
          var answer = DatecsAnswerFreeTextLine(answer: response.getAnswer());
          if (!DatecsResponseAdapter.noErrorCode(errorCode: answer.errorCode)) {
            errorCode = answer.errorCode;
          }
          break;
        case DatecsCommandType.separatorLine:
          var answer = DatecsAnswerSeparatorLine(answer: response.getAnswer());
          if (!DatecsResponseAdapter.noErrorCode(errorCode: answer.errorCode)) {
            errorCode = answer.errorCode;
          }
          break;
        case DatecsCommandType.openFiscalReceipt:
          var answer =
              DatecsAnswerOpenFiscalReceipt(answer: response.getAnswer());
          //print(answer.errorCode);
          if (!DatecsResponseAdapter.noErrorCode(errorCode: answer.errorCode)) {
            errorCode = answer.errorCode;
          }
          break;
        case DatecsCommandType.openNonFiscalReceipt:
          var answer =
              DatecsAnswerOpenNonFiscalReceipt(answer: response.getAnswer());
          //print(answer.errorCode);
          if (!DatecsResponseAdapter.noErrorCode(errorCode: answer.errorCode)) {
            errorCode = answer.errorCode;
          }
          break;
        case DatecsCommandType.addItemOnFiscalReceipt:
          var answer =
              DatecsAnswerAddItemOnFiscalReceipt(answer: response.getAnswer());
          if (!DatecsResponseAdapter.noErrorCode(errorCode: answer.errorCode)) {
            errorCode = answer.errorCode;
          }
          break;
        case DatecsCommandType.addItemOnNonFiscalReceipt:
          var answer = DatecsAnswerAddItemOnNonFiscalReceipt(
              answer: response.getAnswer());
          if (!DatecsResponseAdapter.noErrorCode(errorCode: answer.errorCode)) {
            errorCode = answer.errorCode;
          }
          break;
        case DatecsCommandType.addPayment:
          var answer = DatecsAnswerAddPayment(answer: response.getAnswer());
          if (!DatecsResponseAdapter.noErrorCode(errorCode: answer.errorCode)) {
            errorCode = answer.errorCode;
          }
          break;
        case DatecsCommandType.closeFiscalReceipt:
          var answer = DatecsAnswerCloseReceipt(answer: response.getAnswer());
          if (!DatecsResponseAdapter.noErrorCode(errorCode: answer.errorCode)) {
            errorCode = answer.errorCode;
          } else {
            printerResponse.setStatus(PrinterStatus.ok);
            printerResponse.setFiscalTicketsNumber(
                answer.numberOfFiscalReceipt.toString());
          }
          break;
        case DatecsCommandType.closeNonFiscalReceipt:
          var answer =
              DatecsAnswerCloseNonFiscalReceipt(answer: response.getAnswer());
          if (!DatecsResponseAdapter.noErrorCode(errorCode: answer.errorCode)) {
            errorCode = answer.errorCode;
          } else {
            printerResponse.setStatus(PrinterStatus.ok);
          }
          break;
        case DatecsCommandType.getStatus:
          var answer = DatecsAnswerReadStatus(answer: response.getAnswer());
          // print(commandType);
          // print(answer.errorCode);
          if (!DatecsResponseAdapter.noErrorCode(errorCode: answer.errorCode)) {
            errorCode = answer.errorCode;
          }
          break;
        case DatecsCommandType.receiptInfo:
          var answer = DatecsAnswerReceiptInfo(answer: response.getAnswer());
          // print(commandType);
          // print(answer.errorCode);
          if (!DatecsResponseAdapter.noErrorCode(errorCode: answer.errorCode)) {
            errorCode = answer.errorCode;
          }
          break;
        default:
          errorCode = DatecsErrorCodes.noError.value;
      }
      if (!DatecsResponseAdapter.noErrorCode(errorCode: errorCode)) {
        printerResponse.setStatus(PrinterStatus.printerError);
        printerResponse.setErrorMessage(
            message:
                "${DatecsResponseAdapter.getErrorCodeInformation(errorCode: errorCode)} ($errorCode)");
      }
    } else {
      // print("getStatus method: NULL");
      printerResponse.setStatus(PrinterStatus.error404);
    }
    return printerResponse;
  }

  _closeConnection() {
    // print("close connection");
    _responseController?.close();
    _socket?.destroy();
    _socket = null;
  }

  sendData({required List<DatecsMessage> commands}) async {
    if (_errorWasEmmit) return;
    if (_socket != null) {
      if (_listOfCommands.isNotEmpty) {
        _currentSeqNumber = _listOfCommands[0].seqNo;
        _socket!.add(_listOfCommands[0].getMessage());
      } else {
        _closeConnection();
      }
    } else {
      // print("try open connection");
      _listOfCommands = commands;
      await _openConnection();
    }
  }
}
