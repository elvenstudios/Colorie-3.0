import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colorie_three/models/entry.dart';
import 'package:colorie_three/models/food.dart';
import 'package:colorie_three/models/journal.dart';
import 'package:colorie_three/models/liquid.dart';
import 'package:colorie_three/models/solid.dart';
import 'package:colorie_three/models/soup.dart';
import 'package:colorie_three/providers/journal_provider.dart';
import 'package:colorie_three/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selected = 0;

  final TextEditingController nameController = TextEditingController(); // food name
  final TextEditingController caloriesController = TextEditingController(); // food calories
  final TextEditingController volumeController = TextEditingController(); // grams or milliliters
  final TextEditingController servingsController = TextEditingController()..text = '1'; // number of servings

  // sets the selected food type
  void _setSelectedFoodType(int val, StateSetter setModalState) {
    setModalState(() {
      _selected = val;
    });
  }

  // determines if I should show the submit button or not
  bool _showButton() {
    return nameController.text != '' &&
        caloriesController.text != '' &&
        volumeController.text != '' &&
        servingsController.text != '' &&
        double.parse(servingsController.text) > 0;
  }

  // gets the color of a food
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
        ) as Food;
        break;
      case 2:
        return Soup(
          name: nameController.text,
          grams: double.parse(volumeController.text),
          calories: double.parse(caloriesController.text),
        ) as Food;
        break;
      case 0:
      default:
        return Solid(
          name: nameController.text,
          grams: double.parse(volumeController.text),
          calories: double.parse(caloriesController.text),
        ) as Food;
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

  // resets the text controllers
  void _resetTextControllers() {
    nameController.clear();
    caloriesController.clear();
    volumeController.clear();
    servingsController.clear();
  }

  // renders teh bottom sheet
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
                      onSelected: (bool selected) => _setSelectedFoodType(0, stateSetter),
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
                        onSelected: (bool selected) => _setSelectedFoodType(1, stateSetter),
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
                      onSelected: (bool selected) => _setSelectedFoodType(2, stateSetter),
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
                                _resetTextControllers();
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

  /// renders the journal entries
  Widget _renderEntries(BuildContext context, AsyncSnapshot snapshot) {
    Journal journal = Provider.of<JournalProvider>(context).journal;
    ValueNotifier<bool> isDialOpen = ValueNotifier(false);

    QuerySnapshot snap = snapshot.data;
    List<Entry> children = journal.mapEntries(snap.docs).toList();
    List<Entry> greens = children.where((Entry entry) => entry.food.colorName == 'green').toList();
    List<Entry> yellows = children.where((Entry entry) => entry.food.colorName == 'yellow').toList();
    List<Entry> reds = children.where((Entry entry) => entry.food.colorName == 'red').toList();
    children = [...greens, ...yellows, ...reds];

    if (children.isEmpty) {
      return Container(
        child: Text(
          'You haven\'t logged any food for today',
          style: TextStyle(color: primaryText, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: WillPopScope(
        onWillPop: () async {
          if (isDialOpen.value) {
            isDialOpen.value = false;
            return false;
          }
          return true;
        },
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: children.length,
              itemBuilder: (context, index) {
                Entry entry = children[index];
                return Dismissible(
                  child: ListTile(
                    title: Text(
                      entry.food.name,
                      style: TextStyle(
                        color: primaryText,
                      ),
                    ),
                    subtitle: Text(
                      "${entry.totalCalories} calories",
                      style: TextStyle(
                        color: primaryText,
                      ),
                    ),
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: entry.food.color,
                          ),
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  key: Key(entry.toString()),
                  onDismissed: (DismissDirection direction) => journal.deleteEntry(entry),
                  background: Container(
                    color: darkGrey,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        openCloseDial: isDialOpen,
        icon: Icons.add,
        activeIcon: Icons.close,
        iconTheme: IconThemeData(color: darkGrey),
        backgroundColor: green,
        overlayColor: lightGrey,
        children: [
          SpeedDialChild(
            child: Icon(
              Icons.calculate_rounded,
              color: darkGrey,
            ),
            backgroundColor: green,
            label: 'Enter Manually',
            labelStyle: TextStyle(fontSize: 18.0, color: Colors.black),
            labelBackgroundColor: lightGrey,
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
              color: darkGrey,
            ),
            backgroundColor: green,
            label: 'Scan a Barcode',
            labelStyle: TextStyle(fontSize: 18.0, color: Colors.black),
            labelBackgroundColor: lightGrey,
            onTap: _showDialog,
          ),
          SpeedDialChild(
            child: Icon(
              Icons.search,
              color: darkGrey,
            ),
            backgroundColor: green,
            label: 'Search Online',
            labelStyle: TextStyle(fontSize: 18.0, color: Colors.black),
            labelBackgroundColor: lightGrey,
            onTap: _showDialog,
          ),
        ],
      ),
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
