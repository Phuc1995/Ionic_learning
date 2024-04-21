import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // this basically makes it so you can't instantiate this class

  static const Map<int, Color> pink = const <int, Color>{
    50: const Color(0xFFfce4ec),
    100: const Color(0xFFf8bbd0),
    200: const Color(0xFFf48fb1),
    300: const Color(0xFFf06292),
    400: const Color(0xFFec407a),
    500: const Color(0xFFe91e63),
    600: const Color(0xFFd81b60),
    700: const Color(0xFFc2185b),
    800: const Color(0xFFad1457),
    900: const Color(0xFF880e4f)
  };

  static const Gradient pinkGradientButton = LinearGradient(colors: [
    Color(0xFFFF3585),
    Color(0xFFFF877D),
  ], begin: Alignment(0, -1), end: Alignment(0.03, 1.1));

  static const Gradient yellowGradient = LinearGradient(colors: [
    Color(0xFFFDED51),
    Color(0xFFEFC231),
  ], begin: Alignment(0, -1), end: Alignment(0.03, 1.1));


  static const Gradient pinkGradientBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFB8165A),
      Color(0xFFDD2863),
    ],
  );

  static const Gradient DarkTopGradientBackground = LinearGradient(
    stops: [
      -0.23,
      -0.23,
      -0.23,
      -0.23,
      -0.22,
      -0.12,
      -0.12,
      -0.11,
      -0.11,
      -0.11,
      0.0046,
      0.35,
      0.66,
      0.99,
      1.2,
      1.2,
      1.2,
      1.2,
      1.2,
      1.3,
      1.3,
      1.3,
      1.3,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF000000),
      Color(0xFF000000),
      Color(0xFF000000),
      Color(0xFF000000),
      Color(0xFF0d030d),
      Color(0xFF000000),
      Color(0xFF000000),
      Color(0xFFc2c2c2),
      Color(0xFF000000),
      Color(0xFF000000),
      Color(0xFFababab),
      Color(0xFFffffff),
      Color(0xFFf7f7f7),
      Color(0xFF878787),
      Color(0xFF000000),
      Color(0xFF544545),
      Color(0xFF000000),
      Color(0xFF000000),
      Color(0xFF000000),
      Color(0xFF6b6b6b),
      Color(0xFF000000),
      Color(0xFFEE9944),
      Color(0xFF000000),
    ],
  );

  static const Gradient skyGradientBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      turquoise,
      summerSky,
    ],
  );

  static const Gradient whiteBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white,
      Colors.white,
    ],
  );
  static const Gradient darkGradientBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFDADADA),
      Color(0xFFDADADA),
    ],
  );

  static const Gradient darkGradientBackground2 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF6F6F6),
      Color(0xFFF6F6F6),
    ],
  );

  static const Gradient suvaGreyGradientBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF5F5F5),
      Colors.white,
    ],
  );

  static Gradient pinkGradientBox = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFb8165a).withOpacity(0.18),
      Color(0xFFDD2863).withOpacity(0.4),
    ],
  );

  static Gradient pinkNotifyLiveBox = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE92B7A).withOpacity(0.5),
      Color(0xFFFF9D88).withOpacity(0.4),
    ],
  );

  static Gradient backgroundLoadingGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE92B7A),
      Color(0xFFFF9D88),
    ],
  );

  static Gradient pinkGradientNotificationBox = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE92B7A).withOpacity(0.75),
      Color(0xFFFF9D88).withOpacity(0.75),
    ],
  );

  static Gradient pinkGradientNotificationBox2 = LinearGradient(
    begin: FractionalOffset.topLeft,
    end: FractionalOffset.bottomRight,
    colors: [
      Color(0xFFD01C68
      ),
      Color(0xFFEB805F),
    ],
  );

  static const Color pinkLiveButtonCustom = Color(0xFFDD2863);

  static const Color wildWatermelon = Color(0xFFFF5783);

  static const Color wildWatermelon2 = Color(0xFFE82A7A);

  static const Color wildWatermelon3 = Color(0xFFE92B7A);

  static const Color mahogany = Color(0xFFCD3E3E);

  static const Color mahogany2 = Color(0xFFDD2863);

  static const Color mahogany3 = Color(0xFFCC2600);

  static const Color whiteSmoke = Color(0xFFC4C4C4);

  static const Color whiteSmoke2 = Color(0xFFF6F6F6);

  static const Color whiteSmoke3 = Color(0xFFF7F7F7);

  static const Color whiteSmoke4 = Color(0xFFDADADA);

  static const Color whiteSmoke5 = Color(0xFFF2F2F2);

  static const Color whiteSmoke6 = Color(0xFFBDBDBD);

  static const Color whiteSmoke7 = Color(0xFF909090);

  static const Color whiteSmoke8 = Color(0xFFF8F8F8);

  static const Color whiteSmoke9 = Color(0xFFB6B6B6);

  static const Color whiteSmoke10 = Color(0xFFDDDDDD);

  static const Color whiteSmoke11 = Color(0xFFDF4F4F4);

  static const Color whiteSmoke12 = Color(0xFFF1F1F1);

  static const Color whiteSmoke13 = Color(0xFFD4D4D4);

  static const Color whiteSmoke14 = Color(0xFFF9F9F9);

  static const Color grayCustom = Color(0xFF333333);

  static const Color grayCustom1 = Color(0xFF444444);

  static const Color grayCustom2 = Color(0xFF3A3A3A);

  static const Color grayCustom3 = Color(0xFF5B5B5B);

  static const Color gainsboro = Color(0xFFDADADA);

  static const Color nobel = Color(0xFF9A9A9A);

  static const Color suvaGrey = Color(0xFF8A8A8A);

  static const Color grey = Color(0xFF848484);

  static const Color grey2 = Color(0xFF797979);

  static const Color grey3 = Color(0xFF8A8A8A);

  static const Color grey4 = Color(0xFFE0E0E0);

  static const Color grey5 = Color(0xFFF3F3F3);

  static const Color grey6 = Color(0xFFB3B3B3);

  static const Color grey7 = Color(0xFFF1E1E1);

  static const Color mountainMeadow = Color(0xFF14DB87);

  static const Color mountainMeadow2 = Color(0xFF18B19B);

  static const Color mountainMeadow3 = Color(0xFF17A8AF);

  static const Color sunglow = Color(0xFFFFC121);

  static const Color sunglow2 = Color(0xFFF8B21A);

  static const Color turquoise = Color(0xFF4BE0C5);

  static const Color turquoise2 = Color(0xFF81F7F3);

  static const Color summerSky = Color(0xFF1AB4D6);

  static const Color summerSky2 = Color(0xFF3B99FC);

  static const Color pink1 = Color(0xFFFF5783);

  static const Color pink2 = Color(0xFFCE1B46);

  static const Color pink3 = Color(0xFFB8165A);

  static const Color yellow = Color(0xFFFFECBB);

  static const Color yellow1 = Color(0xFFFFFC68);

  static const Color yellow2 = Color(0xFFFBCC2F);

  static const Color yellow3 = Color(0xFFFFE947);

  static const Color yellow4 = Color(0xFFFFAF00);

  static const Color purple = Color(0xFFE727D3);

}
