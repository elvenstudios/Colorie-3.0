import 'package:colorie_three/providers/journal_provider.dart';
import 'package:colorie_three/screens/authentication.dart';
import 'package:colorie_three/screens/home.dart';
import 'package:colorie_three/screens/settings.dart';
import 'package:colorie_three/screens/splash.dart';
import 'package:colorie_three/styles/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv.load();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  bool _authenticated = false;

  // adds listeners for auth status changes
  void _registerAuthListeners() {
    final FirebaseAuth auth = FirebaseAuth.instance;

    auth.authStateChanges().listen((User user) {
      if (user == null) {
        if (_authenticated) {
          setState(() {
            _authenticated = false;
          });
        }
      } else {
        if (!_authenticated) {
          setState(() {
            _authenticated = true;
          });
        }
      }
    });
  }

  // list of screens that the tabs represent
  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
//    SearchScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: backgroundColor,
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => JournalProvider()),
          ],
          builder: (BuildContext context, _) {
            return FutureBuilder(
                future: _initialization,
                builder: (context, snapshot) {
                  // handle firebase init errors
                  if (snapshot.hasError) {
                    return Text('Oops, something went wrong');
                  }

                  // if it's done, load the app
                  if (snapshot.connectionState == ConnectionState.done) {
                    // set the auth listeners
                    _registerAuthListeners();
                    return Scaffold(
                      backgroundColor: backgroundColor,
                      body: Center(
                        child: _authenticated ? HomeScreen() : AuthenticationScreen(),
                      ),
                    );
                  }

                  // otherwise show the splash screen
                  return SplashScreen();
                });
          }),
    );
  }
}
