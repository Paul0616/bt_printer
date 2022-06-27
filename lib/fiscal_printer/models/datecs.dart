import 'dart:async';
import 'dart:io';

import 'package:bt_printer/fiscal_printer/models/utils/datecs_utils/datecs_answer.dart';
import 'package:bt_printer/fiscal_printer/models/utils/datecs_utils/datecs_blutooth_client_adapter.dart';
import 'package:bt_printer/fiscal_printer/models/utils/datecs_utils/datecs_commans.dart';
import 'package:bt_printer/fiscal_printer/models/utils/datecs_utils/datecs_message.dart';
import 'package:bt_printer/fiscal_printer/models/utils/datecs_utils/datecs_report_type.dart';
import 'package:bt_printer/fiscal_printer/models/utils/datecs_utils/datecs_response_adapter.dart';
import 'package:bt_printer/fiscal_printer/models/utils/datecs_utils/datecs_tcp_client_adapter.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../../utils/globals.dart';
import '../fiscal_printer_response.dart';

class Datecs {
  final StreamController<FiscalPrinterResponse> _fiscalPrinterTestController;
  String? _ip;
  int? _port;
  BluetoothDevice? device;
  String? _username;
  String? _password;
  String? _timeoutWaitingResponse;
  int _noOfCharactersPerLine = 42;

  //String _url;
  //String? _authorization;
  final int _timeout = 5;
  //String _defaultPayMethodCode = "0"; //cash
  //String _depositTaxVatCode = "2";
  //int _noOfIterations = 2;

  Datecs(this._fiscalPrinterTestController) {
    var globals = Globals();
    if (globals.datecsLastSequenceNumber == 1) {
      globals.datecsLastSequenceNumber = 2;
    } else {
      globals.datecsLastSequenceNumber = 1;
    }
  }

  /*---------------------------------------
        PUBLIC METHODS
  ----------------------------------------*/
  // static Future<bool> testConnectionFromIp(String? ip,
  //     {int port = 3999}) async {
  //   if (ip == null) return false;
  //   Socket? _socket;
  //   bool? _testResult;
  //   var datecsMessage = DatecsMessage(command: DatecsCommands.readStatus());
  //   await Socket.connect(ip, port, timeout: const Duration(seconds: 1))
  //       .then((socket) {
  //     _socket = socket;
  //   }).then((_) {
  //     _socket!.add(datecsMessage.getMessage());
  //
  //     return _socket!
  //         .firstWhere((data) => !DatecsResponseAdapter(
  //         response: data, sequenceNumber: datecsMessage.seqNo)
  //         .checkWaitToGetResponse())
  //         .timeout(const Duration(seconds: 2));
  //   }).then((data) {
  //     print(data);
  //     var response = DatecsResponseAdapter(
  //         response: data, sequenceNumber: datecsMessage.seqNo);
  //     if (response.checkWaitToGetResponse() || !response.isOk()) {
  //       _testResult = false;
  //     } else {
  //       _testResult = true;
  //     }
  //     _socket?.close();
  //   }).catchError((e) {
  //     print(e);
  //     _testResult = false;
  //     _socket?.close();
  //   });
  //   return _testResult!;
  // }

  // checkPrinterStatus() async {
  //   _ip = await SettingsManager.getFiscalPrinterHost();
  //   _port = int.tryParse(await SettingsManager.getFiscalPrinterPortAddress()) ??
  //       3999;
  //   _checkConnection();
  // }

  // _checkConnection() async {
  //   var errorCode = "";
  //   // while (index < _noOfIterations) {
  //   Socket? socket;
  //   try {
  //     socket = await Socket.connect(_ip!, _port!,
  //         timeout: Duration(seconds: _timeout));
  //     print('Connected to: '
  //         '${socket.remoteAddress.address}:${socket.remotePort}');
  //     var datecsMessage = DatecsMessage(command: DatecsCommands.readStatus());
  //
  //     socket.listen((data) {
  //       //print(data);
  //       var response = DatecsResponseAdapter(
  //           response: data, sequenceNumber: datecsMessage.seqNo);
  //       // print("lastSeqNumber:${Globals().datecsLastSequenceNumber}");
  //       // print("Command from response: ${response.getCommand()}");
  //       // print("Answer from response: ${response.getCommand()}");
  //       // print("Wait from response: ${response.checkWaitToGetResponse()}");
  //       // print("isOK: ${response.isOk()}");
  //       var info = DatecsAnswerReadStatus(answer: response.getAnswer());
  //       errorCode = info.errorCode;
  //       if (!response.checkWaitToGetResponse() || !response.isOk()) {
  //         socket?.close();
  //         if (DatecsResponseAdapter.noErrorCode(errorCode: errorCode)) {
  //           _fiscalPrinterTestController.add(FiscalPrinterResponse(
  //               status: PrinterStatus.ok,
  //               action: FiscalPrinterAction.testConnection));
  //         } else {
  //           _fiscalPrinterTestController.add(FiscalPrinterResponse(
  //               status: PrinterStatus.printerError,
  //               message: DatecsResponseAdapter.getErrorCodeInformation(
  //                   errorCode: errorCode),
  //               action: FiscalPrinterAction.testConnection));
  //         }
  //       }
  //     });
  //     socket.add(datecsMessage.getMessage());
  //   } on SocketException catch (e) {
  //     print(e);
  //     socket?.close();
  //     _fiscalPrinterTestController.add(FiscalPrinterResponse(
  //         status: PrinterStatus.failure,
  //         action: FiscalPrinterAction.testConnection));
  //   }
  //   // }
  // }

  clearDisplay() {
    var printerResponse = FiscalPrinterResponse();
    printerResponse.setStatus(PrinterStatus.ok);
    printerResponse.setAction(FiscalPrinterAction.clearDisplay);
    _fiscalPrinterTestController.add(printerResponse);
  }

  // openDrawer() async {
  //   _ip = await SettingsManager.getFiscalPrinterHost();
  //   _port = int.tryParse(await SettingsManager.getFiscalPrinterPortAddress()) ??
  //       3999;
  //   _noOfCharactersPerLine =
  //   await SettingsManager.getFiscalPrinterNoOfCharactersPerLine();
  //   _timeoutWaitingResponse = await SettingsManager.getFiscalPrinterTimeout();
  //   var printerResponse = FiscalPrinterResponse();
  //   printerResponse.setAction(FiscalPrinterAction.openDrawer);
  //   var response = await _sendCommand(
  //     message: DatecsMessage(
  //       command: DatecsCommands.openDrawer(),
  //     ),
  //   );
  //   if (response != null) {
  //     var info = DatecsAnswerOpenDrawer(answer: response.getAnswer());
  //     if (DatecsResponseAdapter.noErrorCode(errorCode: info.errorCode)) {
  //       printerResponse.setStatus(PrinterStatus.ok);
  //     } else {
  //       printerResponse.setStatus(PrinterStatus.printerError);
  //       printerResponse.setErrorMessage(
  //           message: DatecsResponseAdapter.getErrorCodeInformation(
  //               errorCode: info.errorCode));
  //     }
  //   } else {
  //     printerResponse.setStatus(PrinterStatus.error404);
  //   }
  //   _fiscalPrinterTestController.sink.add(printerResponse);
  // }

  printReportZ({bool isBluetooth = false}) async {
    // _ip = await SettingsManager.getFiscalPrinterHost();
    // _port = int.tryParse(await SettingsManager.getFiscalPrinterPortAddress()) ??
    //     3999;
    // _noOfCharactersPerLine =
    //     await SettingsManager.getFiscalPrinterNoOfCharactersPerLine();
    // _timeoutWaitingResponse = await SettingsManager.getFiscalPrinterTimeout();
    if(isBluetooth) {
      var printerResponse = FiscalPrinterResponse();
      printerResponse.setAction(FiscalPrinterAction.printReportZ);
      //var d = BluetoothDevice(address: address)
      var response = await _sendCommandBT(
        message: DatecsMessage(
          command: DatecsCommands.report(DatecsReportType.reportZ),
        ),
      );
      if (response != null) {
        var info = DatecsAnswerReport(answer: response.getAnswer());
        if (DatecsResponseAdapter.noErrorCode(errorCode: info.errorCode)) {
          printerResponse.setStatus(PrinterStatus.ok);
          printerResponse.setZReportNumber(info.numberOfZReport.toString());
        } else {
          printerResponse.setStatus(PrinterStatus.printerError);
          printerResponse.setErrorMessage(
              message: DatecsResponseAdapter.getErrorCodeInformation(
                  errorCode: info.errorCode));
        }
      } else {
        printerResponse.setStatus(PrinterStatus.error404);
      }
      _fiscalPrinterTestController.sink.add(printerResponse);
    }
  }

