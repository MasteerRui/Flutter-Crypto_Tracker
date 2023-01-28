import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../provider/firebase_auth_methods.dart';

class CoinCard extends StatefulWidget {
  CoinCard({
    required this.primary,
    required this.text,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.currency,
    required this.price,
    required this.pchange,
    required this.pchangePercentage,
  });

  Color primary;
  Color text;
  String name;
  String symbol;
  String imageUrl;
  String currency;
  double price;
  double pchange;
  double pchangePercentage;

  @override
  State<CoinCard> createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
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

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                color: widget.primary,
                borderRadius: BorderRadius.circular(7),
              ),
              height: 40,
              width: 40,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.network(widget.imageUrl),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.symbol.toUpperCase(),
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    widget.currency == 'eur'
                        ? widget.price.toDouble().toString() + '\€'
                        : widget.currency == 'usd'
                            ? '\$' + widget.price.toDouble().toString()
                            : widget.currency == 'btc'
                                ? '₿' + widget.price.toDouble().toString()
                                : '\$' + widget.price.toDouble().toString(),
                    style: TextStyle(
                      color: widget.text,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.pchangePercentage.toDouble() < 0
                        ? Colors.red
                        : Colors.green,
                  ),
                  child: Text(
                    widget.pchangePercentage.roundToDouble() < 0
                        ? widget.pchangePercentage.roundToDouble().toString() +
                            '%'
                        : '+' +
                            widget.pchangePercentage
                                .roundToDouble()
                                .toString() +
                            '%',
                    style: TextStyle(
                      color: widget.text,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 1.w,
                ),
                Container(
                  padding: EdgeInsets.all(3.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.pchange.toDouble() < 0
                        ? Colors.red
                        : Colors.green,
                  ),
                  child: Text(
                    widget.pchange.toDouble() < 0
                        ? widget.pchange.roundToDouble().toDouble().toString()
                        : '+' + widget.pchange.toDouble().toString(),
                    style: TextStyle(
                      color: widget.text,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.only(left: 20),
                  constraints: BoxConstraints(),
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
                          color: widget.text,
                        )
                      : Icon(
                          Icons.star,
                          color: widget.text,
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
