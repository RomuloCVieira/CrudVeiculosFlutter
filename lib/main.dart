import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trabalho/ui/HomePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MaterialApp(
    home: HomePage(),
    title: "Meus Livros",
    debugShowCheckedModeBanner: false,
  ));
}