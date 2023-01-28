import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptoss/components/coinChart.dart';
import 'package:cryptoss/components/coinModel.dart';
import 'package:cryptoss/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../provider/firebase_auth_methods.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

class CoinDetailsPage extends StatefulWidget {
  const CoinDetailsPage({
    super.key,
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.currency,
    required this.price,
    required this.change,
    required this.changePercentage,
    required this.high24,
    required this.low24,
    required this.rank,
    required this.pchange,
    required this.pchangePercentage,
    required this.pricechart,
  });

  final String id;
  final String name;
  final String symbol;
  final String imageUrl;
  final String currency;
  final double price;
  final double change;
  final double changePercentage;
  final double high24;
  final double low24;
  final double rank;
  final double pchange;
  final double pchangePercentage;
  final List<double> pricechart;

  @override
  State<CoinDetailsPage> createState() => _CoinDetailsPageState();
}

class _CoinDetailsPageState extends State<CoinDetailsPage> {
  bool coinExists = false;
  int currentIndex = 0;
  String description = '';
  List<PaletteColor>? colors;
  @override
  void initState() {
    checkCoin(widget.name);
    colors = [];
    getCryptocurrencyDefinition(widget.id);
    _updatePalettes(widget.imageUrl);
    super.initState();
  }

  Future<void> getCryptocurrencyDefinition(String id) async {
    final response = await http
        .get(Uri.parse('https://api.coingecko.com/api/v3/coins/${id}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        description = data['description']['en'].toString().isNotEmpty
            ? r'''''' + data['description']['en']
            : r'''No description available.''';
      });
    } else {
      setState(() {
        description = r'''No description available''';
      });
    }
  }

  _updatePalettes(image) async {
    final PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
        NetworkImage(image),
        size: Size(200, 200));

    colors?.add(generator.dominantColor ?? PaletteColor(Colors.white, 2));
    setState(() {});
  }

  Future<void> checkCoin(String name) async {
    final user = context.read<FirebaseAuthMethods>().user;
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favcoins')
        .doc(widget.name)
        .get();
    if (doc.exists) {
      if (mounted) {
        setState(() {
          setState(() {
            coinExists = true;
          });
        });
      }
    } else {
      if (mounted) {
        setState(() {
          coinExists = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;
    return Scaffold(
      appBar: AppBar(
        shadowColor: colors![currentIndex].color,
        leading: BackButton(
          color: Theme.of(context).iconTheme.color,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(9)),
                child: Image(
                  image: NetworkImage(widget.imageUrl),
                  height: 33,
                  width: 33,
                ),
              ),
            ),
            Text(
              widget.name,
              style: TextStyle(color: Theme.of(context).iconTheme.color),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              checkCoin(widget.name);
              if (!coinExists) {
                final docUser = FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .collection('favcoins')
                    .doc(widget.name);
                final favCoins = {
                  "coinsymbol": widget.symbol,
                };
                await docUser.set(favCoins);
              } else if (coinExists) {
                final favcoin = FirebaseFirestore.instance
                    .collection("users")
                    .doc(user.uid)
                    .collection("favcoins")
                    .doc(widget.name);

                await favcoin.delete();
              }
            },
            icon: !coinExists
                ? Icon(
                    Icons.star_border,
                    color: Theme.of(context).iconTheme.color,
                  )
                : Icon(
                    Icons.star,
                    color: Theme.of(context).iconTheme.color,
                  ),
          )
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Center(
                child: Text(
                  widget.currency == 'eur'
                      ? widget.price.toStringAsFixed(2) + '\€'
                      : widget.currency == 'usd'
                          ? '\$' + widget.price.toStringAsFixed(2)
                          : widget.currency == 'btc'
                              ? '₿' + widget.price.toStringAsFixed(2)
                              : '\$' + widget.price.toStringAsFixed(2),
                  style: TextStyle(
                      color: Theme.of(context).iconTheme.color, fontSize: 25),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.pchangePercentage.roundToDouble() < 0
                      ? widget.pchangePercentage.roundToDouble().toString() +
                          '%'
                      : '+' +
                          widget.pchangePercentage.roundToDouble().toString() +
                          '%',
                  style: TextStyle(
                    color: widget.pchangePercentage.toDouble() < 0
                        ? Colors.red
                        : Colors.green,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  width: 9,
                ),
                Text(
                  widget.pchange.toDouble() < 0
                      ? widget.pchange.roundToDouble().toDouble().toString()
                      : '+' + widget.pchange.toDouble().toString(),
                  style: TextStyle(
                    color: widget.pchange.toDouble() < 0
                        ? Colors.red
                        : Colors.green,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 8, right: 8),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    height: 200,
                    child: Column(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CoinChart(
                              color: colors![currentIndex].color,
                              pricechart: widget.pricechart,
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey[600],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            'Last 7 days',
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, left: 22, right: 22, bottom: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stat(
                        title: "High 24h",
                        wis: 'The highest ' +
                            widget.name +
                            ' has been in the last 24 hours.',
                        wis2: widget.currency == 'eur'
                            ? widget.high24.toString() + '\€'
                            : widget.currency == 'usd'
                                ? '\$' + widget.high24.toString()
                                : widget.currency == 'btc'
                                    ? '₿' + widget.high24.toString()
                                    : '\$' + widget.high24.toString(),
                        color: false,
                        value2: widget.high24,
                        mainColor: colors![currentIndex].color,
                        value: widget.currency == 'eur'
                            ? widget.high24.toStringAsFixed(0) + '\€'
                            : widget.currency == 'usd'
                                ? '\$' + widget.high24.toStringAsFixed(0)
                                : widget.currency == 'btc'
                                    ? '₿' + widget.high24.toStringAsFixed(0)
                                    : '\$' + widget.high24.toStringAsFixed(0),
                      ),
                      Container(width: 30),
                      Stat(
                          title: "Symbol",
                          wis:
                              'The abbreviated name of a cryptocurrency\'s coin or token for trading purposes, which is similar to a stock symbol on the stock market. For example:',
                          wis2: widget.symbol.toUpperCase(),
                          color: false,
                          mainColor: colors![currentIndex].color,
                          value2: widget.changePercentage,
                          value: widget.symbol),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stat(
                        title: "Low 24h",
                        wis: 'The lowhest ' +
                            widget.name +
                            ' has been in the last 24 hours.',
                        wis2: widget.currency == 'eur'
                            ? widget.low24.toString() + '\€'
                            : widget.currency == 'usd'
                                ? '\$' + widget.low24.toString()
                                : widget.currency == 'btc'
                                    ? '₿' + widget.low24.toString()
                                    : '\$' + widget.low24.toString(),
                        color: false,
                        mainColor: colors![currentIndex].color,
                        value2: widget.changePercentage,
                        value: widget.currency == 'eur'
                            ? widget.low24.toStringAsFixed(0) + '\€'
                            : widget.currency == 'usd'
                                ? '\$' + widget.low24.toStringAsFixed(0)
                                : widget.currency == 'btc'
                                    ? '₿' + widget.low24.toStringAsFixed(0)
                                    : '\$' + widget.low24.toStringAsFixed(0),
                      ),
                      Container(width: 30),
                      Stat(
                          title: "Rank",
                          wis: 'Market Cap Rank',
                          wis2: 'Top ' + widget.rank.toStringAsFixed(0),
                          color: false,
                          mainColor: colors![currentIndex].color,
                          value2: widget.changePercentage,
                          value: widget.rank.toStringAsFixed(0)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stat(
                        title: "MK Change 24h",
                        wis: 'High 24h',
                        wis2: widget.currency == 'eur'
                            ? widget.high24.toStringAsFixed(0) + '\€'
                            : widget.currency == 'usd'
                                ? '\$' + widget.high24.toStringAsFixed(0)
                                : widget.currency == 'btc'
                                    ? '₿' + widget.high24.toStringAsFixed(0)
                                    : '\$' + widget.high24.toStringAsFixed(0),
                        color: true,
                        mainColor: colors![currentIndex].color,
                        value2: widget.change,
                        value: widget.currency == 'eur'
                            ? widget.change.toStringAsFixed(2) + '\€'
                            : widget.currency == 'usd'
                                ? '\$' + widget.change.toStringAsFixed(2)
                                : widget.currency == 'btc'
                                    ? '₿' + widget.change.toStringAsFixed(2)
                                    : '\$' + widget.change.toStringAsFixed(2),
                      ),
                      Container(width: 30),
                      Stat(
                        title: "PC Change 24h",
                        wis: 'High 24h',
                        wis2: widget.currency == 'eur'
                            ? widget.high24.toStringAsFixed(0) + '\€'
                            : widget.currency == 'usd'
                                ? '\$' + widget.high24.toStringAsFixed(0)
                                : widget.currency == 'btc'
                                    ? '₿' + widget.high24.toStringAsFixed(0)
                                    : '\$' + widget.high24.toStringAsFixed(0),
                        mainColor: colors![currentIndex].color,
                        color: true,
                        value2: widget.pchange,
                        value: widget.currency == 'eur'
                            ? widget.pchange.toStringAsFixed(2) + '\€'
                            : widget.currency == 'usd'
                                ? '\$' + widget.pchange.toStringAsFixed(2)
                                : widget.currency == 'btc'
                                    ? '₿' + widget.pchange.toStringAsFixed(2)
                                    : '\$' + widget.pchange.toStringAsFixed(2),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stat(
                        title: "MK Change 24h",
                        wis: 'High 24h',
                        wis2: widget.currency == 'eur'
                            ? widget.high24.toStringAsFixed(0) + '\€'
                            : widget.currency == 'usd'
                                ? '\$' + widget.high24.toStringAsFixed(0)
                                : widget.currency == 'btc'
                                    ? '₿' + widget.high24.toStringAsFixed(0)
                                    : '\$' + widget.high24.toStringAsFixed(0),
                        color: true,
                        mainColor: colors![currentIndex].color,
                        value2: widget.changePercentage,
                        value: widget.changePercentage.roundToDouble() < 0
                            ? widget.changePercentage.toStringAsFixed(2) + '%'
                            : '+' +
                                widget.changePercentage.toStringAsFixed(2) +
                                '%',
                      ),
                      Container(width: 30),
                      Stat(
                          title: "PC Change 24h",
                          wis: 'High 24h',
                          wis2: widget.currency == 'eur'
                              ? widget.high24.toStringAsFixed(0) + '\€'
                              : widget.currency == 'usd'
                                  ? '\$' + widget.high24.toStringAsFixed(0)
                                  : widget.currency == 'btc'
                                      ? '₿' + widget.high24.toStringAsFixed(0)
                                      : '\$' + widget.high24.toStringAsFixed(0),
                          mainColor: colors![currentIndex].color,
                          color: true,
                          value2: widget.pchangePercentage,
                          value: widget.pchangePercentage.roundToDouble() < 0
                              ? widget.pchangePercentage.toStringAsFixed(2) +
                                  '%'
                              : '+' +
                                  widget.pchangePercentage.toStringAsFixed(2) +
                                  '%'),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 8, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                        color: colors![currentIndex].color,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    ' description',
                    style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            description.isNotEmpty
                ? Flexible(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: SingleChildScrollView(
                        child: Html(
                          data: description.toString(),
                          style: {
                            "body": Style(
                                textAlign: TextAlign.justify,
                                color: Theme.of(context).iconTheme.color),
                            "a": Style(
                                textAlign: TextAlign.justify,
                                color: colors![currentIndex].color)
                          },
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: CupertinoActivityIndicator(
                        radius: 10, color: Theme.of(context).iconTheme.color),
                  )
          ],
        ),
      ),
    );
  }
}

class Stat extends StatelessWidget {
  final String title;
  final String value;
  final double value2;
  final String wis;
  final String wis2;
  final bool color;
  final Color mainColor;

  const Stat(
      {super.key,
      required this.title,
      required this.value,
      required this.wis,
      required this.wis2,
      required this.color,
      required this.value2,
      required this.mainColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              title: Text(
                title,
                style: TextStyle(color: mainColor),
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    wis,
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Theme.of(context).iconTheme.color),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      wis2,
                      style: TextStyle(color: mainColor),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(6)),
                    padding: const EdgeInsets.all(7),
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[800]!,
                // color: Colors.black.withAlpha(15),
                width: 1.0,
              ),
            ),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
              flex: 5,
              child: Text(
                title,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Theme.of(context).iconTheme.color,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: color
                      ? value2 < 0
                          ? Colors.red
                          : Colors.green
                      : mainColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
