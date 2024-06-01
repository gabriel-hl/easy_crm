import 'package:easy_crm/screens/home_page/home_page_screen.dart';
import 'package:easy_crm/util/database_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: unused_local_variable
  final DB db = DB.instance;
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy CRM',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[Locale('pt', 'BR')],
      themeMode: ThemeMode.light,
      theme: ThemeData(
        colorSchemeSeed: Colors.lightGreen,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.lightGreen,
        brightness: Brightness.dark,
      ),
      home: const HomePageScreen(),
    );
  }
}
