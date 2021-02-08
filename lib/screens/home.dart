import 'package:colorie_three/models/entry.dart';
import 'package:colorie_three/models/journal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Journal journal = Journal();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Text('Welcome ${FirebaseAuth.instance.currentUser.email ?? 'Anon'}'),
            FutureBuilder(
              future: journal.getEntries(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Text('Please try again later...');
                } else if (snapshot.hasData) {
                  List<Entry> entries = snapshot.data;
                  return Column(
                    children: [
                      ...entries.map((Entry entry) {
                        return Text('${entry.count} x ${entry.food.name}');
                      }).toList()
                    ],
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
