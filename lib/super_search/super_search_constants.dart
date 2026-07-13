import 'package:live_vitalist/app/constants.dart';

abstract final class SuperSearchConstants {
  static const Duration overlayFadeDuration = Duration(milliseconds: 200);
  static const double overlayBarSpacing = 12.0;

  /// Keeps the overlay content clear of the `SuperBar` floating over it.
  static const double overlayBottomInset =
      20.0 + Constants.searchBarHeight + overlayBarSpacing;
}
