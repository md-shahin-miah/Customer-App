class MyUtils {
  static String breakText(String text, int breakingPoint) {
    if (text.length > breakingPoint) {
      List<String> textParts = text.split(" ");
      int len = 0;
      text = "";
      for (String part in textParts) {
        if (len > breakingPoint) {
          text += "\n";
          len = 0;
        }
        String additon = part + " ";
        text += additon;
        len += additon.length;
      }
    }

    return text;
  }
}
