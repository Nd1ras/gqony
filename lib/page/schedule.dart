import 'package:flutter/material.dart';
import '../resource/seg_btn.dart';
import '../resource/calendar.dart';
import '../resource/timeline.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  int _selectedSegment = 0;
  DateTime _selectedDate = DateTime.now();

  final List<String> _segments = ['Breakfast', 'Lunch', 'Snack', 'Dinner'];

  @override
  void initState() {
    super.initState();
    _handleHappyHour();
  }

  void _handleHappyHour() {
    final isCurrentDateFriday = _selectedDate.weekday == DateTime.friday;

    if (!isCurrentDateFriday) {
      _segments.removeWhere((segment) => segment == 'Happy Hour');
    } else {
      _segments.insert(2, 'Happy Hour');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentDateFriday = _selectedDate.weekday == DateTime.friday;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SegmentedButtonWidget(
              segments: _segments,
              selectedSegment: _selectedSegment,
              onSegmentChanged: (index) {
                setState(() {
                  _selectedSegment = index;
                });
              },
            ),
            CalendarWidget(),
            TimelineWidget(
              isCurrentDateFriday: isCurrentDateFriday,
            ),
          ],
        ),
      ),
    );
  }
}
