import 'package:flutter/material.dart';

InputDecoration glowingInput(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(
      color: Colors.greenAccent,
      fontFamily: 'FiraCode',
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.greenAccent),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.greenAccent, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
