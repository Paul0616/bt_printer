enum DatecsErrorCodes {
  fiscalReceiptIsOpen("-111015"),
  nonFiscalReceiptIsOpen("-111046"),
  noEnoughPayment("-111018"),
  noError("0"),
  unknownError("-1");

  const DatecsErrorCodes(this.value);
  final String value;
}
