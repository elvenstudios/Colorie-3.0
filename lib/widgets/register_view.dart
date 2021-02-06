import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool passesCheck = false;

  // Watches the text controllers for changes
  // to aid with verifying that both fields
  // have non-null or non-empty values.
  void _watchChanges() {
    emailController.addListener(_checkFieldsHaveValues);
    passwordController.addListener(_checkFieldsHaveValues);
  }

  // handle registration
  Future<void> _register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.value.text,
        password: passwordController.value.text,
      );
    } on FirebaseAuthException catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    }
  }

  // Verifies that both input fields have
  // non-null, non-empty, input values.
  bool _checkFieldsHaveValues() {
    String emailValue = emailController.value.text;
    String passwordValue = passwordController.value.text;

    if (emailValue != null && emailValue != '' && passwordValue != null && passwordValue != '') {
      setState(() {
        passesCheck = true;
      });
    } else {
      setState(() {
        passesCheck = false;
      });
    }
    return passesCheck;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _watchChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: TextField(
            controller: emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: MaterialButton(
            onPressed: _checkFieldsHaveValues() ? _register : null,
            child: Text('Register'),
            color: Colors.deepPurple,
            disabledColor: Colors.deepPurple.withOpacity(.25),
            textColor: Colors.white,
            disabledTextColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
