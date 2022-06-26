import 'dart:math';

class Helper {
  static String replaceDiacritics(String textLine) {
    var result = "";
    var list = textLine.split("");
    for (var char in list) {
      if (char == "Ă" || char == "Â") {
        result += "A";
      } else if (char == "ă" || char == "â") {
        result += "a";
      } else if (char == "Î") {
        result += "I";
      } else if (char == "î") {
        result += "i";
      } else if (char == "Ș") {
        result += "S";
      } else if (char == "ș") {
        result += "s";
      } else if (char == "Ț") {
        result += "T";
      } else if (char == "ț") {
        result += "t";
      } else {
        result += char;
      }
    }
    return result;
  }

  static double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    String v = (mod * value).toStringAsFixed(places);
    return (double.parse(v).round().toDouble() / mod);
  }
}
