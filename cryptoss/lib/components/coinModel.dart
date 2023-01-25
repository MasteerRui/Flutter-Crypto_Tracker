import 'dart:ffi';

import 'package:flutter/material.dart';

class Coin {
  Coin({
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.change,
    required this.changePercentage,
    required this.high24,
    required this.pricechart,
  });

  String name;
  String symbol;
  String imageUrl;
  num price;
  num change;
  num changePercentage;
  num high24;
  List<double> pricechart;

  factory Coin.fromJson(Map<String, dynamic> json) {
    if (json['current_price'] > 100) {
      return Coin(
          name: json['name'] ?? '',
          symbol: json['symbol'] ?? '',
          imageUrl: json['image'] ?? '',
          price: json['current_price'] ?? 0,
          change: json['price_change_24h'] ?? 0,
          changePercentage: json['price_change_percentage_24h'] ?? 0,
          high24: json['high_24h'] ?? 0,
          pricechart: (json['sparkline_in_7d'] != null &&
                  json['sparkline_in_7d']['price'] != null)
              ? List<double>.from(json['sparkline_in_7d']['price'])
                  .map((e) => e.roundToDouble())
                  .toList()
              : []);
    } else {
      return Coin(
          name: json['name'] ?? '',
          symbol: json['symbol'] ?? '',
          imageUrl: json['image'] ?? '',
          price: json['current_price'] ?? 0,
          change: json['price_change_24h'] ?? 0,
          changePercentage: json['price_change_percentage_24h'] ?? 0,
          high24: json['high_24h'] ?? 0,
          pricechart: (json['sparkline_in_7d'] != null &&
                  json['sparkline_in_7d']['price'] != null)
              ? List<double>.from(json['sparkline_in_7d']['price'])
                  .map((e) => e.toDouble())
                  .toList()
              : []);
    }
  }
}

List<Coin> coinList = [];
