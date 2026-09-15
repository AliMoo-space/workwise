import 'package:flutter/material.dart';

class StrengthsTitle extends StatelessWidget {
  const StrengthsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text("Strengths", style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
