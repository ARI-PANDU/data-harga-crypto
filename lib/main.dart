import 'package:flutter/material.dart';
import 'api_service.dart';
import 'crypto.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Price App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CryptoListScreen(),
    );
  }
}

class CryptoListScreen extends StatefulWidget {
  @override
  _CryptoListScreenState createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  late Future<List<Crypto>> _futureCryptos;

  @override
  void initState() {
    super.initState();
    _futureCryptos = ApiService().fetchCryptos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Prices'),
      ),
      body: FutureBuilder<List<Crypto>>(
        future: _futureCryptos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load cryptos'));
          } else if (snapshot.hasData) {
            List<Crypto> cryptos = snapshot.data!;
            return ListView.builder(
              itemCount: cryptos.length,
              itemBuilder: (context, index) {
                Crypto crypto = cryptos[index];
                return ListTile(
                  title: Text('${crypto.name} (${crypto.symbol})'),
                  subtitle: Text('USD ${crypto.priceUsd.toStringAsFixed(2)}'),
                );
              },
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
