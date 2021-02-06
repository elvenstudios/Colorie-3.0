import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('this is a settings screen'),
            MaterialButton(
              onPressed: _signOut,
              child: Text('Sign Out'),
              color: Colors.deepPurple,
            )
          ],
        ),
      ),
    );
  }
}