  // printReportZCopy(String zReportNo) async {
  //   _ip = await SettingsManager.getFiscalPrinterHost();
  //   _port = int.tryParse(await SettingsManager.getFiscalPrinterPortAddress()) ??
  //       3999;
  //   _noOfCharactersPerLine =
  //   await SettingsManager.getFiscalPrinterNoOfCharactersPerLine();
  //   _timeoutWaitingResponse = await SettingsManager.getFiscalPrinterTimeout();
  //   var printerResponse = FiscalPrinterResponse();
  //   printerResponse.setAction(FiscalPrinterAction.printReportZCopy);
  //   var response = await _sendCommand(
  //     message: DatecsMessage(
  //       command: DatecsCommands.reportZCopy(number: zReportNo, detailed: true),
  //     ),
  //   );
  //   if (response != null) {
  //     var info = DatecsAnswerReportZCopy(answer: response.getAnswer());
  //     if (DatecsResponseAdapter.noErrorCode(errorCode: info.errorCode)) {
  //       printerResponse.setStatus(PrinterStatus.ok);
  //     } else {
  //       printerResponse.setStatus(PrinterStatus.printerError);
  //       printerResponse.setErrorMessage(
  //           message: DatecsResponseAdapter.getErrorCodeInformation(
  //               errorCode: info.errorCode));
  //     }
  //   } else {
  //     printerResponse.setStatus(PrinterStatus.error404);
  //   }
  //   _fiscalPrinterTestController.sink.add(printerResponse);
  // }
  //
  printReportX(BluetoothDevice? btDevice) async {
    // _ip = await SettingsManager.getFiscalPrinterHost();
    // _port = int.tryParse(await SettingsManager.getFiscalPrinterPortAddress()) ??
    //     3999;
    // _noOfCharactersPerLine =
    // await SettingsManager.getFiscalPrinterNoOfCharactersPerLine();
    // _timeoutWaitingResponse = await SettingsManager.getFiscalPrinterTimeout();
    device = btDevice;
    if(btDevice != null) {
      var printerResponse = FiscalPrinterResponse();
      printerResponse.setAction(FiscalPrinterAction.printReportX);
      var response = await _sendCommandBT(
        message: DatecsMessage(
          command: DatecsCommands.report(DatecsReportType.reportX),
        ),
      );
      if (response != null) {
        var info = DatecsAnswerReport(answer: response.getAnswer());
        if (DatecsResponseAdapter.noErrorCode(errorCode: info.errorCode)) {
          printerResponse.setStatus(PrinterStatus.ok);
        } else {
          printerResponse.setStatus(PrinterStatus.printerError);
          printerResponse.setErrorMessage(
              message: DatecsResponseAdapter.getErrorCodeInformation(
                  errorCode: info.errorCode));
        }
      } else {
        printerResponse.setStatus(PrinterStatus.error404);
      }
      print("Status: ${printerResponse.status}");
      print("Action: ${printerResponse.action}");
      print("Error message: ${printerResponse.errorMessage}");
      print("Number of fiscal tickets: ${printerResponse.numberOfFiscalTickets}");
      print("Number of Z report: ${printerResponse.numberOfZReport}");
      print("Cash in drawer: ${printerResponse.getCashInDrawer()}");
      print("Daily sum: ${printerResponse.getDailySum()}");
      _fiscalPrinterTestController.sink.add(printerResponse);
    }
  }

  // printReportZInInterval(DateTime startDate, DateTime stopDate) async {
  //   _ip = await SettingsManager.getFiscalPrinterHost();
  //   _port = int.tryParse(await SettingsManager.getFiscalPrinterPortAddress()) ??
  //       3999;
  //   _noOfCharactersPerLine =
  //   await SettingsManager.getFiscalPrinterNoOfCharactersPerLine();
  //   _timeoutWaitingResponse = await SettingsManager.getFiscalPrinterTimeout();
  //   var printerResponse = FiscalPrinterResponse();
  //   printerResponse.setAction(FiscalPrinterAction.printReportZInterval);
  //   var response = await _sendCommand(
  //     message: DatecsMessage(
  //       command: DatecsCommands.reportZInInterval(
  //           startDate: startDate, stopDate: stopDate, detailed: true),
  //     ),
  //   );
  //   if (response != null) {
  //     var info = DatecsAnswerReportZInInterval(answer: response.getAnswer());
  //     if (DatecsResponseAdapter.noErrorCode(errorCode: info.errorCode)) {
  //       printerResponse.setStatus(PrinterStatus.ok);
  //     } else {
  //       printerResponse.setStatus(PrinterStatus.printerError);
  //       printerResponse.setErrorMessage(
  //           message: DatecsResponseAdapter.getErrorCodeInformation(
  //               errorCode: info.errorCode));
  //     }
  //   } else {
  //     printerResponse.setStatus(PrinterStatus.error404);
  //   }
  //   _fiscalPrinterTestController.sink.add(printerResponse);
  // }
  //
  dailySum(BluetoothDevice? btDevice) async {
    device = btDevice;
    _username = "1";
    if(btDevice == null) {
      // _ip = await SettingsManager.getFiscalPrinterHost();
      // _port =
      //     int.tryParse(await SettingsManager.getFiscalPrinterPortAddress()) ??
      //         3999;
      // _noOfCharactersPerLine =
      // await SettingsManager.getFiscalPrinterNoOfCharactersPerLine();
      // _username = await SettingsManager.getFiscalPrinterUserName();
      // _timeoutWaitingResponse = await SettingsManager.getFiscalPrinterTimeout();
    } else {
      var printerResponse = FiscalPrinterResponse();
      printerResponse.setAction(FiscalPrinterAction.dailySum);
      var response = await _sendCommandBT(
        message: DatecsMessage(
          command: DatecsCommands.dailySum(operatorCode: _username!),
        ),
      );
      if (response != null) {
        var info = DatecsAnswerDailySum(answer: response.getAnswer());
        if (DatecsResponseAdapter.noErrorCode(errorCode: info.errorCode)) {
          printerResponse.setStatus(PrinterStatus.ok);
          printerResponse.setDailySum(info.amount);
        } else {
          printerResponse.setStatus(PrinterStatus.printerError);
          printerResponse.setErrorMessage(
              message: DatecsResponseAdapter.getErrorCodeInformation(
                  errorCode: info.errorCode));
        }
      } else {
        printerResponse.setStatus(PrinterStatus.error404);
      }
      print("Status: ${printerResponse.status}");
      print("Action: ${printerResponse.action}");
      print("Error message: ${printerResponse.errorMessage}");
      print("Number of fiscal tickets: ${printerResponse.numberOfFiscalTickets}");
      print("Number of Z report: ${printerResponse.numberOfZReport}");
      print("Cash in drawer: ${printerResponse.getCashInDrawer()}");
      print("Daily sum: ${printerResponse.getDailySum()}");
      _fiscalPrinterTestController.sink.add(printerResponse);
    }
  }

