import 'package:flutter/material.dart';

import 'drawer_component.dart';

class BottomNavigationBarComponenent extends StatefulWidget {
  const BottomNavigationBarComponenent({Key? key}) : super(key: key);

  @override
  _BottomNavigationBarComponenentState createState() =>
      _BottomNavigationBarComponenentState();
}

class _BottomNavigationBarComponenentState
    extends State<BottomNavigationBarComponenent> {
  int _selectedIndex = 0;
  final ScrollController _homeController = ScrollController();

  Widget _listViewBody() {
    return ListView.separated(
        controller: _homeController,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Text(
              'Item $index',
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          thickness: 1,
        ),
        itemCount: 50);
  }
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.open_in_new_rounded),
          label: 'Open Dialog',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: (int index) {
        switch (index) {
          case 0:
          // only scroll to top when current index is selected.
            if (_selectedIndex == index) {
              _homeController.animateTo(
                0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
              );
            }
          case 1:
            DrawerComponent();

        }
        setState(
              () {
            _selectedIndex = index;
          },
        );
      },
    );
}
  void showModal(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Example Dialog'),
        actions: <TextButton>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          )
        ],
      ),
    );
  }
}

