import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorie_three/models/entry.dart';
import 'package:colorie_three/models/solid.dart';
import 'package:firebase_auth/firebase_auth.dart';

///
/// A log of [Entry]'s.
///
class Journal {
  List<Entry> _entries = [];

  Future<List<Entry>> getEntries() async {
    // if the entries are already there, just return them.
    if (_entries.isNotEmpty) {
      return _entries;
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String userEmail = FirebaseAuth.instance.currentUser.email;

    // access all journals
    DocumentReference journals = firestore.collection('journals').doc(userEmail);
    // access the all entries for the given users journal
    QuerySnapshot userJournalEntries = await journals.collection('entries').get();

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
}
