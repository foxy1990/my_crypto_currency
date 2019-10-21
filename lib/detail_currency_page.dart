import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailCurrencyPage extends StatefulWidget {
  final String currencyId;
  final String currencyName;

  DetailCurrencyPage(this.currencyId, this.currencyName);

  @override
  _DetailCurrencyPageState createState() =>
      _DetailCurrencyPageState(currencyId, currencyName);
}

class _DetailCurrencyPageState extends State<DetailCurrencyPage> {
  final fromTextController = TextEditingController(text: '1');
  final String currencyId;
  final String currencyName;
  Map currencyMap = {};
  List<String> currencies;
  String result;

  Future<Map> futureCurrency;
  _DetailCurrencyPageState(this.currencyId, this.currencyName);

  @override
  void initState() {
    super.initState();
    _loadCurrencies(this.currencyId);
  }

  Future<String> _loadCurrencies(String currencyId) async {
    String cryptoUrl = "https://api.coingecko.com/api/v3/simple/price?ids=" +
        currencyId +
        "&vs_currencies=jpy";
    http.Response response = await http.get(cryptoUrl);
    currencyMap = jsonDecode(response.body);
    currencies = currencyMap.keys.toList();
    result = currencyMap[currencyId]['jpy'].toString();
    setState(() {});
    print("_loadCurrencies" + result);
    return "Success";
  }

  Future<String> _doConversion(String currencyId) async {
    String cryptoUrl = "https://api.coingecko.com/api/v3/simple/price?ids=" +
        currencyId +
        "&vs_currencies=jpy";
    http.Response response = await http.get(cryptoUrl);
    currencyMap = jsonDecode(response.body);
    setState(() {
      result = (double.parse(fromTextController.text) *
              (currencyMap[currencyId]['jpy']))
          .toString();
    });
    print("_doConversion" + result);
    return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Currency Converter"),
      ),
      body: currencies == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 3.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          currencyName,
                          style: TextStyle(fontSize: 20.0, color: Colors.black),
                        ),
                      ),
                      ListTile(
                        title: TextField(
                          controller: fromTextController,
                          style: TextStyle(fontSize: 20.0, color: Colors.black),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_downward),
                        onPressed: () {
                          _doConversion(this.currencyId);
                        },
                      ),
                      ListTile(
                        title: Chip(
                          label: result != null
                              ? Text(
                                  result,
                                  style: Theme.of(context).textTheme.display1,
                                )
                              : Text(""),
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
