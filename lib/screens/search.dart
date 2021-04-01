import 'package:colorie_three/models/entry.dart';
import 'package:colorie_three/models/food.dart';
import 'package:colorie_three/models/journal.dart';
import 'package:colorie_three/models/liquid.dart';
import 'package:colorie_three/models/solid.dart';
import 'package:colorie_three/models/soup.dart';
import 'package:colorie_three/providers/journal_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  int _selected = 0;

  final TextEditingController nameController = TextEditingController(); // food name
  final TextEditingController caloriesController = TextEditingController(); // food calories
  final TextEditingController volumeController = TextEditingController(); // grams or milliliters
  final TextEditingController servingsController = TextEditingController()..text = '1'; // number of servings

  void _setSelected(int val, StateSetter setModalState) {
    setModalState(() {
      _selected = val;
    });
  }

  bool _showButton() {
    return nameController.text != '' &&
        caloriesController.text != '' &&
        volumeController.text != '' &&
        servingsController.text != '' &&
        double.parse(servingsController.text) > 0;
  }

  Color _getFoodColor() {
    if (caloriesController.text != '' && volumeController.text != '') {
      return _calculateFood().color;
    }
    return Colors.deepPurple;
  }

  // creates a food from the given inputs
  Food _calculateFood() {
    switch (_selected) {
      case 1:
        return Liquid(
          name: nameController.text,
          grams: double.parse(volumeController.text),
          calories: double.parse(caloriesController.text),
        );
        break;
      case 2:
        return Soup(
          name: nameController.text,
          grams: double.parse(volumeController.text),
          calories: double.parse(caloriesController.text),
        );
        break;
      case 0:
      default:
        return Solid(
          name: nameController.text,
          grams: double.parse(volumeController.text),
          calories: double.parse(caloriesController.text),
        );
    }
  }

  // shows a dialog for new features coming soon
  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Feature'),
          content: Text('This feature is coming soon!'),
          actions: <Widget>[
            TextButton(
              child: Text('Nice!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomSheet(BuildContext context, Journal journal) {
    return StatefulBuilder(builder: (BuildContext context, StateSetter stateSetter) {
      return SafeArea(
        child: Container(
          color: Colors.white70,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                      labelText: 'Name',
                    ),
                    autofocus: true,
                    autocorrect: true,
                    onChanged: (String value) => stateSetter(
                      () {/* set state to refresh the UI for the button color */},
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: Text(
                        'Solid',
                        style: TextStyle(color: Colors.white),
                      ),
                      selected: _selected == 0,
                      disabledColor: Colors.grey,
                      selectedColor: Colors.deepPurple,
                      onSelected: (bool selected) => _setSelected(0, stateSetter),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ChoiceChip(
                        label: Text(
                          'Liquid',
                          style: TextStyle(color: Colors.white),
                        ),
                        selected: _selected == 1,
                        disabledColor: Colors.grey,
                        selectedColor: Colors.deepPurple,
                        onSelected: (bool selected) => _setSelected(1, stateSetter),
                      ),
                    ),
                    ChoiceChip(
                      label: Text(
                        'Soup',
                        style: TextStyle(color: Colors.white),
                      ),
                      selected: _selected == 2,
                      disabledColor: Colors.grey,
                      selectedColor: Colors.deepPurple,
                      onSelected: (bool selected) => _setSelected(2, stateSetter),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: TextField(
                    controller: caloriesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Calories',
                    ),
                    onChanged: (String value) => stateSetter(
                      () {/* set state to refresh the UI for the button color */},
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: TextField(
                    controller: volumeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: _selected == 0 ? 'Grams' : 'Milliliters',
                    ),
                    onChanged: (String value) => stateSetter(
                      () {/* set state to refresh the UI for the button color */},
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                  child: TextField(
                    controller: servingsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Servings',
                    ),
                    onChanged: (String value) => stateSetter(
                      () {/* set state to refresh the UI for the button color */},
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        onPressed: _showButton()
                            ? () {
                                journal.addEntry(
                                  Entry(
                                    count: double.parse(servingsController.text),
                                    food: _calculateFood(),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            : null,
                        child: Text('Submit'),
                        color: Colors.deepPurple,
                        disabledColor: Colors.deepPurple.withOpacity(.25),
                        textColor: Colors.white,
                        disabledTextColor: Colors.white, // TODO: disable button until form is filled
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: _getFoodColor(),
                thickness: 4,
                indent: 16,
                endIndent: 16,
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Journal journal = Provider.of<JournalProvider>(context).journal;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (isDialOpen.value) {
            isDialOpen.value = false;
            return false;
          }
          return true;
        },
        child: Container(
          child: SafeArea(
            child: Center(child: Text('Log Some Food')),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        openCloseDial: isDialOpen,
        icon: Icons.add,
        activeIcon: Icons.close,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurpleAccent.shade400,
        children: [
          SpeedDialChild(
            child: Icon(
              Icons.calculate_rounded,
              color: Colors.white,
            ),
            backgroundColor: Colors.deepPurpleAccent,
            label: 'Enter Manually',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) => _buildBottomSheet(context, journal),
                isScrollControlled: true,
              );
            },
          ),
          SpeedDialChild(
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
            backgroundColor: Colors.deepPurpleAccent.shade200,
            label: 'Scan a Barcode',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: _showDialog,
          ),
          SpeedDialChild(
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
            backgroundColor: Colors.deepPurpleAccent.shade100,
            label: 'Search Online',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: _showDialog,
          ),
        ],
      ),
    );
  }
}
