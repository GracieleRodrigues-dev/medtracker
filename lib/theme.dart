// ignore_for_file: use_full_hex_values_for_flutter_colors

import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278217322),
      surfaceTint: Color(4278217322),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4288475632),
      onPrimaryContainer: Color(4278198304),
      secondary: Color(4278217322),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4288475632),
      onSecondaryContainer: Color(4278198304),
      tertiary: Color(4278217322),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4288475632),
      onTertiaryContainer: Color(4278198304),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      surface: Color(4294572543),
      onSurface: Color(4279901216),
      onSurfaceVariant: Color(4282337608),
      outline: Color(4285495673),
      outlineVariant: Color(4290693576),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281217078),
      inversePrimary: Color(4286633428),
      primaryFixed: Color(4288475632),
      onPrimaryFixed: Color(4278198304),
      primaryFixedDim: Color(4286633428),
      onPrimaryFixedVariant: Color(4278210384),
      secondaryFixed: Color(4288475632),
      onSecondaryFixed: Color(4278198304),
      secondaryFixedDim: Color(4286633428),
      onSecondaryFixedVariant: Color(4278210384),
      tertiaryFixed: Color(4288475632),
      onTertiaryFixed: Color(4278198304),
      tertiaryFixedDim: Color(4286633428),
      onTertiaryFixedVariant: Color(4278210384),
      surfaceDim: Color(4292467168),
      surfaceBright: Color(4294572543),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294177786),
      surfaceContainer: Color(4293783028),
      surfaceContainerHigh: Color(4293453806),
      surfaceContainerHighest: Color(4293059305),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278209355),
      surfaceTint: Color(4278217322),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4280516993),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4278209355),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4280516993),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278209355),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4280516993),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      surface: Color(4294572543),
      onSurface: Color(4279901216),
      onSurfaceVariant: Color(4282074436),
      outline: Color(4283916641),
      outlineVariant: Color(4285758844),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281217078),
      inversePrimary: Color(4286633428),
      primaryFixed: Color(4280516993),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278216551),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4280516993),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4278216551),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4280516993),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4278216551),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292467168),
      surfaceBright: Color(4294572543),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294177786),
      surfaceContainer: Color(4293783028),
      surfaceContainerHigh: Color(4293453806),
      surfaceContainerHighest: Color(4293059305),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(4278200103),
      surfaceTint: Color(4278217322),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4278209355),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4278200103),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4278209355),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278200103),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4278209355),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      surface: Color(4294572543),
      onSurface: Color(4278190080),
      onSurfaceVariant: Color(4280034853),
      outline: Color(4282074436),
      outlineVariant: Color(4282074436),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281217078),
      inversePrimary: Color(4289133562),
      primaryFixed: Color(4278209355),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278203187),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4278209355),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4278203187),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4278209355),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4278203187),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292467168),
      surfaceBright: Color(4294572543),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294177786),
      surfaceContainer: Color(4293783028),
      surfaceContainerHigh: Color(4293453806),
      surfaceContainerHighest: Color(4293059305),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4286633428),
      surfaceTint: Color(4286633428),
      onPrimary: Color(4278204215),
      primaryContainer: Color(4278210384),
      onPrimaryContainer: Color(4288475632),
      secondary: Color(4286633428),
      onSecondary: Color(4278204215),
      secondaryContainer: Color(4278210384),
      onSecondaryContainer: Color(4288475632),
      tertiary: Color(4286633428),
      onTertiary: Color(4278204215),
      tertiaryContainer: Color(4278210384),
      onTertiaryContainer: Color(4288475632),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      surface: Color(4279309080),
      onSurface: Color(4293059305),
      onSurfaceVariant: Color(4290693576),
      outline: Color(4287140754),
      outlineVariant: Color(4282337608),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059305),
      inversePrimary: Color(4278217322),
      primaryFixed: Color(4288475632),
      onPrimaryFixed: Color(4278198304),
      primaryFixedDim: Color(4286633428),
      onPrimaryFixedVariant: Color(4278210384),
      secondaryFixed: Color(4288475632),
      onSecondaryFixed: Color(4278198304),
      secondaryFixedDim: Color(4286633428),
      onSecondaryFixedVariant: Color(4278210384),
      tertiaryFixed: Color(4288475632),
      onTertiaryFixed: Color(4278198304),
      tertiaryFixedDim: Color(4286633428),
      onTertiaryFixedVariant: Color(4278210384),
      surfaceDim: Color(4279309080),
      surfaceBright: Color(4281809214),
      surfaceContainerLowest: Color(4278980115),
      surfaceContainerLow: Color(4279901216),
      surfaceContainer: Color(4280164389),
      surfaceContainerHigh: Color(4280822319),
      surfaceContainerHighest: Color(4281546042),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4286896600),
      surfaceTint: Color(4286633428),
      onPrimary: Color(4278196762),
      primaryContainer: Color(4282883741),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4286896600),
      onSecondary: Color(4278196762),
      secondaryContainer: Color(4282883741),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4286896600),
      onTertiary: Color(4278196762),
      tertiaryContainer: Color(4282883742),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      surface: Color(4279309080),
      onSurface: Color(4294703871),
      onSurfaceVariant: Color(4290956748),
      outline: Color(4288390564),
      outlineVariant: Color(4286285189),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059305),
      inversePrimary: Color(4278210897),
      primaryFixed: Color(4288475632),
      onPrimaryFixed: Color(4278195220),
      primaryFixedDim: Color(4286633428),
      onPrimaryFixedVariant: Color(4278205757),
      secondaryFixed: Color(4288475632),
      onSecondaryFixed: Color(4278195220),
      secondaryFixedDim: Color(4286633428),
      onSecondaryFixedVariant: Color(4278205757),
      tertiaryFixed: Color(4288475632),
      onTertiaryFixed: Color(4278195220),
      tertiaryFixedDim: Color(4286633428),
      onTertiaryFixedVariant: Color(4278205757),
      surfaceDim: Color(4279309080),
      surfaceBright: Color(4281809214),
      surfaceContainerLowest: Color(4278980115),
      surfaceContainerLow: Color(4279901216),
      surfaceContainer: Color(4280164389),
      surfaceContainerHigh: Color(4280822319),
      surfaceContainerHighest: Color(4281546042),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(4293591038),
      surfaceTint: Color(4286633428),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4286896600),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4293591038),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4286896600),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4293591038),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4286896600),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      surface: Color(4279309080),
      onSurface: Color(4294967295),
      onSurfaceVariant: Color(4294180348),
      outline: Color(4290956748),
      outlineVariant: Color(4290956748),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4293059305),
      inversePrimary: Color(4278202416),
      primaryFixed: Color(4288738805),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4286896600),
      onPrimaryFixedVariant: Color(4278196762),
      secondaryFixed: Color(4288738805),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4286896600),
      onSecondaryFixedVariant: Color(4278196762),
      tertiaryFixed: Color(4288738805),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4286896600),
      onTertiaryFixedVariant: Color(4278196762),
      surfaceDim: Color(4279309080),
      surfaceBright: Color(4281809214),
      surfaceContainerLowest: Color(4278980115),
      surfaceContainerLow: Color(4279901216),
      surfaceContainer: Color(4280164389),
      surfaceContainerHigh: Color(4280822319),
      surfaceContainerHighest: Color(4281546042),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.surface,
     canvasColor: colorScheme.surface,
  );

  /// Custom Color 1
  static const customColor1 = ExtendedColor(
    seed: Color(4278981408),
    value: Color(4278981408),
    light: ColorFamily(
      color: Color(4282539665),
      onColor: Color(4294967295),
      colorContainer: Color(4292338431),
      onColorContainer: Color(4278197055),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(4282539665),
      onColor: Color(4294967295),
      colorContainer: Color(4292338431),
      onColorContainer: Color(4278197055),
    ),
    lightHighContrast: ColorFamily(
      color: Color(4282539665),
      onColor: Color(4294967295),
      colorContainer: Color(4292338431),
      onColorContainer: Color(4278197055),
    ),
    dark: ColorFamily(
      color: Color(4289447935),
      onColor: Color(4279054175),
      colorContainer: Color(4280895095),
      onColorContainer: Color(4292338431),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(4289447935),
      onColor: Color(4279054175),
      colorContainer: Color(4280895095),
      onColorContainer: Color(4292338431),
    ),
    darkHighContrast: ColorFamily(
      color: Color(4289447935),
      onColor: Color(4279054175),
      colorContainer: Color(4280895095),
      onColorContainer: Color(4292338431),
    ),
  );

  /// Custom Color 2
  static const customColor2 = ExtendedColor(
    seed: Color(4278604627),
    value: Color(4278604627),
    light: ColorFamily(
      color: Color(4278217322),
      onColor: Color(4294967295),
      colorContainer: Color(4288475632),
      onColorContainer: Color(4278198304),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(4278217322),
      onColor: Color(4294967295),
      colorContainer: Color(4288475632),
      onColorContainer: Color(4278198304),
    ),
    lightHighContrast: ColorFamily(
      color: Color(4278217322),
      onColor: Color(4294967295),
      colorContainer: Color(4288475632),
      onColorContainer: Color(4278198304),
    ),
    dark: ColorFamily(
      color: Color(4286633428),
      onColor: Color(4278204215),
      colorContainer: Color(4278210384),
      onColorContainer: Color(4288475632),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(4286633428),
      onColor: Color(4278204215),
      colorContainer: Color(4278210384),
      onColorContainer: Color(4288475632),
    ),
    darkHighContrast: ColorFamily(
      color: Color(4286633428),
      onColor: Color(4278204215),
      colorContainer: Color(4278210384),
      onColorContainer: Color(4288475632),
    ),
  );

  /// Custom Color 3
  static const customColor3 = ExtendedColor(
    seed: Color(4284675316),
    value: Color(4284675316),
    light: ColorFamily(
      color: Color(4278217322),
      onColor: Color(4294967295),
      colorContainer: Color(4288475632),
      onColorContainer: Color(4278198304),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(4278217322),
      onColor: Color(4294967295),
      colorContainer: Color(4288475632),
      onColorContainer: Color(4278198304),
    ),
    lightHighContrast: ColorFamily(
      color: Color(4278217322),
      onColor: Color(4294967295),
      colorContainer: Color(4288475632),
      onColorContainer: Color(4278198304),
    ),
    dark: ColorFamily(
      color: Color(4286633428),
      onColor: Color(4278204215),
      colorContainer: Color(4278210384),
      onColorContainer: Color(4288475632),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(4286633428),
      onColor: Color(4278204215),
      colorContainer: Color(4278210384),
      onColorContainer: Color(4288475632),
    ),
    darkHighContrast: ColorFamily(
      color: Color(4286633428),
      onColor: Color(4278204215),
      colorContainer: Color(4278210384),
      onColorContainer: Color(4288475632),
    ),
  );

  /// Custom Color 4
  static const customColor4 = ExtendedColor(
    seed: Color(4280601804),
    value: Color(4280601804),
    light: ColorFamily(
      color: Color(4278217322),
      onColor: Color(4294967295),
      colorContainer: Color(4288475632),
      onColorContainer: Color(4278198304),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(4278217322),
      onColor: Color(4294967295),
      colorContainer: Color(4288475632),
      onColorContainer: Color(4278198304),
    ),
    lightHighContrast: ColorFamily(
      color: Color(4278217322),
      onColor: Color(4294967295),
      colorContainer: Color(4288475632),
      onColorContainer: Color(4278198304),
    ),
    dark: ColorFamily(
      color: Color(4286633428),
      onColor: Color(4278204215),
      colorContainer: Color(4278210384),
      onColorContainer: Color(4288475632),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(4286633428),
      onColor: Color(4278204215),
      colorContainer: Color(4278210384),
      onColorContainer: Color(4288475632),
    ),
    darkHighContrast: ColorFamily(
      color: Color(4286633428),
      onColor: Color(4278204215),
      colorContainer: Color(4278210384),
      onColorContainer: Color(4288475632),
    ),
  );


  List<ExtendedColor> get extendedColors => [
    customColor1,
    customColor2,
    customColor3,
    customColor4,
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
