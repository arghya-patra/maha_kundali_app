import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceReport {
  final String id;
  final String name;
  final String? price; // Allow nullable price
  final String deliveryDay;
  final String seoUrl;
  final String shortDescription;
  final String icon;

  ServiceReport({
    required this.id,
    required this.name,
    this.price,
    required this.deliveryDay,
    required this.seoUrl,
    required this.shortDescription,
    required this.icon,
  });

  factory ServiceReport.fromJson(Map<String, dynamic> json) {
    return ServiceReport(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'], // Allow nullable values here
      deliveryDay: json['delivery_day'] ?? '',
      seoUrl: json['seo_url'] ?? '',
      shortDescription: json['short_description'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}
