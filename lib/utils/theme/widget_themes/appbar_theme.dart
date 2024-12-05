import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 0,
    backgroundColor: TColors.colorPrimary,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: TColors.white, size: TSizes.iconMd),
    actionsIconTheme: IconThemeData(color: TColors.white, size: TSizes.iconMd),
    titleTextStyle: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: TColors.white),
  );
}