  // printAdvanceFiscalBill({required ClientOrder clientOrder}) async {
  //   _ip = await SettingsManager.getFiscalPrinterHost();
  //   _port = int.tryParse(await SettingsManager.getFiscalPrinterPortAddress()) ??
  //       3999;
  //   _noOfCharactersPerLine =
  //   await SettingsManager.getFiscalPrinterNoOfCharactersPerLine();
  //   _timeoutWaitingResponse = await SettingsManager.getFiscalPrinterTimeout();
  //   var printerResponse = FiscalPrinterResponse();
  //   printerResponse.setAction(FiscalPrinterAction.printFiscalBill);
  //   printerResponse.setStatus(PrinterStatus.ok);
  //   if (clientOrder.items != null &&
  //       clientOrder.items!.isNotEmpty &&
  //       (clientOrder.clientUid ?? "").isNotEmpty &&
  //       (clientOrder.payments ?? []).isNotEmpty &&
  //       (clientOrder.locationUid ?? "").isNotEmpty) {
  //     _username = await SettingsManager.getFiscalPrinterUserName();
  //     _password = await SettingsManager.getFiscalPrinterPassword();
  //     await _cancelIfFiscalReceiptIsOpen();
  //     List<DatecsMessage> listOfCommands = [];
  //     var clientUniqueCode = "";
  //     var clientMap = await DBProvider.db.getObjectById(
  //         uid: clientOrder.clientUid!, tableName: TableCreate.tableClient);
  //     if (clientMap != null) {
  //       var client = Client.fromDatabase(clientMap);
  //       if (client.isJuridicPerson && client.uniqueCode != null) {
  //         clientUniqueCode = client.uniqueCode!;
  //       }
  //     }
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.openFiscalReceipt(
  //             operatorCode: _username!,
  //             password: _password!,
  //             clientUniqueCode: clientUniqueCode),
  //       ),
  //     );
  //     var advancesSplitted = await clientOrder.advanceSplitted;
  //     // var vatCodeDeposit =
  //     //     await SettingsManager.getFiscalPrinterDepositVatUid();
  //     // var vatCode = await SettingsManager.getVatCode(vatUid: vatCodeDeposit);
  //     for(var advance in advancesSplitted) {
  //       var vatCode = await SettingsManager.getVatCode(vatUid: advance.vatUid);
  //       if (vatCode.isEmpty) {
  //         printerResponse.setStatus(PrinterStatus.vatCodeError);
  //         _fiscalPrinterTestController.sink.add(printerResponse);
  //         return;
  //       }
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command: DatecsCommands.addItemOnFiscalReceipt(
  //               productName: "Avans comanda #${clientOrder.shortCode} TVA${(advance.vat ?? 0) * 100}%",
  //               vatCode: vatCode,
  //               unitPrice: advance.value ?? 0,
  //               units: 1,
  //               discountValue: 0,
  //               departmentCode: "0",
  //               unitMeasureName: "BUC"),
  //         ),
  //       );
  //     }
  //
  //     ///separator line
  //     listOfCommands.add(DatecsMessage(
  //         command:
  //         DatecsCommands.separatorLine(DatecsSeparatorLineType.double)));
  //
  //     /// username
  //     var username = "Operator: ${SessionManager.currentUser?.fullName ?? ""}";
  //     if (username.length > _noOfCharactersPerLine) {
  //       username = username.substring(0, _noOfCharactersPerLine - 1);
  //     }
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.addFreeTextLine(
  //           line: username,
  //           align: DatecsTextAlign.center,
  //           bold: false,
  //           italic: false,
  //           doubleHeight: false,
  //           underline: false,
  //         ),
  //       ),
  //     );
  //
  //     ///location
  //     var locationName = "";
  //     var locationMap = await DBProvider.db.getObjectById(
  //         uid: clientOrder.locationUid!, tableName: TableCreate.tableLocation);
  //     if (locationMap != null) {
  //       var location = Location.fromMap(locationMap);
  //       if (location.name != null) {
  //         locationName = location.name!;
  //       }
  //     }
  //     var location = "Locatia: $locationName";
  //     if (location.length > _noOfCharactersPerLine) {
  //       location = location.substring(0, _noOfCharactersPerLine - 1);
  //     }
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.addFreeTextLine(
  //           line: location,
  //           align: DatecsTextAlign.center,
  //           bold: false,
  //           italic: false,
  //           doubleHeight: false,
  //           underline: false,
  //         ),
  //       ),
  //     );
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.addFreeTextLine(
  //           line: "Powered by freyapos.com",
  //           align: DatecsTextAlign.center,
  //           bold: true,
  //           italic: false,
  //           doubleHeight: false,
  //           underline: false,
  //         ),
  //       ),
  //     );
  //
  //     ///separator line
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.separatorLine(
  //           DatecsSeparatorLineType.double,
  //         ),
  //       ),
  //     );
  //
  //     if (clientOrder.payments != null) {
  //       print("paid amount ${clientOrder.paidAmount}");
  //       if (clientOrder.paidAmount > 0) {
  //         var cashPayMethodsMap = await DBProvider.db.getRecords(
  //             tableName: TableCreate.tablePaymentMethod,
  //             where: "behaviour = ? OR behaviour = ?",
  //             whereArgs: [PaymentMethodBehaviour.cash.rawValue, PaymentMethodBehaviour.prepaid.rawValue]);
  //         var cashPayMethods = cashPayMethodsMap
  //             .map((e) => PaymentMethod.fromDatabase(e))
  //             .toList();
  //
  //         var noCashPayMethodsMap = await DBProvider.db.getRecords(
  //             tableName: TableCreate.tablePaymentMethod,
  //             where: "behaviour = ? OR behaviour = ? OR behaviour = ?",
  //             whereArgs: [
  //               PaymentMethodBehaviour.tickets.rawValue,
  //               PaymentMethodBehaviour.card.rawValue,
  //               PaymentMethodBehaviour.op.rawValue
  //             ]);
  //         var noCashPayMethods = noCashPayMethodsMap
  //             .map((e) => PaymentMethod.fromDatabase(e))
  //             .toList();
  //
  //         for (var payMethod in noCashPayMethods) {
  //           Helper.prettyPrintJson(payMethod.toDatabaseMap());
  //           var payMethodValue = clientOrder.payments!.fold<double>(
  //             0.0,
  //                 (prev, element) =>
  //             prev +
  //                 ((element.paymentMethod?.behavior ??
  //                     PaymentMethodBehaviour.undefined.rawValue) ==
  //                     payMethod.behavior
  //                     ? ((element.quantity ?? 0) *
  //                     (element.unitValueWithVat ?? 0))
  //                     .toDouble()
  //                     : 0.0),
  //           );
  //           if (clientOrder.payments!
  //               .where((element) => element.paymentUid == payMethod.uid)
  //               .isEmpty) {
  //             payMethodValue = 0;
  //           }
  //           if (payMethodValue != 0) {
  //             var payMethodCode = await SettingsManager.getPayMethodCode(
  //                 payMethodUid: payMethod.uid ?? "");
  //             if (payMethodCode.isEmpty) {
  //               printerResponse.setStatus(PrinterStatus.payMethodCodeCodeError);
  //               _fiscalPrinterTestController.sink.add(printerResponse);
  //               return;
  //             }
  //             listOfCommands.add(
  //               DatecsMessage(
  //                 command: DatecsCommands.addPayment(
  //                   payMethod: payMethodCode,
  //                   amount: payMethodValue,
  //                 ),
  //               ),
  //             );
  //           }
  //         }
  //
  //         for (var payMethod in cashPayMethods) {
  //           Helper.prettyPrintJson(payMethod.toDatabaseMap());
  //           var payMethodValue = clientOrder.payments!.fold<double>(
  //             0.0,
  //                 (prev, element) =>
  //             prev +
  //                 ((element.paymentMethod?.behavior ??
  //                     PaymentMethodBehaviour.undefined.rawValue) ==
  //                     payMethod.behavior
  //                     ? ((element.quantity ?? 0) *
  //                     (element.unitValueWithVat ?? 0))
  //                     .toDouble()
  //                     : 0.0),
  //           );
  //           if (clientOrder.payments!
  //               .where((element) => element.paymentUid == payMethod.uid)
  //               .isEmpty) {
  //             payMethodValue = 0;
  //           }
  //           if (payMethodValue != 0) {
  //             String payMethodUid = cashPayMethods.where((method) => method.behavior == PaymentMethodBehaviour.cash.rawValue).first.uid ?? "";
  //             var payMethodCode = await SettingsManager.getPayMethodCode(
  //                 payMethodUid: payMethodUid);
  //             if (payMethodCode.isEmpty) {
  //               printerResponse.setStatus(PrinterStatus.payMethodCodeCodeError);
  //               _fiscalPrinterTestController.sink.add(printerResponse);
  //               return;
  //             }
  //             listOfCommands.add(
  //               DatecsMessage(
  //                 command: DatecsCommands.addPayment(
  //                   payMethod: payMethodCode,
  //                   amount: payMethodValue,
  //                 ),
  //               ),
  //             );
  //           }
  //         }
  //       } else if (clientOrder.paidAmount == 0) {
  //         for (var payment in clientOrder.payments!) {
  //           var payMethodCode = await SettingsManager.getPayMethodCode(
  //               payMethodUid: payment.paymentUid ?? "");
  //           if (payMethodCode.isEmpty) {
  //             printerResponse.setStatus(PrinterStatus.payMethodCodeCodeError);
  //             _fiscalPrinterTestController.sink.add(printerResponse);
  //             return;
  //           }
  //           listOfCommands.add(
  //             DatecsMessage(
  //               command: DatecsCommands.addPayment(
  //                 payMethod: payMethodCode,
  //                 amount: 0,
  //               ),
  //             ),
  //           );
  //           break;
  //         }
  //       }
  //     }
  //     listOfCommands
  //         .add(DatecsMessage(command: DatecsCommands.closeFiscalReceipt()));
  //     if (await testConnectionFromIp(_ip)) {
  //       await _executeCommands(
  //           commands: listOfCommands,
  //           action: FiscalPrinterAction.printFiscalBill);
  //     } else {
  //       _fiscalPrinterTestController.sink.add(FiscalPrinterResponse(
  //           status: PrinterStatus.failure,
  //           action: FiscalPrinterAction.printFiscalBill));
  //     }
  //   }
  // }

  // printFiscalBill({required Sale sale, required double change}) async {
  //   _ip = await SettingsManager.getFiscalPrinterHost();
  //   _port = int.tryParse(await SettingsManager.getFiscalPrinterPortAddress()) ??
  //       3999;
  //   _noOfCharactersPerLine =
  //   await SettingsManager.getFiscalPrinterNoOfCharactersPerLine();
  //   _timeoutWaitingResponse = await SettingsManager.getFiscalPrinterTimeout();
  //   var printerResponse = FiscalPrinterResponse();
  //   printerResponse.setAction(FiscalPrinterAction.printFiscalBill);
  //   printerResponse.setStatus(PrinterStatus.ok);
  //   if (sale.items != null && sale.items!.isNotEmpty) {
  //     _username = await SettingsManager.getFiscalPrinterUserName();
  //     _password = await SettingsManager.getFiscalPrinterPassword();
  //     await _cancelIfFiscalReceiptIsOpen();
  //     List<DatecsMessage> listOfCommands = [];
  //
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.openFiscalReceipt(
  //             operatorCode: _username!,
  //             password: _password!,
  //             clientUniqueCode: sale.clientUniqueCode),
  //       ),
  //     );
  //
  //     //advance will be distributed as discount to
  //     var advance = sale.depositValue ?? 0;
  //     if(advance > 0) {
  //       sale.items!.sort((a, b) => (a.vatRate ?? 0).compareTo(b.vatRate ?? 0));
  //     }
  //     for (var item in sale.items!) {
  //       if (item.isVoid || item.unitPriceWithVat == 0) {
  //         continue;
  //       }
  //       var vatCode = await SettingsManager.getVatCode(vatUid: item.vatUid);
  //       if (vatCode.isEmpty) {
  //         printerResponse.setStatus(PrinterStatus.vatCodeError);
  //         _fiscalPrinterTestController.sink.add(printerResponse);
  //         return;
  //       }
  //
  //       var realQuantity = (item.quantity ?? 0) * (item.units ?? 0);
  //       var distributedDiscount = (item.discountValue ?? 0);
  //       var rest = ((item.unitPriceWithVat ?? 0) * realQuantity) - (item.discountValue ?? 0);
  //       if(advance > 0) {
  //         if (advance >= rest) {
  //           distributedDiscount += rest;
  //           advance -= rest;
  //         } else {
  //           distributedDiscount += advance;
  //           advance = 0;
  //         }
  //       }
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command: DatecsCommands.addItemOnFiscalReceipt(
  //               productName: item.product?.name ?? "",
  //               vatCode: vatCode,
  //               unitPrice: (item.unitPriceWithVat ?? 0),
  //               units: realQuantity,
  //               discountValue: distributedDiscount, //(item.discountValue ?? 0),
  //               departmentCode: "0",
  //               unitMeasureName: item.product?.measureUnitName ?? ""),
  //         ),
  //       );
  //       print(
  //           "Item: ${item.product?.name ?? ""} $realQuantity x ${item.unitPriceWithVat ?? 0}");
  //       if ((item.discountValue ?? 0) > 0) {
  //         print("REDUCERE: ${(item.discountValue ?? 0)}");
  //       }
  //     }
  //
  //     if ((sale.deliveryTax ?? 0) > 0) {
  //       var vatCodeDeliveryTax =
  //       await SettingsManager.getFiscalPrinterDeliveryTaxVatUid();
  //       var vatCode =
  //       await SettingsManager.getVatCode(vatUid: vatCodeDeliveryTax);
  //       if (vatCode.isEmpty) {
  //         printerResponse.setStatus(PrinterStatus.deliverTaxVatError);
  //         _fiscalPrinterTestController.sink.add(printerResponse);
  //         return;
  //       }
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command: DatecsCommands.addItemOnFiscalReceipt(
  //               productName: "Taxa livrare",
  //               vatCode: vatCode,
  //               unitPrice: (sale.deliveryTax ?? 0),
  //               units: 1,
  //               discountValue: 0,
  //               departmentCode: "0",
  //               unitMeasureName: "buc"),
  //         ),
  //       );
  //       print("Delivery tax: ${(sale.deliveryTax ?? 0)}");
  //     }
  //     // if ((sale.depositValue ?? 0) > 0) {
  //     //   if (sale.payments != null) {
  //     //     if (!sale.payments!.any((element) => element.isAdvance ?? false)) {
  //     //       var vatCodeDeposit =
  //     //           await SettingsManager.getFiscalPrinterDepositVatUid();
  //     //       var vatCode =
  //     //           await SettingsManager.getVatCode(vatUid: vatCodeDeposit);
  //     //       if (vatCode.isEmpty) {
  //     //         printerResponse.setStatus(PrinterStatus.depositVarError);
  //     //         _fiscalPrinterTestController.sink.add(printerResponse);
  //     //         return;
  //     //       }
  //     //       listOfCommands.add(
  //     //         DatecsMessage(
  //     //           command: DatecsCommands.addItemOnFiscalReceipt(
  //     //               productName: "Storno avans produse",
  //     //               vatCode: vatCode,
  //     //               unitPrice: (sale.depositValue ?? 0),
  //     //               units: -1,
  //     //               discountValue: 0,
  //     //               departmentCode: "0",
  //     //               unitMeasureName: "buc"),
  //     //         ),
  //     //       );
  //     //       print("STORNO AVANS -1 x ${(sale.depositValue ?? 0)}");
  //     //     }
  //     //   }
  //     // }
  //
  //     //free text line
  //     listOfCommands.addAll(await _addFreeTextLines(sale: sale));
  //     var finalValue = (sale.totalValueWithVat ?? 0) - (sale.discountValue ?? 0);
  //     if (sale.payments != null) {
  //       if ((finalValue +
  //           (sale.deliveryTax ?? 0.0) -
  //           (sale.depositValue ?? 0.0)) >
  //           0) {
  //         var cashPayMethodsMap = await DBProvider.db.getRecords(
  //             tableName: TableCreate.tablePaymentMethod,
  //             where: "behaviour = ? OR behaviour = ?",
  //             whereArgs: [PaymentMethodBehaviour.cash.rawValue, PaymentMethodBehaviour.prepaid.rawValue]);
  //         var cashPayMethods = cashPayMethodsMap
  //             .map((e) => PaymentMethod.fromDatabase(e))
  //             .toList();
  //
  //         var noCashPayMethodsMap = await DBProvider.db.getRecords(
  //             tableName: TableCreate.tablePaymentMethod,
  //             where: "behaviour = ? OR behaviour = ? OR behaviour = ?",
  //             whereArgs: [
  //               PaymentMethodBehaviour.tickets.rawValue,
  //               PaymentMethodBehaviour.card.rawValue,
  //               PaymentMethodBehaviour.op.rawValue
  //             ]);
  //         var noCashPayMethods = noCashPayMethodsMap
  //             .map((e) => PaymentMethod.fromDatabase(e))
  //             .toList();
  //
  //         for (var payMethod in noCashPayMethods) {
  //           var payMethodValue = sale.payments!.fold<double>(
  //             0.0,
  //                 (prev, element) =>
  //             prev +
  //                 ((element.behaviour ??
  //                     PaymentMethodBehaviour.undefined.rawValue) ==
  //                     payMethod.behavior
  //                     ? ((element.quantity ?? 0) *
  //                     (element.unitValueWithVat ?? 0))
  //                     .toDouble()
  //                     : 0.0),
  //           );
  //           if (sale.payments!
  //               .where((element) => element.paymentUid == payMethod.uid)
  //               .isEmpty) {
  //             payMethodValue = 0;
  //           }
  //           if (payMethodValue != 0) {
  //             var payMethodCode = await SettingsManager.getPayMethodCode(
  //                 payMethodUid: payMethod.uid ?? "");
  //             if (payMethodCode.isEmpty) {
  //               printerResponse.setStatus(PrinterStatus.payMethodCodeCodeError);
  //               _fiscalPrinterTestController.sink.add(printerResponse);
  //               return;
  //             }
  //             listOfCommands.add(
  //               DatecsMessage(
  //                 command: DatecsCommands.addPayment(
  //                   payMethod: payMethodCode,
  //                   amount: payMethodValue,
  //                 ),
  //               ),
  //             );
  //             print("PAY code: $payMethodCode value: $payMethodValue");
  //           }
  //         }
  //
  //         for (var payMethod in cashPayMethods) {
  //           var payMethodValue = sale.payments!.fold<double>(
  //             0.0,
  //                 (prev, element) =>
  //             prev +
  //                 ((element.behaviour ??
  //                     PaymentMethodBehaviour.undefined.rawValue) ==
  //                     payMethod.behavior
  //                     ? ((element.quantity ?? 0) *
  //                     (element.unitValueWithVat ?? 0))
  //                     .toDouble()
  //                     : 0.0),
  //           );
  //           if (sale.payments!
  //               .where((element) => element.paymentUid == payMethod.uid)
  //               .isEmpty) {
  //             payMethodValue = 0;
  //           }
  //           if (payMethodValue != 0) {
  //             String payMethodUid = cashPayMethods.where((method) => method.behavior == PaymentMethodBehaviour.cash.rawValue).first.uid ?? "";
  //             var payMethodCode = await SettingsManager.getPayMethodCode(
  //                 payMethodUid: payMethodUid);
  //             if (payMethodCode.isEmpty) {
  //               printerResponse.setStatus(PrinterStatus.payMethodCodeCodeError);
  //               _fiscalPrinterTestController.sink.add(printerResponse);
  //               return;
  //             }
  //             listOfCommands.add(
  //               DatecsMessage(
  //                 command: DatecsCommands.addPayment(
  //                   payMethod: payMethodCode,
  //                   amount: payMethodValue,
  //                 ),
  //               ),
  //             );
  //             print("PAY code: $payMethodCode value: $payMethodValue");
  //           }
  //         }
  //       } else if (finalValue +
  //           (sale.deliveryTax ?? 0) -
  //           (sale.depositValue ?? 0) ==
  //           0) {
  //         print("value to pay is ZERO");
  //         for (var payment in sale.payments!) {
  //           var payMethodCode = await SettingsManager.getPayMethodCode(
  //               payMethodUid: payment.paymentUid ?? "");
  //           if (payMethodCode.isEmpty) {
  //             printerResponse.setStatus(PrinterStatus.payMethodCodeCodeError);
  //             _fiscalPrinterTestController.sink.add(printerResponse);
  //             return;
  //           }
  //           listOfCommands.add(
  //             DatecsMessage(
  //               command: DatecsCommands.addPayment(
  //                 payMethod: payMethodCode,
  //                 amount: 0,
  //               ),
  //             ),
  //           );
  //           print("PAY code: $payMethodCode value: 0");
  //           break;
  //         }
  //       }
  //     }
  //     listOfCommands
  //         .add(DatecsMessage(command: DatecsCommands.closeFiscalReceipt()));
  //     if (await testConnectionFromIp(_ip)) {
  //       await _executeCommands(
  //           commands: listOfCommands,
  //           action: FiscalPrinterAction.printFiscalBill);
  //     } else {
  //       _fiscalPrinterTestController.sink.add(FiscalPrinterResponse(
  //           status: PrinterStatus.failure,
  //           action: FiscalPrinterAction.printFiscalBill));
  //     }
  //   }
  // }

  // reprintFiscalBill({required Sale sale}) async {
  //   var printerResponse = FiscalPrinterResponse();
  //   printerResponse.setAction(FiscalPrinterAction.reprintFiscalBill);
  //   _ip = await SettingsManager.getFiscalPrinterHost();
  //   _port = int.tryParse(await SettingsManager.getFiscalPrinterPortAddress()) ??
  //       3999;
  //   _noOfCharactersPerLine =
  //   await SettingsManager.getFiscalPrinterNoOfCharactersPerLine();
  //   _timeoutWaitingResponse = await SettingsManager.getFiscalPrinterTimeout();
  //   await _cancelIfFiscalReceiptIsOpen();
  //   List<DatecsMessage> listOfCommands = [];
  //
  //   listOfCommands.add(
  //     DatecsMessage(
  //       command: DatecsCommands.openNonFiscalReceipt(),
  //     ),
  //   );
  //   listOfCommands.add(
  //     DatecsMessage(
  //       command: DatecsCommands.addNonFiscalItem(
  //           line: "BON NEFISCAL",
  //           align: DatecsTextAlign.center,
  //           bold: false,
  //           italic: false,
  //           doubleHeight: true,
  //           underline: false),
  //     ),
  //   );
  //   listOfCommands.add(
  //     DatecsMessage(
  //       command: DatecsCommands.separatorLine(DatecsSeparatorLineType.double),
  //     ),
  //   );
  //   if (sale.clientUniqueCode?.isNotEmpty ?? false) {
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.addNonFiscalItem(
  //             line: "CIF: ${sale.clientUniqueCode}",
  //             align: DatecsTextAlign.left,
  //             bold: true,
  //             italic: false,
  //             doubleHeight: false,
  //             underline: false),
  //       ),
  //     );
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.separatorLine(DatecsSeparatorLineType.double),
  //       ),
  //     );
  //   }
  //   if (sale.items != null) {
  //     for (var item in sale.items!) {
  //       if (item.isVoid || item.unitPriceWithVat == 0) {
  //         continue;
  //       }
  //       var productName = item.product?.name ?? "";
  //       if (productName.length > 36) {
  //         productName = productName.substring(0, 41);
  //       }
  //
  //       var unitMeasureName = item.product?.measureUnitName ?? "";
  //       if (unitMeasureName.length > 3) {
  //         unitMeasureName = unitMeasureName.substring(0, 3);
  //       }
  //       var realQuantity = (item.quantity ?? 0) * (item.units ?? 0);
  //       var totalPrice = (item.unitPriceWithVat ?? 0) * realQuantity;
  //
  //       if ((item.unitPriceWithVat ?? 0) < 0) {
  //         listOfCommands.add(
  //           DatecsMessage(
  //             command: DatecsCommands.addNonFiscalItem(
  //               line: "Stornare",
  //               align: DatecsTextAlign.center,
  //               bold: false,
  //               italic: false,
  //               doubleHeight: false,
  //               underline: false,
  //             ),
  //           ),
  //         );
  //       }
  //
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command: DatecsCommands.addNonFiscalItem(
  //             line: productName,
  //             align: DatecsTextAlign.left,
  //             bold: false,
  //             italic: false,
  //             doubleHeight: false,
  //             underline: false,
  //           ),
  //         ),
  //       );
  //
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command: DatecsCommands.addNonFiscalItem(
  //             line:
  //             "${realQuantity.toStringAsFixed(3)} $unitMeasureName X ${(item.unitPriceWithVat ?? 0).toStringAsFixed(2)} = ${totalPrice.toStringAsFixed(2)}",
  //             align: DatecsTextAlign.right,
  //             bold: false,
  //             italic: false,
  //             doubleHeight: false,
  //             underline: false,
  //           ),
  //         ),
  //       );
  //
  //       if ((item.discountValue ?? 0) > 0) {
  //         var discountValueString =
  //         (item.discountValue ?? 0).toStringAsFixed(2);
  //         var nameDiscount = "  REDUCERE";
  //         var details = nameDiscount;
  //         var number = _noOfCharactersPerLine -
  //             discountValueString.length -
  //             nameDiscount.length;
  //
  //         details += List<String>.generate(number, (_) => " ").join();
  //         details += discountValueString;
  //         listOfCommands.add(
  //           DatecsMessage(
  //             command: DatecsCommands.addNonFiscalItem(
  //               line: details,
  //               align: DatecsTextAlign.right,
  //               bold: false,
  //               italic: false,
  //               doubleHeight: false,
  //               underline: false,
  //             ),
  //           ),
  //         );
  //       }
  //     }
  //
  //     if ((sale.deliveryTax ?? 0) > 0) {
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command: DatecsCommands.addNonFiscalItem(
  //             line: "Taxa livrare",
  //             align: DatecsTextAlign.center,
  //             bold: true,
  //             italic: false,
  //             doubleHeight: false,
  //             underline: false,
  //           ),
  //         ),
  //       );
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command: DatecsCommands.addNonFiscalItem(
  //             line:
  //             "${1.toStringAsFixed(3)} buc X ${sale.deliveryTax} = ${sale.deliveryTax}",
  //             align: DatecsTextAlign.right,
  //             bold: false,
  //             italic: false,
  //             doubleHeight: false,
  //             underline: false,
  //           ),
  //         ),
  //       );
  //     }
  //     if ((sale.depositValue ?? 0) > 0) {
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command: DatecsCommands.addNonFiscalItem(
  //             line: "Storno avans produse",
  //             align: DatecsTextAlign.center,
  //             bold: true,
  //             italic: false,
  //             doubleHeight: false,
  //             underline: false,
  //           ),
  //         ),
  //       );
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command: DatecsCommands.addNonFiscalItem(
  //             line:
  //             "${1.toStringAsFixed(3)} buc X ${sale.depositValue} = ${sale.depositValue}",
  //             align: DatecsTextAlign.right,
  //             bold: false,
  //             italic: false,
  //             doubleHeight: false,
  //             underline: false,
  //           ),
  //         ),
  //       );
  //     }
  //     listOfCommands.add(DatecsMessage(
  //         command:
  //         DatecsCommands.separatorLine(DatecsSeparatorLineType.double)));
  //
  //     ///clientOrderId
  //     if (sale.clientOrderCode?.isNotEmpty ?? false) {
  //       var clientOrderCode = "Comanda: ${sale.clientOrderCode}";
  //       if (clientOrderCode.length > _noOfCharactersPerLine) {
  //         clientOrderCode =
  //             clientOrderCode.substring(0, _noOfCharactersPerLine - 1);
  //       }
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command: DatecsCommands.addNonFiscalItem(
  //             line: clientOrderCode,
  //             align: DatecsTextAlign.center,
  //             bold: false,
  //             italic: false,
  //             doubleHeight: false,
  //             underline: false,
  //           ),
  //         ),
  //       );
  //     }
  //
  //     ///day identifier
  //     var useDayIdentifier = await SettingsManager.getUseDayIdentifier();
  //     if (useDayIdentifier && (sale.dayIdentifier ?? 0) != 0) {
  //       var dayIdentifier = "Numar comanda: ${sale.dayIdentifier.toString()}";
  //       if (dayIdentifier.length > _noOfCharactersPerLine) {
  //         dayIdentifier =
  //             dayIdentifier.substring(0, _noOfCharactersPerLine - 1);
  //       }
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command: DatecsCommands.addNonFiscalItem(
  //             line: dayIdentifier,
  //             align: DatecsTextAlign.center,
  //             bold: true,
  //             italic: false,
  //             doubleHeight: true,
  //             underline: false,
  //           ),
  //         ),
  //       );
  //     }
  //
  //     ///fiscalTicketNo
  //     if (sale.fiscalTicketNo != null) {
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command: DatecsCommands.addNonFiscalItem(
  //             line: "Numar bon fiscal: ${sale.fiscalTicketNo ?? ""}",
  //             align: DatecsTextAlign.center,
  //             bold: false,
  //             italic: false,
  //             doubleHeight: false,
  //             underline: false,
  //           ),
  //         ),
  //       );
  //     }
  //
  //     /// username
  //     var username = "Operator: ${sale.userFullName ?? ""}";
  //     if (username.length > _noOfCharactersPerLine) {
  //       username = username.substring(0, _noOfCharactersPerLine - 1);
  //     }
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.addNonFiscalItem(
  //           line: username,
  //           align: DatecsTextAlign.center,
  //           bold: false,
  //           italic: false,
  //           doubleHeight: false,
  //           underline: false,
  //         ),
  //       ),
  //     );
  //
  //     ///pos
  //     var pos = "POS: ${sale.posName ?? ""}";
  //     if (pos.length > _noOfCharactersPerLine) {
  //       pos = pos.substring(0, _noOfCharactersPerLine - 1);
  //     }
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.addNonFiscalItem(
  //           line: pos,
  //           align: DatecsTextAlign.center,
  //           bold: false,
  //           italic: false,
  //           doubleHeight: false,
  //           underline: false,
  //         ),
  //       ),
  //     );
  //
  //     ///location
  //     var location = "Locatia: ${sale.locationName ?? ""}";
  //     if (location.length > _noOfCharactersPerLine) {
  //       location = location.substring(0, _noOfCharactersPerLine - 1);
  //     }
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.addNonFiscalItem(
  //           line: location,
  //           align: DatecsTextAlign.center,
  //           bold: false,
  //           italic: false,
  //           doubleHeight: false,
  //           underline: false,
  //         ),
  //       ),
  //     );
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.addNonFiscalItem(
  //           line: "Powered by freyapos.com",
  //           align: DatecsTextAlign.center,
  //           bold: true,
  //           italic: false,
  //           doubleHeight: false,
  //           underline: false,
  //         ),
  //       ),
  //     );
  //
  //     ///separator line
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.separatorLine(
  //           DatecsSeparatorLineType.double,
  //         ),
  //       ),
  //     );
  //
  //     ///empty line
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.addNonFiscalItem(
  //           line: "",
  //           align: DatecsTextAlign.center,
  //           bold: false,
  //           italic: false,
  //           doubleHeight: false,
  //           underline: false,
  //         ),
  //       ),
  //     );
  //     var finalValueString = (sale.finalValue ?? 0).toStringAsFixed(2);
  //     var nameFinalValue = "TOTAL LEI";
  //     var details = nameFinalValue;
  //     var number = _noOfCharactersPerLine -
  //         finalValueString.length -
  //         nameFinalValue.length;
  //     details += List<String>.generate(number, (_) => " ").join();
  //     details += finalValueString;
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.addNonFiscalItem(
  //           line: details,
  //           align: DatecsTextAlign.center,
  //           bold: false,
  //           italic: false,
  //           doubleHeight: true,
  //           underline: false,
  //         ),
  //       ),
  //     );
  //
  //     if (sale.payments != null) {
  //       if (((sale.finalValue ?? 0.0) +
  //           (sale.deliveryTax ?? 0.0) -
  //           (sale.depositValue ?? 0.0)) >
  //           0) {
  //         var payMethodsMap = await DBProvider.db
  //             .getRecords(tableName: TableCreate.tablePaymentMethod);
  //         var payMethods =
  //         payMethodsMap.map((e) => PaymentMethod.fromDatabase(e)).toList();
  //
  //         for (var payMethod in payMethods) {
  //           var payMethodValue = sale.payments!.fold<double>(
  //             0.0,
  //                 (prev, element) =>
  //             prev +
  //                 ((element.behaviour ??
  //                     PaymentMethodBehaviour.undefined.rawValue) ==
  //                     payMethod.behavior
  //                     ? ((element.quantity ?? 0) *
  //                     (element.unitValueWithVat ?? 0))
  //                     : 0.0),
  //           );
  //           if (sale.payments!
  //               .where((element) => element.paymentUid == payMethod.uid)
  //               .isEmpty) {
  //             payMethodValue = 0;
  //           }
  //           if (payMethodValue != 0) {
  //             var valueString = payMethodValue.toStringAsFixed(2);
  //             var payMethodName = payMethod.name ?? "";
  //             var details = payMethodName;
  //             var number = _noOfCharactersPerLine -
  //                 valueString.length -
  //                 payMethodName.length;
  //             details += List<String>.generate(number, (index) => " ").join();
  //             details += valueString;
  //             listOfCommands.add(
  //               DatecsMessage(
  //                 command: DatecsCommands.addNonFiscalItem(
  //                   line: details,
  //                   align: DatecsTextAlign.center,
  //                   bold: false,
  //                   italic: false,
  //                   doubleHeight: false,
  //                   underline: false,
  //                 ),
  //               ),
  //             );
  //           }
  //         }
  //       } else if ((sale.finalValue ?? 0) +
  //           (sale.deliveryTax ?? 0) -
  //           (sale.depositValue ?? 0) ==
  //           0) {
  //         for (var payment in sale.payments!) {
  //           var payMethodCode = await SettingsManager.getPayMethodCode(
  //               payMethodUid: payment.paymentUid ?? "");
  //           if (payMethodCode.isEmpty) {
  //             printerResponse.setStatus(PrinterStatus.payMethodCodeCodeError);
  //             _fiscalPrinterTestController.sink.add(printerResponse);
  //             return;
  //           }
  //           var valueString = 0.toStringAsFixed(2);
  //           var paymentMethodMap = await DBProvider.db.getRecords(
  //               tableName: TableCreate.tablePaymentMethod,
  //               where: "uid = ?",
  //               whereArgs: [payment.paymentUid]);
  //           var payMethodName = paymentMethodMap.isNotEmpty
  //               ? paymentMethodMap[0]['name'] ?? ""
  //               : "";
  //           var details = payMethodName;
  //           var number = _noOfCharactersPerLine -
  //               valueString.length -
  //               payMethodName.length;
  //           details +=
  //               List<String>.generate(number as int, (index) => " ").join();
  //           details += valueString;
  //           listOfCommands.add(
  //             DatecsMessage(
  //               command: DatecsCommands.addNonFiscalItem(
  //                 line: details,
  //                 align: DatecsTextAlign.center,
  //                 bold: false,
  //                 italic: false,
  //                 doubleHeight: false,
  //                 underline: false,
  //               ),
  //             ),
  //           );
  //           break;
  //         }
  //         //-------------
  //         var finalValueString = "0.00";
  //         var nameFinalValue = "REST DE PLATA LEI";
  //         var details = nameFinalValue;
  //         var number = _noOfCharactersPerLine -
  //             finalValueString.length -
  //             nameFinalValue.length;
  //         details += List<String>.generate(number, (_) => " ").join();
  //         details += finalValueString;
  //         listOfCommands.add(
  //           DatecsMessage(
  //             command: DatecsCommands.addNonFiscalItem(
  //               line: details,
  //               align: DatecsTextAlign.center,
  //               bold: false,
  //               italic: false,
  //               doubleHeight: true,
  //               underline: false,
  //             ),
  //           ),
  //         );
  //         //---------------
  //       }
  //
  //       ///empty line
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command: DatecsCommands.addNonFiscalItem(
  //             line: "",
  //             align: DatecsTextAlign.center,
  //             bold: false,
  //             italic: false,
  //             doubleHeight: false,
  //             underline: false,
  //           ),
  //         ),
  //       );
  //     }
  //     listOfCommands
  //         .add(DatecsMessage(command: DatecsCommands.closeNonFiscalReceipt()));
  //
  //     await _executeCommands(
  //         commands: listOfCommands,
  //         action: FiscalPrinterAction.reprintFiscalBill);
  //   }
  // }
  //
  addMoneyToCashRegister(double money, BluetoothDevice? btDevice) async {
    device = btDevice;
    if(device == null) {
      // _ip = await SettingsManager.getFiscalPrinterHost();
      // _port =
      //     int.tryParse(await SettingsManager.getFiscalPrinterPortAddress()) ??
      //         3999;
      // _noOfCharactersPerLine =
      // await SettingsManager.getFiscalPrinterNoOfCharactersPerLine();
      // _timeoutWaitingResponse = await SettingsManager.getFiscalPrinterTimeout();
    } else {
      var printerResponse = FiscalPrinterResponse();
      printerResponse.setAction(FiscalPrinterAction.addMoney);
      var response = await _sendCommandBT(
        message: DatecsMessage(
          command: DatecsCommands.cashIn(amount: money),
        ),
      );
      if (response != null) {
        var info = DatecsAnswerCashInOrOut(answer: response.getAnswer());
        if (DatecsResponseAdapter.noErrorCode(errorCode: info.errorCode)) {
          printerResponse.setStatus(PrinterStatus.ok);
        } else {
          printerResponse.setStatus(PrinterStatus.printerError);
          printerResponse.setErrorMessage(
              message: DatecsResponseAdapter.getErrorCodeInformation(
                  errorCode: info.errorCode));
        }
      } else {
        printerResponse.setStatus(PrinterStatus.error404);
      }
      print("Status: ${printerResponse.status}");
      print("Action: ${printerResponse.action}");
      print("Error message: ${printerResponse.errorMessage}");
      print("Number of fiscal tickets: ${printerResponse.numberOfFiscalTickets}");
      print("Number of Z report: ${printerResponse.numberOfZReport}");
      print("Cash in drawer: ${printerResponse.getCashInDrawer()}");
      print("Daily sum: ${printerResponse.getDailySum()}");
      _fiscalPrinterTestController.sink.add(printerResponse);
    }
  }

  // extractMoneyFromCashRegister(double money) async {
  //   _ip = await SettingsManager.getFiscalPrinterHost();
  //   _port = int.tryParse(await SettingsManager.getFiscalPrinterPortAddress()) ??
  //       3999;
  //   _noOfCharactersPerLine =
  //   await SettingsManager.getFiscalPrinterNoOfCharactersPerLine();
  //   _timeoutWaitingResponse = await SettingsManager.getFiscalPrinterTimeout();
  //   var printerResponse = FiscalPrinterResponse();
  //   printerResponse.setAction(FiscalPrinterAction.removeMoney);
  //   var response = await _sendCommand(
  //     message: DatecsMessage(
  //       command: DatecsCommands.cashOut(amount: money),
  //     ),
  //   );
  //   if (response != null) {
  //     var info = DatecsAnswerCashInOrOut(answer: response.getAnswer());
  //     if (DatecsResponseAdapter.noErrorCode(errorCode: info.errorCode)) {
  //       printerResponse.setStatus(PrinterStatus.ok);
  //     } else {
  //       printerResponse.setStatus(PrinterStatus.printerError);
  //       printerResponse.setErrorMessage(
  //           message: DatecsResponseAdapter.getErrorCodeInformation(
  //               errorCode: info.errorCode));
  //     }
  //   } else {
  //     printerResponse.setStatus(PrinterStatus.error404);
  //   }
  //   _fiscalPrinterTestController.sink.add(printerResponse);
  // }
  //
  // getWeightFromScale() {
  //   var printerResponse = FiscalPrinterResponse();
  //   printerResponse.setAction(FiscalPrinterAction.weight);
  //   _fiscalPrinterTestController.add(printerResponse);
  // }
  //
  // printNonFiscalReport(List<MiniPrinterLine> lines) async {
  //   _ip = await SettingsManager.getFiscalPrinterHost();
  //   _port = int.tryParse(await SettingsManager.getFiscalPrinterPortAddress()) ??
  //       3999;
  //   _noOfCharactersPerLine =
  //   await SettingsManager.getFiscalPrinterNoOfCharactersPerLine();
  //   _timeoutWaitingResponse = await SettingsManager.getFiscalPrinterTimeout();
  //   var printerResponse = FiscalPrinterResponse();
  //   printerResponse.setAction(FiscalPrinterAction.printNonFiscal);
  //   await _cancelIfFiscalReceiptIsOpen();
  //
  //   List<DatecsMessage> listOfCommands = [];
  //
  //   listOfCommands.add(
  //     DatecsMessage(
  //       command: DatecsCommands.openNonFiscalReceipt(),
  //     ),
  //   );
  //
  //   for (var line in lines) {
  //     if (line.lineType == LineTypeEnum.emptyLine) {
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command: DatecsCommands.addNonFiscalItem(
  //             line: "",
  //             align: DatecsTextAlign.center,
  //             bold: false,
  //             italic: false,
  //             doubleHeight: false,
  //             underline: false,
  //           ),
  //         ),
  //       );
  //     } else if (line.lineType == LineTypeEnum.separatorLine) {
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command:
  //           DatecsCommands.separatorLine(DatecsSeparatorLineType.double),
  //         ),
  //       );
  //     } else if (line.lineType == LineTypeEnum.cutLine) {
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command: DatecsCommands.addNonFiscalItem(
  //             line: "",
  //             align: DatecsTextAlign.center,
  //             bold: false,
  //             italic: false,
  //             doubleHeight: false,
  //             underline: false,
  //           ),
  //         ),
  //       );
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command:
  //           DatecsCommands.separatorLine(DatecsSeparatorLineType.double),
  //         ),
  //       );
  //       listOfCommands.add(
  //         DatecsMessage(
  //           command: DatecsCommands.addNonFiscalItem(
  //             line: "",
  //             align: DatecsTextAlign.center,
  //             bold: false,
  //             italic: false,
  //             doubleHeight: false,
  //             underline: false,
  //           ),
  //         ),
  //       );
  //     } else if (line.lineType == LineTypeEnum.textLine) {
  //       var printBold = false;
  //       var printDoubleHeight = false;
  //       if (line.fontStyle == FontStyleEnum.doubleHeight) {
  //         printDoubleHeight = true;
  //         printBold = false;
  //       } else if (line.fontStyle != FontStyleEnum.normal ||
  //           line.emphasizedFont!) {
  //         printDoubleHeight = false;
  //         printBold = true;
  //       }
  //       switch (line.textAlign) {
  //         case TextAlignEnum.right:
  //           listOfCommands.add(
  //             DatecsMessage(
  //               command: DatecsCommands.addNonFiscalItem(
  //                 line: line.textLine!,
  //                 align: DatecsTextAlign.right,
  //                 bold: printBold,
  //                 italic: false,
  //                 doubleHeight: printDoubleHeight,
  //                 underline: false,
  //               ),
  //             ),
  //           );
  //           break;
  //         case TextAlignEnum.left:
  //           listOfCommands.add(
  //             DatecsMessage(
  //               command: DatecsCommands.addNonFiscalItem(
  //                 line: line.textLine!,
  //                 align: DatecsTextAlign.left,
  //                 bold: printBold,
  //                 italic: false,
  //                 doubleHeight: printDoubleHeight,
  //                 underline: false,
  //               ),
  //             ),
  //           );
  //           break;
  //         case TextAlignEnum.center:
  //           listOfCommands.add(
  //             DatecsMessage(
  //               command: DatecsCommands.addNonFiscalItem(
  //                 line: line.textLine!,
  //                 align: DatecsTextAlign.center,
  //                 bold: printBold,
  //                 italic: false,
  //                 doubleHeight: printDoubleHeight,
  //                 underline: false,
  //               ),
  //             ),
  //           );
  //           break;
  //         default:
  //           break;
  //       }
  //     }
  //   }
  //
  //   listOfCommands.add(
  //     DatecsMessage(
  //       command: DatecsCommands.closeNonFiscalReceipt(),
  //     ),
  //   );
  //   await _executeCommands(
  //       commands: listOfCommands, action: FiscalPrinterAction.printNonFiscal);
  // }
  //
  // static setInitialSettings(String? ip) async {
  //   if (ip == null) return;
  //   await SettingsManager.setFiscalPrinterHost(ip);
  //   await SettingsManager.setFiscalPrinterModel(
  //       GenericFiscalPrinterType.Datecs.description);
  //   await SettingsManager.setFiscalPrinterUserName("1");
  //   await SettingsManager.setFiscalPrinterPassword("0001");
  //   await SettingsManager.setFiscalPrinterPortAddress("3999");
  //   await SettingsManager.setFiscalPrinterTimeout("9");
  //
  //   var vatsMap =
  //   await DBProvider.db.getRecords(tableName: TableCreate.tableVat);
  //   var vats = vatsMap.map((e) => Vat.fromApiJsonAndDatabase(e)).toList();
  //   for (var vat in vats) {
  //     if (vat.rate == 0) {
  //       await SettingsManager.setVatCode(forVatUid: vat.uid ?? "", code: "4");
  //     } else if (vat.rate == 0.05) {
  //       await SettingsManager.setVatCode(forVatUid: vat.uid ?? "", code: "3");
  //     } else if (vat.rate == 0.09) {
  //       await SettingsManager.setVatCode(forVatUid: vat.uid ?? "", code: "2");
  //     } else if (vat.rate == 0.19) {
  //       await SettingsManager.setVatCode(forVatUid: vat.uid ?? "", code: "1");
  //     }
  //   }
  //
  //   var paymentMethodsMap = await DBProvider.db
  //       .getRecords(tableName: TableCreate.tablePaymentMethod);
  //   var paymentMethods =
  //   paymentMethodsMap.map((e) => PaymentMethod.fromDatabase(e)).toList();
  //   for (var payMethod in paymentMethods) {
  //     if (payMethod.behavior == PaymentMethodBehaviour.cash.rawValue) {
  //       await SettingsManager.setPayMethodCode(
  //           forPayMethodUid: payMethod.uid ?? "", code: "0");
  //     } else if (payMethod.behavior == PaymentMethodBehaviour.card.rawValue) {
  //       await SettingsManager.setPayMethodCode(
  //           forPayMethodUid: payMethod.uid ?? "", code: "1");
  //     } else if (payMethod.behavior ==
  //         PaymentMethodBehaviour.tickets.rawValue) {
  //       await SettingsManager.setPayMethodCode(
  //           forPayMethodUid: payMethod.uid ?? "", code: "3");
  //     } else if (payMethod.behavior == PaymentMethodBehaviour.op.rawValue) {
  //       await SettingsManager.setPayMethodCode(
  //           forPayMethodUid: payMethod.uid ?? "", code: "5");
  //     }
  //   }
  // }

  static List<String> macAddresses() => ["68:AA:D2"];

  /*---------------------------------------
        PRIVATE METHODS
  ----------------------------------------*/
  // _cancelIfFiscalReceiptIsOpen() async {
  //   var response = await _sendCommand(
  //       message: DatecsMessage(command: DatecsCommands.receiptInfo()));
  //   if (response != null) {
  //     var info = DatecsAnswerReceiptInfo(answer: response.getAnswer());
  //     if (DatecsResponseAdapter.noErrorCode(errorCode: info.errorCode)) {
  //       if (info.isOpen) {
  //         _cancelFiscalReceipt();
  //       }
  //     }
  //   }
  // }
  //
  // Future<List<DatecsMessage>> _addFreeTextLines({required Sale sale}) async {
  //   List<DatecsMessage> listOfCommands = [];
  //   var printClientOrderId = sale.clientOrderCode?.isNotEmpty ?? false;
  //   var printDayIdentifier = (await SettingsManager.getUseDayIdentifier()) && (sale.dayIdentifier ?? 0) != 0;
  //   var printUserName = await SettingsManager.getPrintOperatorName();
  //   var printPosName = await SettingsManager.getPrintPosName();
  //   var printLocationName = await SettingsManager.getPrintLocationName();
  //   if(!printClientOrderId && !printDayIdentifier && !printUserName && !printPosName && !printLocationName){
  //     return listOfCommands;
  //   }
  //   ///separator line
  //   listOfCommands.add(DatecsMessage(
  //       command: DatecsCommands.separatorLine(DatecsSeparatorLineType.double)));
  //
  //   ///clientOrderId
  //   if (printClientOrderId) {
  //     var clientOrderCode = "Comanda: ${sale.clientOrderCode}";
  //     if (clientOrderCode.length > _noOfCharactersPerLine) {
  //       clientOrderCode =
  //           clientOrderCode.substring(0, _noOfCharactersPerLine - 1);
  //     }
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.addFreeTextLine(
  //           line: clientOrderCode,
  //           align: DatecsTextAlign.center,
  //           bold: false,
  //           italic: false,
  //           doubleHeight: false,
  //           underline: false,
  //         ),
  //       ),
  //     );
  //   }
  //
  //   if (printDayIdentifier) {
  //     var dayIdentifier = "Numar comanda: ${sale.dayIdentifier.toString()}";
  //     if (dayIdentifier.length > _noOfCharactersPerLine) {
  //       dayIdentifier = dayIdentifier.substring(0, _noOfCharactersPerLine - 1);
  //     }
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.addFreeTextLine(
  //           line: dayIdentifier,
  //           align: DatecsTextAlign.center,
  //           bold: true,
  //           italic: false,
  //           doubleHeight: true,
  //           underline: false,
  //         ),
  //       ),
  //     );
  //   }
  //
  //   /// username
  //   if(printUserName) {
  //     var username = "Operator: ${sale.userFullName ?? ""}";
  //     if (username.length > _noOfCharactersPerLine) {
  //       username = username.substring(0, _noOfCharactersPerLine - 1);
  //     }
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.addFreeTextLine(
  //           line: username,
  //           align: DatecsTextAlign.center,
  //           bold: false,
  //           italic: false,
  //           doubleHeight: false,
  //           underline: false,
  //         ),
  //       ),
  //     );
  //   }
  //
  //   ///pos
  //   if(printPosName) {
  //     var pos = "POS: ${sale.posName ?? ""}";
  //     if (pos.length > _noOfCharactersPerLine) {
  //       pos = pos.substring(0, _noOfCharactersPerLine - 1);
  //     }
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.addFreeTextLine(
  //           line: pos,
  //           align: DatecsTextAlign.center,
  //           bold: false,
  //           italic: false,
  //           doubleHeight: false,
  //           underline: false,
  //         ),
  //       ),
  //     );
  //   }
  //   ///location
  //   if(printLocationName) {
  //     var location = "Locatia: ${sale.locationName ?? ""}";
  //     if (location.length > _noOfCharactersPerLine) {
  //       location = location.substring(0, _noOfCharactersPerLine - 1);
  //     }
  //     listOfCommands.add(
  //       DatecsMessage(
  //         command: DatecsCommands.addFreeTextLine(
  //           line: location,
  //           align: DatecsTextAlign.center,
  //           bold: false,
  //           italic: false,
  //           doubleHeight: false,
  //           underline: false,
  //         ),
  //       ),
  //     );
  //   }
  //
  //   listOfCommands.add(
  //     DatecsMessage(
  //       command: DatecsCommands.addFreeTextLine(
  //         line: "Powered by freyapos.com",
  //         align: DatecsTextAlign.center,
  //         bold: true,
  //         italic: false,
  //         doubleHeight: false,
  //         underline: false,
  //       ),
  //     ),
  //   );
  //
  //   ///separator line
  //   listOfCommands.add(
  //     DatecsMessage(
  //       command: DatecsCommands.separatorLine(
  //         DatecsSeparatorLineType.double,
  //       ),
  //     ),
  //   );
  //   return listOfCommands;
  // }

  Future<DatecsResponseAdapter?> _sendCommand(
      {required DatecsMessage message}) async {
    Socket? _socket;
    DatecsResponseAdapter? _response;
    await Socket.connect(_ip!, _port!, timeout: const Duration(seconds: 1))
        .then((socket) {
      _socket = socket;
    }).then((_) {
      _socket!.add(message.getMessage());
      return _socket!
          .firstWhere((data) => !DatecsResponseAdapter(
                  response: data, sequenceNumber: message.seqNo)
              .checkWaitToGetResponse())
          .timeout(Duration(
              seconds: int.tryParse(_timeoutWaitingResponse ?? "9") ?? 9));
    }).then((data) {
      //print(data);
      _response =
          DatecsResponseAdapter(response: data, sequenceNumber: message.seqNo);
      _socket?.close();
    }).catchError((e) {
      print(e);
      //printerResponse.setStatus(PrinterStatus.failure);
      _socket?.close();
    });
    return _response;
  }

  Future<DatecsResponseAdapter?> _sendCommandBT(
      {required DatecsMessage message}) async {
    BluetoothConnection? connection;
    DatecsResponseAdapter? response;
    await BluetoothConnection.toAddress(device!.address).timeout(const Duration(seconds: 3))
        .then((conn) {
      connection = conn;
    }).then((_) {
      connection!.output.add(message.getMessage());
      return connection!.input!.firstWhere((data) => !DatecsResponseAdapter(
          response: data, sequenceNumber: message.seqNo)
          .checkWaitToGetResponse()).timeout(const Duration(seconds: 9));
          // .timeout(Duration(
          // seconds: int.tryParse(_timeoutWaitingResponse ?? "9") ?? 9));
    }).then((data) {
      //print(data);
      response =
          DatecsResponseAdapter(response: data, sequenceNumber: message.seqNo);
      connection?.close();
    }).catchError((e) {
      print(e);
      //printerResponse.setStatus(PrinterStatus.failure);
      connection?.close();
    });
    return response;
  }

  _executeCommands(
      {required List<DatecsMessage> commands,
      required FiscalPrinterAction action}) async {
    var tcpClient = DatecsTcpClientAdapter(ip: _ip!, port: _port!);
    tcpClient.printerResponse.listen((printerResponse) {
      printerResponse.setAction(action);
      _fiscalPrinterTestController.sink.add(printerResponse);
    });
    tcpClient.sendData(commands: commands);
  }

  _executeCommandsBT(
      {required List<DatecsMessage> commands,
        required FiscalPrinterAction action}) async {
    var bluetoothClient = DatecsBluetoothClientAdapter(btDevice: device!);
    bluetoothClient.printerResponse.listen((printerResponse) {
      printerResponse.setAction(action);
      _fiscalPrinterTestController.sink.add(printerResponse);
    });
    bluetoothClient.sendData(commands: commands);
  }
  // _cancelFiscalReceipt() async {
  //   var response = await _sendCommand(
  //       message: DatecsMessage(command: DatecsCommands.cancelFiscalReceipt()));
  //   if (response != null) {
  //     var info = DatecsAnswerReceiptInfo(answer: response.getAnswer());
  //     if (info.errorCode == DatecsErrorCodes.nonFiscalReceiptIsOpen.value) {
  //       await _sendCommand(
  //           message:
  //           DatecsMessage(command: DatecsCommands.closeNonFiscalReceipt()));
  //     }
  //   }
  // }
}
