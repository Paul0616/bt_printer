import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:rxdart/rxdart.dart';

import '../blocs/base_bloc.dart';
import 'fiscal_printer_response.dart';
import 'models/datecs.dart';

class GenericPrinterBloc extends BaseBloc {
  // GenericFiscalPrinterType _type = GenericFiscalPrinterType.Unspecified;
  // MessageManagerBloc? _messageManager;
  //
  @override
  void dispose() {
    _fiscalPrinterTestController.close();
    // _miniPrinterResponseController.close();
  }

  final _fiscalPrinterTestController = PublishSubject<FiscalPrinterResponse>();

  Stream<FiscalPrinterResponse> get fiscalPrinterStatus =>
      _fiscalPrinterTestController.stream;

  printReportX(BluetoothDevice? device) {
    Datecs(_fiscalPrinterTestController).printReportX(device);
  }

  addMoneyToCashRegister(double money, BluetoothDevice? device) {
   Datecs(_fiscalPrinterTestController).addMoneyToCashRegister(money, device);
  }

  dailySum(BluetoothDevice? device){
    Datecs(_fiscalPrinterTestController).dailySum(device);
  }
}
