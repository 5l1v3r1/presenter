part of presenter;

String _escapeStr(String str) {
  return str.codeUnits.map((int x) {
    x = x % 0xff;
    return (x < 0x10 ? '0' : '') + x.toRadixString(0x10);
  }).join('');
}

String _escapeNumber(num value) {
  return value.toStringAsFixed(3);
}
