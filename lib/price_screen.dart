import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'crypto_card.dart';
import 'dart:io' show Platform;

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate/BTC/USD';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();
  String? selectedCurrency = 'BRL';
  late bool style;
  late String image;

  @override
  void initState() {
    super.initState();
    getData();
    initialScrollerStyle();
  }

  void initialScrollerStyle() {
    if (Platform.isIOS) {
      style = true;
      image = 'ios';
    } else if (Platform.isAndroid) {
      style = false;
      image = 'android';
    }
  }

  Widget? scrollerStyle(bool controller) {
    if (controller) {
      List<Text> ioStyleList = [];
      for (String item in currenciesList) {
        ioStyleList.add(Text(item));
      }
      return CupertinoPicker(
        looping: true,
        itemExtent: 30.0,
        onSelectedItemChanged: (selectedIndex) {
          setState(() {
            selectedCurrency = ioStyleList[selectedIndex].data;
            getData();
          });
        },
        children: ioStyleList,
      );
    } else {
      List<DropdownMenuItem<String>> androidStyleList = [];
      for (String name in currenciesList) {
        androidStyleList.add(
          DropdownMenuItem(
            value: name,
            child: Text(name),
          ),
        );
      }
      return DropdownButton<String>(
          dropdownColor: Colors.blueGrey,
          value: selectedCurrency, // Starting value
          items: androidStyleList,
          onChanged: (value) {
            setState(() {
              selectedCurrency = value;
              getData();
            });
          });
    }
  }

  Map<String, String> bitcoinValue = {};

  void getData() async {
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      setState(() {
        bitcoinValue = data;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          bitcoinValue: bitcoinValue[crypto],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('🤑 Coin Ticker'),
        actions: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Text(
                  'Scroll Style: ',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          IconButton(
            splashRadius: 24,
            padding: const EdgeInsets.all(4),
            icon: Image.asset('images/$image.png'),
            onPressed: () {
              setState(() {
                // getData();
                if (style) {
                  style = false;
                  image = 'android';
                } else {
                  style = true;
                  image = 'ios';
                }
              });
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(30.0),
            color: Colors.lightBlue,
            child: scrollerStyle(style),
          ),
        ],
      ),
    );
  }
}
