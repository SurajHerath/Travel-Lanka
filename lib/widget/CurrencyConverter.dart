import 'package:flutter/material.dart';

class CurrencyConverter extends StatefulWidget {
  const CurrencyConverter({Key? key}) : super(key: key);

  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'LKR';
  double _result = 0.0;

  final Map<String, double> _exchangeRates = {
    'USD': 1.0,
    'LKR': 320.0,
    'EUR': 0.85,
    'GBP': 0.73,
  };

  void _convertCurrency() {
    if (_amountController.text.isNotEmpty) {
      double amount = double.parse(_amountController.text);
      double fromRate = _exchangeRates[_fromCurrency]!;
      double toRate = _exchangeRates[_toCurrency]!;
      setState(() {
        _result = (amount / fromRate) * toRate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Amount'),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<String>(
              value: _fromCurrency,
              items: _exchangeRates.keys.map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _fromCurrency = newValue!;
                });
              },
            ),
            const Icon(Icons.arrow_forward),
            DropdownButton<String>(
              value: _toCurrency,
              items: _exchangeRates.keys.map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _toCurrency = newValue!;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _convertCurrency,
          child: const Text('Convert'),
        ),
        const SizedBox(height: 16),
        Text(
          'Result: ${_result.toStringAsFixed(2)} $_toCurrency',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

