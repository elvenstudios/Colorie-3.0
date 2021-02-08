import 'package:colorie_three/models/food.dart';
import 'package:colorie_three/models/journal.dart';

///
/// An entry into a [Journal].
///
class Entry {
  Entry({this.food, this.count = 1});

  final Food food;
  final int count;
}
