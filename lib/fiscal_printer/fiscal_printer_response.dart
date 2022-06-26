class FiscalPrinterResponse {
  PrinterStatus _status = PrinterStatus.failure;
  String? _message;
  String? _numberOfFiscalTickets;
  String? _numberOfZReport;
  //String? _weight;
  double? _dailySum;
  double? _cashInDrawer;
  FiscalPrinterAction? _action;

  FiscalPrinterResponse(
      {PrinterStatus status = PrinterStatus.failure,
      String? message,
      String? numberOfFiscalTickets,
      String? numberOfZReport,
      String? weight,
      double? dailySum,
      double? cashInDrawer,
      FiscalPrinterAction? action}) {
    _status = status;
    _message = message;
    _numberOfFiscalTickets = numberOfFiscalTickets;
    _numberOfZReport = numberOfZReport;
    //_weight = weight;
    _dailySum = dailySum;
    _cashInDrawer = cashInDrawer;
    _action = action;
  }

  String get errorMessage {
    if (_status == PrinterStatus.printerError) {
      return _message!;
    } else {
      return _status.message;
    }
  }

  PrinterStatus get status => _status;
  String? get numberOfZReport => _numberOfZReport;
  String? get numberOfFiscalTickets => _numberOfFiscalTickets;
  FiscalPrinterAction? get action => _action;

  setStatus(PrinterStatus status, {String? customMessage}) {
    _status = status;
    _message = customMessage;
  }

  setAction(FiscalPrinterAction action) {
    _action = action;
  }

  setErrorMessage({required String message}) {
    _message = message;
  }

  setZReportNumber(String number) {
    _numberOfZReport = number;
  }

  setFiscalTicketsNumber(String? number) {
    _numberOfFiscalTickets = number;
  }

  double? getDailySum() {
    return _dailySum;
  }

  double? getCashInDrawer() {
    return _cashInDrawer;
  }

  setDailySum(double? value) {
    _dailySum = value;
  }

  setCashInDrawer(double? value) {
    _cashInDrawer = value;
  }
}

enum FiscalPrinterAction {
  testConnection,
  openDrawer,
  printReportZ,
  printReportX,
  printReportZCopy,
  printReportZInterval,
  dailySum,
  cashInDrawer,
  printFiscalBill,
  reprintFiscalBill,
  clearDisplay,
  addMoney,
  removeMoney,
  weight,
  printNonFiscal,
  cancelFiscal
}

enum PrinterStatus {
  ok,
  failure,
  wrongURL,
  noUrl,
  unauthorized,
  error404,
  noModel,
  xmlResponseError,
  vatCodeError,
  deliverTaxVatError,
  payMethodCodeCodeError,
  printerError,
  outOfPaper
}

extension FiscalPrinterStatusExt on PrinterStatus {
  String get message {
    switch (this) {
      case PrinterStatus.ok:
        return "";
      case PrinterStatus.failure:
        return "Exista o problema la imprimanata";
      case PrinterStatus.outOfPaper:
        return "Probabil imprimanta a ramas fara hartie";
      case PrinterStatus.wrongURL:
        return "URL-ul imprimantei nu este corect";
      case PrinterStatus.noUrl:
        return "Introduce-ti url-ul imprimantei in setari";
      case PrinterStatus.unauthorized:
        return "Verificati username-ul si parola imprimantei";
      case PrinterStatus.error404:
        return "Exista o problema in setarile imprimantei";
      case PrinterStatus.noModel:
        return "Selectati modelul imprimantei";
      case PrinterStatus.vatCodeError:
        return "Trebuie sa setati codurile de TVA";
      case PrinterStatus.xmlResponseError:
        return "Erare fisier XML";
      case PrinterStatus.deliverTaxVatError:
        return "Cota de TVA pentru taxa de livrare lipseste";
      case PrinterStatus.payMethodCodeCodeError:
        return "Codurile pentru metodele de p;lata";
      default:
        return "";
    }
  }
}
