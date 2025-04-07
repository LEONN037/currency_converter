import 'package:flutter/material.dart';
import 'package:exchange/widgets/currency_converter_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CurrencyConverterWidget(),
      ),
    );
  }
}
