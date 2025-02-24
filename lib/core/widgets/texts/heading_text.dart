import 'package:flutter/material.dart';

class HHeaderText extends StatelessWidget {
  final String title;
  const HHeaderText(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
