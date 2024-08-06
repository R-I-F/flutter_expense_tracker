import 'package:flutter/material.dart';

class ChartBars extends StatelessWidget {
  const ChartBars({super.key, required this.ratio});

  final double ratio ; 

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FractionallySizedBox(
          heightFactor: ratio,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).colorScheme.onSurface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
