class Util {
  static String adaptImageURL(String url) {
    if (url.startsWith("http://") || url.startsWith("https://")) {
      return url;
    }
    if (url.startsWith("//")) {
      return "https:$url";
    }
    return url;
  }
}
