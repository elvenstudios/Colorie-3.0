import 'package:colorie_three/models/food.dart';

///
/// A [Food] class that represents a solid piece of food.
///
class Solid extends Food {
  Solid({this.name, this.calories, this.grams, this.ml});
  double green = .9;
  double yellow = 2.4;
  double red = double.infinity;

  String name;
  num calories;
  num grams;
  num ml;
}
