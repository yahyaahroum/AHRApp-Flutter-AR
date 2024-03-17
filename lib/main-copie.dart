import 'package:flutter_gen_l10n_example/clients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'views/home.dart';
import 'views/settings.dart';

import 'model/locale.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static int selectedIndex=0;
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleModel(),
      child: Consumer<LocaleModel>(
        builder: (context, localeModel, child) => MaterialApp(
          title: 'Recipes',
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          //locale: localeModel.locale,
          locale: Locale("ar"),
          routes: {
            '/': (context) => const Clients(),
            '/settings': (context) => const Settings(),
          },
          initialRoute: '/',
        ),
      ),
    );
  }
}
