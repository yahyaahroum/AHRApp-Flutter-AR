import 'package:flutter/material.dart';
import 'Components/bottom_navigation_bar_component.dart';
import 'Components/costum_button.dart';
import 'Components/drawer_component.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AHR App'),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color:Colors.orange
        ),
        backgroundColor: Colors.grey[100],
        titleTextStyle: const TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 17),

        actions: [
          IconButton(onPressed: () {

            Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
          },
              icon: const Icon(Icons.exit_to_app))
        ],

      ),
      body:
      ListView(


      ),
      drawer: const DrawerComponent(),
      bottomNavigationBar: const BottomNavigationBarComponenent(),
    );
  }
}
