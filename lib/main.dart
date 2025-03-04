import 'package:flutter/material.dart';
import 'package:gqony/theme/prov.dart';
import 'package:provider/provider.dart';
import './resource/nav.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = "gqony";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      debugShowCheckedModeBanner: false,
      home: BottomTabWidget(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      
    );
  }
}
