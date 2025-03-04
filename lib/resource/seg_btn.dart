import 'package:flutter/material.dart';

class SegmentedButtonWidget extends StatelessWidget {
  final List<String> segments;
  final int selectedSegment;
  final ValueChanged<int> onSegmentChanged;

  const SegmentedButtonWidget({
    Key? key,
    required this.segments,
    required this.selectedSegment,
    required this.onSegmentChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 6.0,
        runSpacing: 8.0,
        alignment: WrapAlignment.start,
        children: List.generate(segments.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: OutlinedButton(
              onPressed: () => onSegmentChanged(index),
              style: OutlinedButton.styleFrom(
                backgroundColor: index == selectedSegment
                    ? Colors.orangeAccent
                    : Colors.white,
                foregroundColor: index == selectedSegment
                    ? Colors.white
                    : Colors.orangeAccent,
              ),
              child: Text(segments[index]),
            ),
          );
        }),
      ),
    );
  }
}
