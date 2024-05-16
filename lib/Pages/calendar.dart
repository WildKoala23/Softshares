import 'package:flutter/material.dart';
import 'package:softshares/Components/appBar.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  void callBack(context) {
    print('Will implement');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: MyAppBar(
        iconR: const Icon(Icons.notifications),
        title: 'Calendar',
        rightCallback: callBack,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 20, 12, 40),
            child: TableCalendar(
              focusedDay: today,
              firstDay: DateTime.utc(2023, 09, 01),
              selectedDayPredicate: (day) => isSameDay(day, today),
              lastDay: DateTime.utc(2026, 09, 01),
              onDaySelected: _onDaySelected,
            ),
          )
        ],
      ),
      drawer: myDrawer(
        location: 'Viseu',
      ),
      bottomNavigationBar: MyBottomBar(),
    );
  }
}
