import 'package:colorie_three/models/food.dart';

///
/// A [Food] class that represents soup type food.
///
class Soup extends Food {
  Soup(this.name, this.calories, this.grams, this.ml);
  double green = .4;
  double yellow = 1.0;
  double red = double.infinity;

  String name;
  num calories;
  num grams;
  num ml;
}
