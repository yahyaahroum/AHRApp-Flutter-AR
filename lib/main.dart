import 'package:flutter_gen_l10n_example/clients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'auth/login.dart';
import 'cheques.dart';
import 'home_page.dart';
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
          title: 'AHR App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          //locale: localeModel.locale,
          locale: const Locale("ar"),
          home:  const Login()  ,
          routes: {
            "login" : (context)=>const Login(),
            "home":(context)=>const HomePage(),
            "cheques":(context)=>const Cheques(),
            "clients":(context)=> const Clients(),
          },
          initialRoute: '/',
        ),
      ),
    );
  }
}
