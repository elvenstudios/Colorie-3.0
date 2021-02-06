import 'package:colorie_three/widgets/log_in_view.dart';
import 'package:colorie_three/widgets/register_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Colorie'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Log In',
              ),
              Tab(
                text: 'Register',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LogInView(),
            RegisterView(),
          ],
        ),
      ),
    );
  }
}
