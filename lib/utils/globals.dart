class Globals {
  //int tremolNbl = 1;
  int datecsLastSequenceNumber = 1;
  // bool globalReportPrinterIsPresent = false;
  // bool isDatecsBC50Device = false;
  // bool bankingPosIsCalled = false;
  // bool isVivaWalletOne = false;
  // Map<String, dynamic>? bankPosResponseData;
  // bool canAcceptBarcodeScan = true;

  static final Globals _globals = Globals._internal();
  factory Globals() {
    return _globals;
  }
  Globals._internal();

// incrementTremolNbl() => _tremolNbl++;
// int get tremolNbl => _tremolNbl;
// set tremolNbl(int value) => _tremolNbl = value;
}
