import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyektes2/user_manage.dart';
import 'services/api_service.dart'; 

class Exchange extends StatefulWidget {
  const Exchange({Key? key}) : super(key: key);

  @override
  _ExchangeState createState() => _ExchangeState();
}

class _ExchangeState extends State<Exchange> {
  final TextEditingController _amountController = TextEditingController();

  String _sourceCurrency = 'USD';
  String _targetCurrency = 'EUR';
  double _result = 0.0;
  List<String> _conversionHistory = [];
  final ApiService _apiService = ApiService();

  final List<Map<String, String>> _currencies = [
    {'code': 'USD', 'country': 'US'},
    {'code': 'EUR', 'country': 'EU'},
    {'code': 'IDR', 'country': 'ID'},
    {'code': 'GBP', 'country': 'GB'},
    {'code': 'AUD', 'country': 'AU'},
    {'code': 'JPY', 'country': 'JP'},
    {'code': 'CAD', 'country': 'CA'},
    {'code': 'CHF', 'country': 'CH'},
    {'code': 'CNY', 'country': 'CN'},
    {'code': 'SEK', 'country': 'SE'},
    {'code': 'NZD', 'country': 'NZ'},
    {'code': 'MXN', 'country': 'MX'},
    {'code': 'SGD', 'country': 'SG'},
    {'code': 'HKD', 'country': 'HK'},
    {'code': 'NOK', 'country': 'NO'},
    {'code': 'KRW', 'country': 'KR'},
    {'code': 'TRY', 'country': 'TR'},
    {'code': 'INR', 'country': 'IN'},
    {'code': 'RUB', 'country': 'RU'},
    {'code': 'BRL', 'country': 'BR'},
    {'code': 'ZAR', 'country': 'ZA'}
  ];

  void _handleConvert() async {
    String amountText = _amountController.text;
    double? amount = double.tryParse(amountText);
    if (amount != null) {
      try {
        _amountController.clear();
        double conversionRate = await _apiService.getConversionRate(_sourceCurrency, _targetCurrency);
        
        double result = amount * conversionRate;
        setState(() {
          _result = result;
          _conversionHistory.insert(0, '${amount.toStringAsFixed(2)} $_sourceCurrency = ${result.toStringAsFixed(2)} $_targetCurrency');
        });
      } catch (e) {
        print('Failed to fetch conversion rate: $e');
        setState(() {
          _result = 0.0;
        });
      }
    } else {
     
      setState(() {
        _result = 0.0;
      });
      print('Please enter a valid number');
    }
  }

  @override
  Widget build(BuildContext context) {

  void signUserOut() {
      FirebaseAuth.instance.signOut();
      UserManager.updateUser(null);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text('Currency Exchange', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
            color: Colors.black,
          ),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: double.infinity, 
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Enter Amount',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
                ),
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'From Currency',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
                    ),
                    DropdownButton<String>(
                      value: _sourceCurrency,
                      onChanged: (String? newValue) {
                        setState(() {
                          _sourceCurrency = newValue!;
                        });
                      },
                      items: _currencies.map<DropdownMenuItem<String>>((Map<String, String> currency) {
                        return DropdownMenuItem<String>(
                          value: currency['code'],
                          child: Text(currency['code']!),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'To Currency',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
                    ),
                    DropdownButton<String>(
                      value: _targetCurrency,
                      onChanged: (String? newValue) {
                        setState(() {
                          _targetCurrency = newValue!;
                        });
                      },
                      items: _currencies.map<DropdownMenuItem<String>>((Map<String, String> currency) {
                        return DropdownMenuItem<String>(
                          value: currency['code'],
                          child: Text(currency['code']!),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _handleConvert,
                    child: Text('Exchange'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white), 
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Result: ${_result.toStringAsFixed(2)} $_targetCurrency',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                SizedBox(height: 20),
                Text(
                  'Conversion History:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _conversionHistory.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${index + 1}. ${_conversionHistory[index]}'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
