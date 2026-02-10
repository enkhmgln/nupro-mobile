import 'package:money_formatter/money_formatter.dart';

extension ExtendedDouble on double {
  String toCurrency({
    bool hasSymbol = true,
    String symbol = '\u20AE',
    int fractionDigits = 0,
  }) {
    MoneyFormatter fmf = MoneyFormatter(
      amount: this,
      settings: MoneyFormatterSettings(
        symbol: symbol,
        thousandSeparator: ',',
        decimalSeparator: '.',
        symbolAndNumberSeparator: '',
        fractionDigits: fractionDigits,
        compactFormatType: CompactFormatType.short,
      ),
    );

    return hasSymbol ? fmf.output.symbolOnRight : fmf.output.nonSymbol;
  }
}
