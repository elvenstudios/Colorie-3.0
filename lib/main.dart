import 'package:colorie_three/providers/journal_provider.dart';
import 'package:colorie_three/screens/authentication.dart';
import 'package:colorie_three/screens/home.dart';
import 'package:colorie_three/screens/search.dart';
import 'package:colorie_three/screens/settings.dart';
import 'package:colorie_three/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

  int _selectedTab = 0;
  bool _authenticated = false;

  // handle changing tabs
  void _onTabTap(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

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
            _selectedTab = 0;
            _authenticated = true;
          });
        }
      }
    });
  }

  // list of screens that the tabs represent
  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SearchScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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
                    print(snapshot.error);
                    return Text('Oops, something went wrong');
                  }

                  // if it's done, load the app
                  if (snapshot.connectionState == ConnectionState.done) {
                    // set the auth listeners
                    _registerAuthListeners();
                    return Scaffold(
                      body: Center(
                        child: _authenticated ? _widgetOptions.elementAt(_selectedTab) : AuthenticationScreen(),
                      ),
                      bottomNavigationBar: _authenticated
                          ? BottomNavigationBar(
                              items: const <BottomNavigationBarItem>[
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.face),
                                  label: 'Journal',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.control_point),
                                  label: 'Search',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.settings),
                                  label: 'Settings',
                                ),
                              ],
                              currentIndex: _selectedTab,
                              selectedItemColor: Colors.deepPurple,
                              onTap: _onTabTap,
                              elevation: 0,
                            )
                          : null,
                    );
                  }

                  // otherwise show the splash screen
                  return SplashScreen();
                });
          }),
    );
  }
}
