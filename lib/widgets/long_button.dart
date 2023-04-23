import 'package:flutter/material.dart';

class LongFilledButton extends StatelessWidget {
  final String label;
  final Function() onPressed;

  const LongFilledButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: FilledButton(
        // style: FilledButton.styleFrom(minimumSize: Size.fromWidth),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
