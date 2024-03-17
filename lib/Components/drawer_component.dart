import 'package:flutter/material.dart';
import '../main.dart';

class DrawerComponent extends StatefulWidget {
  const DrawerComponent({Key? key}) : super(key: key);

  @override
  _DrawerComponentState createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  String userConn="";
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.orange);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: About',
      style: optionStyle,
    ),
    Text(
      'Index 2: Products',
      style: optionStyle,
    ),
    (Text(
      'Index 3: Contact',
      style: optionStyle,
    ))
  ];

  void _onItemTapped(int index) {
    setState(() {
      MyApp.selectedIndex = index;

    });
  }




  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: ListView(
        children: [
          Image.asset('assets/images/logo.png',width: 120,height: 120,),
          Center(child: Text('aaaaa',style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.orange))),

          ListTile(
            selected: MyApp.selectedIndex==0,
            leading: const Icon(Icons.home),
            title: const Text("Acceuil"),
            onTap: (
                ) {
              _onItemTapped(0);
            },
          ),
          ListTile(
            selected: MyApp.selectedIndex==1,
            leading: const Icon(Icons.account_box),
            title: const Text("Clients"),
            onTap: () {
              Navigator.of(context).pushNamed('clients');
              _onItemTapped(1);
            },
          ),
          ListTile(
            selected: MyApp.selectedIndex==2,
            leading: const Icon(Icons.money),
            title: const Text("Chéques"),
            onTap: () {
              Navigator.of(context).pushNamed('cheques');
              _onItemTapped(2);
            },
          ),
          ListTile(
            selected: MyApp.selectedIndex==3,
            leading: const Icon(Icons.contact_mail),
            title: const Text("Utilisateurs"),
            onTap: () {
              _onItemTapped(3);
            },
          ),
          ListTile(
            selected: MyApp.selectedIndex==4,
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Se déconnecter"),
            onTap: ()  {
              Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
              _onItemTapped(4);

            },
          ),ListTile(
            selected: MyApp.selectedIndex==4,
            leading: const Icon(Icons.ad_units),
            title: const Text("Test"),
            onTap: ()  {
              Navigator.of(context).pushNamedAndRemoveUntil("test", (route) => false);
              _onItemTapped(4);

            },
          )
        ],
      ),
    );
  }
}
