import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptoss/components/coinChart.dart';
import 'package:cryptoss/components/coinModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../provider/firebase_auth_methods.dart';

class CoinDetailsPage extends StatefulWidget {
  const CoinDetailsPage({
    super.key,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.currency,
    required this.price,
    required this.change,
    required this.changePercentage,
    required this.high24,
    required this.pricechart,
  });

  final String name;
  final String symbol;
  final String imageUrl;
  final String currency;
  final double price;
  final double change;
  final double changePercentage;
  final double high24;
  final List<double> pricechart;

  @override
  State<CoinDetailsPage> createState() => _CoinDetailsPageState();
}

class _CoinDetailsPageState extends State<CoinDetailsPage> {
  bool coinExists = false;
  @override
  void initState() {
    checkCoin(widget.name);
    super.initState();
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
        leading: BackButton(
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
                      ? widget.price.toDouble().toString() + '\€'
                      : widget.currency == 'usd'
                          ? '\$' + widget.price.toDouble().toString()
                          : widget.currency == 'btc'
                              ? '₿' + widget.price.toDouble().toString()
                              : '\$' + widget.price.toDouble().toString(),
                  style: TextStyle(
                      color: Theme.of(context).iconTheme.color, fontSize: 25),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.changePercentage.roundToDouble() < 0
                      ? widget.changePercentage.roundToDouble().toString() + '%'
                      : '+' +
                          widget.changePercentage.roundToDouble().toString() +
                          '%',
                  style: TextStyle(
                    color: widget.changePercentage.toDouble() < 0
                        ? Colors.red
                        : Colors.green,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  width: 9,
                ),
                Text(
                  widget.change.toDouble() < 0
                      ? widget.change.roundToDouble().toDouble().toString()
                      : '+' + widget.change.toDouble().toString(),
                  style: TextStyle(
                    color: widget.change.toDouble() < 0
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
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 5),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Theme.of(context).backgroundColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'High 24h',
                              style: TextStyle(
                                  color: Theme.of(context).iconTheme.color),
                            ),
                            Container(
                              width: 7.2.w,
                            ),
                            Text(
                              widget.currency == 'eur'
                                  ? widget.high24.toStringAsFixed(0) + '\€'
                                  : widget.currency == 'usd'
                                      ? '\$' + widget.high24.toStringAsFixed(0)
                                      : widget.currency == 'btc'
                                          ? '₿' +
                                              widget.high24.toStringAsFixed(0)
                                          : '\$' +
                                              widget.high24.toStringAsFixed(0),
                              style: TextStyle(
                                  color: Theme.of(context).iconTheme.color),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 5),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Theme.of(context).backgroundColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Low 24h'),
                            Container(
                              width: 7.2.w,
                            ),
                            Text('s200000'),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
