import 'package:colorie_three/models/food.dart';

///
/// A [Food] class that represents a liquid piece of food.
///
class Liquid extends Food {
  Liquid(this.name, this.calories, this.grams, this.ml);
  double green = .3;
  double yellow = .5;
  double red = double.infinity;

  String name;
  num calories;
  num grams;
  num ml;
}
