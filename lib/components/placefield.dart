import 'package:flutter/material.dart';

placefield(controller, isLoading) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: 'Search City',
      border: OutlineInputBorder(),
      suffixIcon: isLoading ? CircularProgressIndicator() : null,
    ),
  );
}
