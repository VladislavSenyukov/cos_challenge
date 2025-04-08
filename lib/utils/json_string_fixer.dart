class JsonStringFixer {
  static String fix(String jsonString) {
    final buffer = StringBuffer();
    String? lastChar;
    for (int i = 0; i < jsonString.length; i++) {
      final char = jsonString[i];
      buffer.write(char);
      if (char == '"' &&
          lastChar != '\\' &&
          lastChar != ' ' &&
          lastChar != ',') {
        for (int j = i + 1; j < jsonString.length; j++) {
          final nextChar = jsonString[j];
          if (nextChar == '"') {
            buffer.write(',');
            break;
          } else if (nextChar == '}' ||
              nextChar == ']' ||
              nextChar == ':' ||
              nextChar == ',') {
            break;
          }
        }
      }
      lastChar = char;
    }
    return buffer.toString();
  }
}
