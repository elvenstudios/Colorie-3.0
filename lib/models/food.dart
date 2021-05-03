import 'package:colorie_three/styles/colors.dart' as AppColors;
import 'package:flutter/material.dart';

///
/// A class that represents a basic real life food item.
///
abstract class Food {
  double green;
  double yellow;
  double red;

  String name;
  num calories;
  num grams;
  num ml;

  // gets the color of a given food
  Color get color {
    double density = calories / grams ?? ml;
    if (density <= green) {
      return AppColors.greenFood;
    } else if (density <= yellow) {
      return AppColors.yellowFood;
    }

    return AppColors.redFood;
  }

  String get colorName {
    double density = calories / grams ?? ml;
    if (density <= green) {
      return 'green';
    } else if (density <= yellow) {
      return 'yellow';
    }

    return 'red';
  }
}
