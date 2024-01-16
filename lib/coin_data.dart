import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart';

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

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = API_KEY;

const Map<String, String> headers = {
  'X-CoinAPI-Key': API_KEY,
};

class CoinData {
  Future getCoinData(String? selectedCurrency) async {
    Map<String, String> cryptoValues = {};
    for (String crypto in cryptoList) {
      String requestURL = '$coinAPIURL/$crypto/$selectedCurrency';
      http.Response response =
          await http.get(Uri.parse(requestURL), headers: headers);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        cryptoValues[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        // ignore: avoid_print
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoValues;
  }
}
