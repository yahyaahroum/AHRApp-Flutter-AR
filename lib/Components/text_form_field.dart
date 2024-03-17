import 'package:flutter/material.dart';

class TextFormFieldEx extends StatelessWidget {
final String myhintText;
final TextEditingController myController;
  const TextFormFieldEx({super.key, required this.myhintText, required this.myController});

  @override
  Widget build(BuildContext context) {
    return   TextFormField(
      controller: myController,
      decoration: InputDecoration(
          hintText:myhintText,
          hintStyle: const TextStyle(fontSize: 14,color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 2,horizontal: 20),
          filled: true,
          fillColor: Colors.grey[200],
          prefixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.grey)
          ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 3, color: Colors.orangeAccent),
          borderRadius: BorderRadius.circular(15),
        ),
      ),);
  }
}
