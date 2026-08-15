abstract final class SuperSearchConstants {
  static const Duration overlayFadeDuration = Duration(milliseconds: 200);
  static const double overlayBarSpacing = 12.0;

  static const double barHeight = 70.0;
  static const double barButtonSize = 48.0;
  static const double barIconSize = 30.0;
  static const double barHorizontalPadding = (barHeight - barButtonSize) / 2.0;
  static const double barButtonPadding = barHorizontalPadding / 2.0;

  /// Keeps the overlay content clear of the `SuperBar` floating over it.
  static const double overlayBottomInset =
      20.0 + barHeight + overlayBarSpacing;
}
