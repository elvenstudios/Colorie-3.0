import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorie_three/models/entry.dart';
import 'package:colorie_three/models/solid.dart';
import 'package:firebase_auth/firebase_auth.dart';

///
/// A log of [Entry]'s.
///
class Journal {
  List<Entry> _entries = [];

  // gets the journal entries from firebase
  Future<List<Entry>> getEntries({bool refresh = false}) async {
    // if the entries are already there, just return them.
    if (_entries.isNotEmpty && !refresh) {
      return _entries;
    }

    // reset the entries since we're adding them again below
    _entries = [];

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String userEmail = FirebaseAuth.instance.currentUser.email;
    DateTime date = DateTime.now();

    // access all journals
    DocumentReference journals = firestore.collection('journals').doc(userEmail);
    // access the all entries for the given users journal
    QuerySnapshot userJournalEntries =
        await journals.collection('entries').doc('${date.month}-${date.day}-${date.year}').collection('food').get();

    userJournalEntries.docs.forEach((QueryDocumentSnapshot snapshot) {
      Map<String, dynamic> data = snapshot.data();
      Map<String, dynamic> food = data['food'];

      _entries.add(
        Entry(
          count: data['count'],
          food: Solid(
            name: food['name'],
            calories: food['calories'],
            grams: food['grams'],
            ml: food['ml'],
          ),
        ),
      );
    });

    return _entries;
  }

  // forces a refresh of the entries
  Future<void> refreshEntries() async {
    await getEntries(refresh: true);
  }

  // adds an entry to the journal
  void addEntry(Entry entry) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String userEmail = FirebaseAuth.instance.currentUser.email;
    DateTime date = DateTime.now();

    // access all journals
    DocumentReference journals = firestore.collection('journals').doc(userEmail);
    // access the all entries for the given users journal
    CollectionReference userJournalEntries = journals.collection('entries');

    userJournalEntries.doc('${date.month}-${date.day}-${date.year}').collection('food').add({
      'count': entry.count,
      'food': {
        'name': entry.food.name,
        'calories': entry.food.calories,
        'grams': entry.food.grams,
        'ml': entry.food.ml
      },
    });
  }
}
