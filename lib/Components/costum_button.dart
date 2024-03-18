import 'package:flutter/material.dart';

class CostumButton extends StatelessWidget {
  final String texteButton;
  final void Function()? onPress;
  const CostumButton({Key? key, required this.texteButton, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialButton(
      height: 40,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.orange,
      textColor: Colors.white,
      onPressed: onPress,
      child: Text(texteButton),);
  }
}
