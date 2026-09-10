import 'package:flutter/widgets.dart';

class AppSpacing {
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 40.0;

  // Reusable SizedBox spacers
  static const SizedBox gapW2 = SizedBox(width: 2);
  static const SizedBox gapW4 = SizedBox(width: xxs);
  static const SizedBox gapW6 = SizedBox(width: 6);
  static const SizedBox gapW8 = SizedBox(width: xs);
  static const SizedBox gapW10 = SizedBox(width: 10);
  static const SizedBox gapW12 = SizedBox(width: sm);
  static const SizedBox gapW14 = SizedBox(width: 14);
  static const SizedBox gapW16 = SizedBox(width: md);
  static const SizedBox gapW20 = SizedBox(width: lg);
  static const SizedBox gapW24 = SizedBox(width: xl);

  static const SizedBox gapH2 = SizedBox(height: 2);
  static const SizedBox gapH4 = SizedBox(height: xxs);
  static const SizedBox gapH6 = SizedBox(height: 6);
  static const SizedBox gapH8 = SizedBox(height: xs);
  static const SizedBox gapH10 = SizedBox(height: 10);
  static const SizedBox gapH12 = SizedBox(height: sm);
  static const SizedBox gapH14 = SizedBox(height: 14);
  static const SizedBox gapH16 = SizedBox(height: md);
  static const SizedBox gapH20 = SizedBox(height: lg);
  static const SizedBox gapH24 = SizedBox(height: xl);
  static const SizedBox gapH32 = SizedBox(height: xxl);
  static const SizedBox gapH40 = SizedBox(height: xxxl);

  // Common edge insets
  static const EdgeInsets p4 = EdgeInsets.all(xxs);
  static const EdgeInsets p8 = EdgeInsets.all(xs);
  static const EdgeInsets p12 = EdgeInsets.all(sm);
  static const EdgeInsets p16 = EdgeInsets.all(md);
  static const EdgeInsets p20 = EdgeInsets.all(lg);
  static const EdgeInsets p24 = EdgeInsets.all(xl);

  static const EdgeInsets px16 = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets px20 = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets py12 = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets py16 = EdgeInsets.symmetric(vertical: md);
}
