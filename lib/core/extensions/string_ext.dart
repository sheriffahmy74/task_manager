extension StringExt on String {
  bool get isValidEmail {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return regex.hasMatch(trim());
  }

  bool get isNotNullOrEmpty => trim().isNotEmpty;

  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String get toTitleCase {
    return split(' ').map((w) => w.capitalize).join(' ');
  }
}

extension NullableStringExt on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
}
