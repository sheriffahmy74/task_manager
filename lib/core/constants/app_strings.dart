/// Context-free fallback messages used by the network layer
/// (which has no [BuildContext] to resolve localized strings).
/// All user-facing UI strings live in the ARB files (`lib/l10n`)
/// and are accessed via `context.l10n`.
class AppStrings {
  AppStrings._();

  static const String noInternet = 'No internet connection';
  static const String serverError = 'Server error. Please try again later.';
  static const String unauthorized = 'Session expired. Please login again.';
}
