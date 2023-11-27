import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  PriceScreenState createState() => PriceScreenState();
}

class PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = Platform.isIOS ? 'AUD' : 'USD';
  String bTCValue = '?';
  String eTHValue = '?';
  String lTCValue = '?';

  @override
  void initState() {
    super.initState();
    updateCoinData();
  }

  void updateCoinData() async {
    try {
      CoinData coinDataObject = CoinData();
      Map<String, String> coinValues = await coinDataObject.getCoinData(selectedCurrency);
      setState(() {
        bTCValue = coinValues['BTC']!;
        eTHValue = coinValues['ETH']!;
        lTCValue = coinValues['LTC']!;
      });
    } catch (e){
      print(e);
    }
  }

  DropdownButton androidDropdown(){
    List<DropdownMenuItem<String>> currencyDropDownItems = [];
    for(String currency in currenciesList){
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      currencyDropDownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: currencyDropDownItems,
      onChanged: (value){
        setState(() {
          selectedCurrency = value!;
          updateCoinData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker(){
    List<Text> currencyPickerItems = [];
    for(String currency in currenciesList){
      var newItem = Text(currency);
      currencyPickerItems.add(newItem);
    }
    return CupertinoPicker(
      backgroundColor: Colors.purple,
      onSelectedItemChanged: (selectedIndex){
        selectedCurrency = currenciesList[selectedIndex];
        updateCoinData();
      },
      itemExtent: 32.0,
      children: currencyPickerItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('🤑 CryptoCheck')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CryptoCard(crypto: 'BTC', valueInCurrency: bTCValue, selectedCurrency: selectedCurrency),
              CryptoCard(crypto: 'ETH', valueInCurrency: eTHValue, selectedCurrency: selectedCurrency),
              CryptoCard(crypto: 'LTC', valueInCurrency: lTCValue, selectedCurrency: selectedCurrency),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.purple,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    super.key,
    required this.crypto,
    required this.valueInCurrency,
    required this.selectedCurrency,
  });

  final String crypto;
  final String valueInCurrency;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.purpleAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $valueInCurrency $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
