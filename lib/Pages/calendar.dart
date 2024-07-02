import 'package:flutter/material.dart';
import 'package:softshares/Components/appBar.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/event.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  Calendar({super.key, required this.areas});
  List<AreaClass> areas;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> events = {};
  final API api = API();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      events = await api.getEventCalendar();
      setState(() {
        loading = false;
      });
      print('Success fetching events, total: ${events.length}');
    } catch (e) {
      print("Error fetching events: $e");
      setState(() {
        events = {};
      });
    }
  }

  void callBack(context) {
    print('Will implement');
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[DateTime(day.year, day.month, day.day)] ?? [];
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
              focusedDay: _focusedDay,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              firstDay: DateTime.utc(2023, 09, 01),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              lastDay: DateTime.utc(2026, 09, 01),
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: (day) {
                return _getEventsForDay(day);
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isEmpty) return SizedBox();
                  return Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
      drawer: myDrawer(
        areas: widget.areas,
      ),
      bottomNavigationBar: MyBottomBar(),
    );
  }
}
