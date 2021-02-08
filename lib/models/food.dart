import 'package:flutter/cupertino.dart';
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
      return Colors.green;
    } else if (density <= yellow) {
      return Colors.yellow;
    }

    return Colors.red;
  }
}
