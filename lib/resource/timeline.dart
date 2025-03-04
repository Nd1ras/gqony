import 'dart:async';

import 'package:flutter/material.dart';

class TimelineWidget extends StatefulWidget {
  final bool isCurrentDateFriday;

  const TimelineWidget({
    Key? key,
    required this.isCurrentDateFriday,
  }) : super(key: key);

  @override
  _TimelineWidgetState createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Today',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 200.0,
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('8 AM'),
                    Text('8 PM'),
                  ],
                ),
              ),
              // current time
              Positioned(
                left: _calculatePositionX(_currentTime),
                child: Container(
                  width: 2.0,
                  height: 200.0,
                  color: Colors.red,
                ),
              ),
              // bfast start
              Positioned(
                left: _calculatePositionX(DateTime(_currentTime.year,
                    _currentTime.month, _currentTime.day, 8, 0)),
                child: Container(
                  width: 1.0,
                  height: 200.0,
                  color: Colors.blue,
                ),
              ),

              // bfast end
              Positioned(
                left: _calculatePositionX(DateTime(_currentTime.year,
                    _currentTime.month, _currentTime.day, 11, 0)),
                child: Container(
                  width: 1.0,
                  height: 200.0,
                  color: Colors.blue,
                ),
              ),
              // lunch start
              Positioned(
                left: _calculatePositionX(DateTime(_currentTime.year,
                    _currentTime.month, _currentTime.day, 12, 0)),
                child: Container(
                  width: 1.0,
                  height: 200.0,
                  color: const Color.fromARGB(255, 92, 252, 0),
                ),
              ),

              // lunch end
              Positioned(
                left: _calculatePositionX(DateTime(_currentTime.year,
                    _currentTime.month, _currentTime.day, 14, 0)),
                child: Container(
                  width: 1.0,
                  height: 200.0,
                  color: const Color.fromARGB(255, 92, 252, 0),
                ),
              ),
              // happy hour start
              if (widget.isCurrentDateFriday)
                Positioned(
                  left: _calculatePositionX(DateTime(_currentTime.year,
                      _currentTime.month, _currentTime.day, 16, 0)),
                  child: Container(
                    width: 1.0,
                    height: 200.0,
                    color: const Color.fromARGB(255, 255, 0, 255),
                  ),
                ),
              // happy hour end
              Positioned(
                left: _calculatePositionX(DateTime(_currentTime.year,
                    _currentTime.month, _currentTime.day, 18, 0)),
                child: Container(
                  width: 1.0,
                  height: 200.0,
                  color: const Color.fromARGB(255, 255, 0, 255),
                ),
              ),
              // next day's booking deadline
              Positioned(
                left: _calculatePositionX(DateTime(_currentTime.year,
                    _currentTime.month, _currentTime.day, 17, 0)),
                child: Container(
                  width: 2.0,
                  height: 200.0,
                  color: Colors.grey[600],
                ),
              ),
              //dinner
              Positioned(
                left: _calculatePositionX(DateTime(_currentTime.year,
                    _currentTime.month, _currentTime.day, 18, 0)),
                child: Container(
                  width: 2.0,
                  height: 200.0,
                  color: const Color.fromARGB(255, 255, 208, 0),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _calculatePositionX(DateTime time) {
    final totalMinutes = time.hour * 60 + time.minute;
    final totalPixels = MediaQuery.of(context).size.width - 32.0;
    final pixelsPerMinute = totalPixels / (12 * 60);
    return (totalMinutes - 480) * pixelsPerMinute;
  }
}
