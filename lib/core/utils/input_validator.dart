import '../../l10n/app_localizations.dart';

class InputValidator {
  InputValidator._();

  static String? email(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.fieldRequired;
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return l10n.invalidEmail;
    }
    return null;
  }

  static String? password(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.fieldRequired;
    }
    if (value.length < 6) {
      return l10n.passwordTooShort;
    }
    return null;
  }

  static String? name(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.fieldRequired;
    }
    if (value.trim().length < 2) {
      return l10n.nameTooShort;
    }
    return null;
  }

  static String? required(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.fieldRequired;
    }
    return null;
  }
}
