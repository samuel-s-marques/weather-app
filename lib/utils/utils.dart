extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty || this == null) return this;

    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

