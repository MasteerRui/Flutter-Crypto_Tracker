// ignore_for_file: prefer_const_constructors
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptoss/pages/main_pages/coin_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:async';
import 'dart:convert';
import 'package:cryptoss/components/coinCard.dart';
import 'package:http/http.dart' as http;
import 'package:cryptoss/components/coinModel.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:core';
import '../../provider/dark_theme_provider.dart';
import '../../provider/firebase_auth_methods.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Object?> fcoins = [];
  List<Coin> coinsList = [];
  int _selectedIndex = 0;
  List<String> currencys = ['€', '\$', '₿'];
  String? selectedCurrency;
  bool isLoading = true;
  int? count;
  int? _currentTime;
  Timer? _timer;

  Future<Object> fetchCoin() async {
    await getCurrency();
    coinList = [];
    isLoading = true;
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=$selectedCurrency&order=market_cap_desc&per_page=250&page=1&sparkline=true'));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(Coin.fromJson(map));
          }
        }
        setState(() {
          isLoading = false;
          coinList;
          count = 0;
          _currentTime = 5;
        });
      }
      return coinsList;
    } else {
      return _currentTime = 5;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      count = (count! + 1);
      if (count == 5) {
        setState(() {
          _currentTime = 5;
          count = 0;
        });
        fetchCoin();
      } else {
        setState(() {
          _currentTime = (_currentTime! - 1);
        });
      }
    });
  }

  Future<String?> getCurrency() async {
    final user = context.read<FirebaseAuthMethods>().user;
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      selectedCurrency = doc['currency'];
    });
    return selectedCurrency;
  }

  @override
  void initState() {
    fetchCoin();
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color primary = Theme.of(context).primaryColor;
    Color? text = Theme.of(context).iconTheme.color;
    final user = context.read<FirebaseAuthMethods>().user;
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Crypto kiu',
            style: TextStyle(color: Theme.of(context).iconTheme.color),
          ),
          centerTitle: true,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                child: GNav(
                  rippleColor: Colors.orangeAccent.withOpacity(0.7),
                  hoverColor: Colors.orangeAccent.withOpacity(0.7),
                  gap: 8,
                  activeColor: Theme.of(context).iconTheme.color,
                  iconSize: 24,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: const Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.orangeAccent.withOpacity(0.7),
                  color: Theme.of(context).iconTheme.color,
                  tabs: [
                    GButton(
                      icon: LineIcons.home,
                      text: 'Home',
                      iconColor: Theme.of(context).iconTheme.color,
                    ),
                    GButton(
                      icon: LineIcons.coins,
                      text: 'Coins',
                      iconColor: Theme.of(context).iconTheme.color,
                    ),
                    GButton(
                      icon: Icons.settings,
                      text: 'Settings',
                      iconColor: Theme.of(context).iconTheme.color,
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
              ),
            )),
        body: _selectedIndex == 0
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15, left: 20, right: 20, bottom: 0),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(6)),
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Favourite Coins',
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color),
                          ),
                        )
                      ]),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 15, left: 20, right: 20),
                      child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.circular(11)),
                          child: Flexible(
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .collection('favcoins')
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    fcoins.clear();
                                    for (var doc in snapshot.data!.docs) {
                                      fcoins.add(doc.id);
                                    }
                                  }
                                  return isLoading
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: 3,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6.0,
                                                  right: 6.0,
                                                  bottom: 5),
                                              child: Skeleton(
                                                width: 200,
                                                height: 40,
                                              ),
                                            );
                                          })
                                      : fcoins.isNotEmpty
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: coinList.length,
                                              itemBuilder: (context, index) {
                                                if (coinList.isNotEmpty) {
                                                  if (fcoins.contains(
                                                      coinList[index].name)) {
                                                    return CoinCard(
                                                      primary: primary,
                                                      text: text!,
                                                      name:
                                                          coinList[index].name,
                                                      symbol: coinList[index]
                                                          .symbol,
                                                      imageUrl: coinList[index]
                                                          .imageUrl,
                                                      currency:
                                                          selectedCurrency ??
                                                              'eur',
                                                      price: coinList[index]
                                                          .price
                                                          .toDouble(),
                                                      change: coinList[index]
                                                          .change
                                                          .toDouble(),
                                                      changePercentage:
                                                          coinList[index]
                                                              .changePercentage
                                                              .toDouble(),
                                                    );
                                                  }
                                                }
                                                return SizedBox.shrink();
                                              },
                                            )
                                          : Container(
                                              padding: EdgeInsets.all(8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                    'assets/cloud-computing.png',
                                                    height: 50,
                                                  ),
                                                  Center(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'No favourite coins?',
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .color),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _selectedIndex =
                                                                  1;
                                                            });
                                                          },
                                                          child: Text(
                                                            'add now',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .orangeAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            );
                                }),
                          )),
                    ),
                  ),
                ],
              )
            : _selectedIndex == 1
                ? Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20, bottom: 0),
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).backgroundColor,
                                      borderRadius: BorderRadius.circular(7)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: _currentTime == 0
                                                        ? Center(
                                                            child: CupertinoActivityIndicator(
                                                                radius: 9,
                                                                color: Theme.of(
                                                                        context)
                                                                    .iconTheme
                                                                    .color),
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5.0),
                                                            child:
                                                                _currentTime ==
                                                                        1
                                                                    ? Text(
                                                                        'Updates in $_currentTime minute',
                                                                        style: TextStyle(
                                                                            color: Theme.of(context)
                                                                                .iconTheme
                                                                                .color,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      )
                                                                    : Text(
                                                                        'Updates in $_currentTime minutes',
                                                                        style: TextStyle(
                                                                            color: Theme.of(context)
                                                                                .iconTheme
                                                                                .color,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                      ),
                                                          )),
                                                GestureDetector(
                                                  onTap: () {
                                                    _timer!.cancel();
                                                    fetchCoin();
                                                    _startTimer();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: Colors
                                                                .orangeAccent),
                                                        child: Icon(
                                                          Icons.refresh,
                                                          color:
                                                              Theme.of(context)
                                                                  .iconTheme
                                                                  .color,
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 20, right: 20, bottom: 0),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  borderRadius: BorderRadius.circular(11)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 13.0, right: 8.0, top: 10.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(1.0),
                                              child: Center(
                                                child: Text(
                                                  // ignore: prefer_interpolation_to_compose_strings
                                                  'Top 100 coins',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .iconTheme
                                                          .color,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Divider(
                                      color: Colors.grey[700],
                                      height: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: isLoading
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: 20,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12.0,
                                                    right: 12.0,
                                                    bottom: 5),
                                                child: Skeleton(
                                                  width: 200,
                                                  height: 50,
                                                ),
                                              );
                                            })
                                        : ListView.separated(
                                            separatorBuilder:
                                                (context, index) => Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15),
                                              child: Divider(
                                                color: Colors.grey[700],
                                                height: 0,
                                              ),
                                            ),
                                            itemCount: 100,
                                            itemBuilder: (context, index) {
                                              if (coinList.isNotEmpty) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                CoinDetailsPage(
                                                                  name: coinList[
                                                                          index]
                                                                      .name,
                                                                  symbol: coinList[
                                                                          index]
                                                                      .symbol,
                                                                  imageUrl: coinList[
                                                                          index]
                                                                      .imageUrl,
                                                                  currency:
                                                                      selectedCurrency ??
                                                                          'eur',
                                                                  price: coinList[
                                                                          index]
                                                                      .price
                                                                      .toDouble(),
                                                                  change: coinList[
                                                                          index]
                                                                      .change
                                                                      .toDouble(),
                                                                  changePercentage: coinList[
                                                                          index]
                                                                      .changePercentage
                                                                      .toDouble(),
                                                                  high24: coinList[
                                                                          index]
                                                                      .high24
                                                                      .toDouble(),
                                                                  low24: coinList[
                                                                          index]
                                                                      .low24
                                                                      .toDouble(),
                                                                  rank: coinList[
                                                                          index]
                                                                      .rank
                                                                      .toDouble(),
                                                                  pricechart: coinList[
                                                                          index]
                                                                      .pricechart,
                                                                )));
                                                  },
                                                  child: CoinCard(
                                                    primary: primary,
                                                    text: text!,
                                                    name: coinList[index].name,
                                                    symbol:
                                                        coinList[index].symbol,
                                                    imageUrl: coinList[index]
                                                        .imageUrl,
                                                    currency:
                                                        selectedCurrency ??
                                                            'eur',
                                                    price: coinList[index]
                                                        .price
                                                        .toDouble(),
                                                    change: coinList[index]
                                                        .change
                                                        .toDouble(),
                                                    changePercentage:
                                                        coinList[index]
                                                            .changePercentage
                                                            .toDouble(),
                                                  ),
                                                );
                                              }
                                              return Container();
                                            },
                                          ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ],
                  )
                : _selectedIndex == 2
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 23),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).backgroundColor,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        user.photoURL!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            overflow: TextOverflow.ellipsis,
                                            user.displayName!,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            user.email!,
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 9.0, horizontal: 9),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            color:
                                                Theme.of(context).primaryColor),
                                        child: Icon(
                                          Icons.edit,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).backgroundColor,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(3.2),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Icon(
                                            LineIcons.coins,
                                            color: Colors.orangeAccent,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                overflow: TextOverflow.ellipsis,
                                                'Currency',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .iconTheme
                                                        .color,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 25),
                                          child: SizedBox(
                                            height: 40,
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                dropdownColor: Theme.of(context)
                                                    .backgroundColor,
                                                iconSize: 0.0,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                value: selectedCurrency == 'eur'
                                                    ? '€'
                                                    : selectedCurrency == 'usd'
                                                        ? '\$'
                                                        : selectedCurrency ==
                                                                'btc'
                                                            ? '₿'
                                                            : '\$',
                                                items: currencys
                                                    .map(
                                                      (e) => DropdownMenuItem<
                                                              String>(
                                                          value: e,
                                                          child: Text(
                                                            e,
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .iconTheme
                                                                    .color),
                                                          )),
                                                    )
                                                    .toList(),
                                                onChanged:
                                                    (String? value) async {
                                                  var value2;
                                                  if (value == '€') {
                                                    value2 = 'eur';
                                                  } else if (value == '\$') {
                                                    value2 = 'usd';
                                                  } else if (value == '₿') {
                                                    value2 = 'btc';
                                                  }
                                                  final docUser =
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(user.uid);
                                                  final newTrip = {
                                                    "currency": value2,
                                                  };

                                                  await docUser.update(
                                                    newTrip,
                                                  );
                                                  setState(() {
                                                    selectedCurrency = value2;
                                                  });
                                                  _timer!.cancel();
                                                  fetchCoin();
                                                  _startTimer();
                                                },
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Divider(
                                      height: 1,
                                      color: Colors.grey[700],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(3.2),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Icon(
                                            Icons.dark_mode,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                overflow: TextOverflow.ellipsis,
                                                'Dark Mode',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .iconTheme
                                                        .color,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        CupertinoSwitch(
                                          value: themeChange.darkTheme,
                                          onChanged: (value) {
                                            themeChange.darkTheme = value;
                                          },
                                        )
                                      ],
                                    ),
                                    Divider(
                                      height: 1,
                                      color: Colors.grey[700],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        context
                                            .read<FirebaseAuthMethods>()
                                            .signOut(context);
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Text(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    'Sign Out',
                                                    style: TextStyle(
                                                        color: Colors.redAccent,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container());
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton({super.key, this.height, this.width});

  final double? height, width;

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[300]!,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 5,
              ),
              Container(
                height: height,
                width: width,
                padding:
                    EdgeInsets.only(bottom: 10, top: 10, right: 8, left: 8),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.all(Radius.circular(13))),
              ),
            ],
          ),
        ),
      );
}
