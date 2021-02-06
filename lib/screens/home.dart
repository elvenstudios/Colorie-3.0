import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Welcome ${FirebaseAuth.instance.currentUser.email ?? 'Anon'}'),
    );
  }
}
