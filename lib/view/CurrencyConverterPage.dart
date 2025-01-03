import 'package:flutter/material.dart';
import 'package:travel_lanka/widget/CurrencyConverter.dart';
import 'package:travel_lanka/widget/CustomDrawer.dart';
class CurrencyConverterPage extends StatelessWidget {
  const CurrencyConverterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.redAccent[700],
          iconTheme: const IconThemeData(color: Colors.white)
      ),
      //drawer: CustomDrawer(),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Convert currencies easily',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Use this tool to convert between different currencies for your trip.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              CurrencyConverter(),
            ],
          ),
        ),
      ),
    );
  }
}

