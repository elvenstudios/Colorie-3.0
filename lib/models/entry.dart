import 'package:colorie_three/models/food.dart';
import 'package:colorie_three/models/journal.dart';

///
/// An entry into a [Journal].
///
class Entry {
  Entry({this.food, this.count = 1, this.timestamp, this.id});

  final Food food;
  final int count;
  final String timestamp;
  final String id;

  @override
  String toString() {
    return '${food.name}-$count-$timestamp';
  }

  // returns food calories times entry count
  num get totalCalories {
    return food.calories * count;
  }
}
