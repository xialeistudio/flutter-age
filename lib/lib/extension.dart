extension Url on String {
  asUrl() {
    if (startsWith("http://") || startsWith("https://")) {
      return this;
    }
    if (startsWith("//")) {
      return "https:$this";
    }
    return this;
  }
}
