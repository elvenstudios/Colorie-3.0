import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorie_three/models/entry.dart';
import 'package:colorie_three/models/journal.dart';
import 'package:colorie_three/providers/journal_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// renders the journal entries
  Widget _renderEntries(BuildContext context, AsyncSnapshot snapshot) {
    Journal journal = Provider.of<JournalProvider>(context).journal;

    QuerySnapshot snap = snapshot.data;
    return Column(
      children: [
        ...journal.mapEntries(snap.docs).map((Entry entry) {
          return Text('${entry.count} x ${entry.food.name} -- Color: ${entry.food.colorName}');
        }).toList()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Journal journal = Provider.of<JournalProvider>(context).journal;

    return SafeArea(
      child: Container(
        child: StreamBuilder<Object>(
          stream: journal.entries(),
          builder: (context, snapshot) {
            if (snapshot.hasData && !snapshot.hasError && snapshot.data != null) {
              return _renderEntries(context, snapshot);
            } else if (snapshot.hasError) {
              return Text('Something went wrong, please try again later...');
            }
            return Container();
          },
        ),
      ),
    );
  }
}
