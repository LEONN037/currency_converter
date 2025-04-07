import 'package:flutter/material.dart';
import 'package:exchange/services/currency_service.dart';

class CurrencyConverterWidget extends StatefulWidget {
  @override
  _CurrencyConverterWidgetState createState() =>
      _CurrencyConverterWidgetState();
}

class _CurrencyConverterWidgetState extends State<CurrencyConverterWidget> {
  final _amountController = TextEditingController(text: "1");
  final _pairController = TextEditingController(text: "EUR/USD");

  final FocusNode _pairFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

  double? _rate;
  String _base = "EUR";
  String _target = "USD";
  String _convertedValue = '';
  bool _loading = false;

  final CurrencyService _service = CurrencyService();

  @override
  void initState() {
    super.initState();
    _fetchRate();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _pairController.dispose();
    _pairFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _fetchRate() async {
    setState(() => _loading = true);
    final rate = await _service.fetchExchangeRate(_base, _target);
    if (rate != null) {
      setState(() {
        _rate = rate;
        _updateConvertedValue();
      });
    }
    setState(() => _loading = false);
  }

  void _updateConvertedValue() {
    final input = double.tryParse(_amountController.text);
    if (input != null && _rate != null) {
      final result = input * _rate!;
      setState(() {
        _convertedValue = result.toStringAsFixed(2);
      });
    } else {
      setState(() {
        _convertedValue = '';
      });
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _base;
      _base = _target;
      _target = temp;
      _pairController.text = '$_base/$_target';
    });
    _fetchRate();
  }

  void _parseAndSetPair() {
    final pair = _pairController.text.toUpperCase().split('/');
    if (pair.length == 2) {
      _base = pair[0];
      _target = pair[1];
      _fetchRate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _pairController,
            focusNode: _pairFocusNode,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Currency Pair (e.g. EUR/USD)',
              labelStyle: TextStyle(fontSize: 18)
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(_pairFocusNode);
            },
            onSubmitted: (_) => _parseAndSetPair(),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  focusNode: _amountFocusNode,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      labelText: 'Amount ($_base)',
                      labelStyle: TextStyle(fontSize: 18)),
                  onTap: () {
                    FocusScope.of(context).requestFocus(_amountFocusNode);
                  },
                  onChanged: (_) => _updateConvertedValue(),
                ),
              ),
              IconButton(
                icon: Icon(Icons.swap_horiz),
                onPressed: _swapCurrencies,
                tooltip: 'Swap',
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: _fetchRate,
                tooltip: 'Refresh Rate',
              ),
            ],
          ),
          SizedBox(height: 24),
          if (_loading)
            Center(child: CircularProgressIndicator())
          else if (_rate != null)
            Text(
              'Rate: 1 $_base = $_rate $_target\nConverted: $_convertedValue $_target',
              style: TextStyle(fontSize: 22),
            )
          else
            Text('Could not fetch rate', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
