
import 'package:flutter/material.dart';

class ErrorSnackbar {
  final String error;
  final BuildContext context;
  final int duration;

  ErrorSnackbar({required this.error, required this.context, this.duration = 10 }) {
    ScaffoldMessenger.of(context)
     // ..hideCurrentSnackBar()
      .showSnackBar(SnackBar(
        content: Text(error),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        padding: const EdgeInsets.all(10),
        duration: Duration(seconds: duration),
      ));
  }}
