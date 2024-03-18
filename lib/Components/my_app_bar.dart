import 'package:flutter/material.dart';

class my_app_bar extends StatelessWidget implements PreferredSizeWidget{
  final String title;

  const my_app_bar({ Key? key, required this.title}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      iconTheme: const IconThemeData(
          color:Colors.orange
      ),
      backgroundColor: Colors.grey[200],
      titleTextStyle: const TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 17),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60.0);
}
