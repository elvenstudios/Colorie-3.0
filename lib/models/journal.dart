import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorie_three/models/entry.dart';
import 'package:colorie_three/models/solid.dart';
import 'package:firebase_auth/firebase_auth.dart';

///
/// A log of [Entry]'s.
///
class Journal {
  Stream entries() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // access all journals
    String userEmail = FirebaseAuth.instance.currentUser.email;
    DateTime date = DateTime.now();
    DocumentReference journals = firestore.collection('journals').doc(userEmail);

    // access the all entries for the given users journal
    return journals
        .collection('entries')
        .doc('${date.month}-${date.day}-${date.year}')
        .collection('food')
        .orderBy('timestamp')
        .snapshots();
  }

  // gets the journal entries from firebase
  List<Entry> mapEntries(List<QueryDocumentSnapshot> docs) {
    return docs.map((QueryDocumentSnapshot snapshot) {
      Map<String, dynamic> data = snapshot.data();
      Map<String, dynamic> food = data['food'];

      return Entry(
        count: data['count'],
        food: Solid(
          name: food['name'],
          calories: food['calories'],
          grams: food['grams'],
          ml: food['ml'],
        ),
        timestamp: data['timestamp'],
        id: snapshot.id,
      );
    }).toList();
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
      'timestamp': date.toString()
    });
  }

  void deleteEntry(Entry entry) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String userEmail = FirebaseAuth.instance.currentUser.email;
    DateTime date = DateTime.now();

    // access all journals
    DocumentReference journals = firestore.collection('journals').doc(userEmail);
    // access the all entries for the given users journal
    CollectionReference userJournalEntries = journals.collection('entries');
    userJournalEntries.doc('${date.month}-${date.day}-${date.year}').collection('food').doc(entry.id).delete();
  }
}
