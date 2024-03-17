import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class ErrorDialog extends StatelessWidget {

  const ErrorDialog({Key? key});

  @override
  Widget build(BuildContext context) {
    return     PanaraInfoDialog.showAnimatedGrow(
      context,
      title: "Erreur",
      message: "Vous devez valider votre compte en cliquant sur le lien envoyé à votre adresse email",
      buttonText: "Ok",
      onTapDismiss: () {
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.error,
      barrierDismissible: false, // optional parameter (default is true)
    );
  }
}
