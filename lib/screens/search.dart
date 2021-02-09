import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  int _selected = 0;

  void _setSelected(int val, StateSetter setModalState) {
    setModalState(() {
      _selected = val;
    });
  }

  Widget _buildBottomSheet(BuildContext context) {
    return StatefulBuilder(builder: (BuildContext context, StateSetter stateSetter) {
      return Container(
        padding: MediaQuery.of(context).viewInsets,
        color: Colors.white70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: TextField(
//                controller: emailController, // TODO: text controllers
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
                    labelText: 'Name',
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
//                controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Calories',
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: TextField(
//                controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: _selected == 0 ? 'Grams' : 'Milliliters', // TODO: change based on type selected
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
                      onPressed: () => {},
                      child: Text('Submit'),
                      color: Colors.deepPurple,
                      disabledColor: Colors.deepPurple.withOpacity(.25),
                      textColor: Colors.white,
                      disabledTextColor: Colors.white, // TODO: disable button until form is filled
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
            child: Text('search screen'),
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
                builder: (BuildContext context) => _buildBottomSheet(context),
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
            onTap: () => print('SECOND CHILD'),
          ),
          SpeedDialChild(
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
            backgroundColor: Colors.deepPurpleAccent.shade100,
            label: 'Search Online',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => print('SECOND CHILD'),
          ),
        ],
      ),
    );
  }
}
