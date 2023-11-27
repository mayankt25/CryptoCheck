import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const apiUrl = 'https://rest.coinapi.io/v1/exchangerate';
String? key = dotenv.env['API_KEY'];

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<dynamic> getCoinData(currency) async {
    Map<String, String> coinPrices = {};
    for(String crypto in cryptoList){
      String url = '$apiUrl/$crypto/$currency?apikey=$key';
      http.Response response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        coinPrices[crypto] = data['rate'].toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem in getting the rates';
      }
    }
    return coinPrices;
  }
}
