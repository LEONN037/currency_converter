import 'package:flutter/material.dart';
import 'package:exchange/screens/home_screen.dart';

void main() {
  runApp(CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      home: HomeScreen(),
    );
  }
}
