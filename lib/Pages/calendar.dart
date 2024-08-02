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
  List<Event>? _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _onDaySelected(selectedDay, focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents = events[
              DateTime(selectedDay.year, selectedDay.month, selectedDay.day)] ??
          [];
    });
  }

  Future<void> _loadEvents() async {
    try {
      events = await api.getEventCalendar();
      setState(() {
        loading = false;
      });
      print('Success fetching events, total: ${events.length}');
      events.forEach((key, value) {
        print('Key <$key>: Value: <${value}>;');
      });
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
              onDaySelected: _onDaySelected,
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
          ),
          loading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: _selectedEvents != null
                      ? SingleChildScrollView(
                          child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _selectedEvents?.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: (Card(
                                      child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            userCircle(colorScheme, index),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${_selectedEvents![index].user.firstname} ${_selectedEvents![index].user.lastName}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(_selectedEvents![index]
                                                    .title)
                                              ],
                                            ),
                                          ],
                                        ),
                                        _selectedEvents![index].img != null
                                            ? Image.network(
                                                'https://backendpint-w3vz.onrender.com/uploads/${_selectedEvents![index].img!.path}',
                                                //Handles images not existing
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                return Container();
                                              })
                                            : const SizedBox()
                                      ],
                                    ),
                                  ))),
                                );
                              }),
                        ))
                      : const SizedBox(),
                )
        ],
      ),
      drawer: myDrawer(
        areas: widget.areas,
      ),
      bottomNavigationBar: MyBottomBar(),
    );
  }

  Container userCircle(ColorScheme colorScheme, int index) {
    return Container(
      margin: const EdgeInsets.only(right: 6.0),
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          color: colorScheme.secondary,
          border: Border.all(width: 3, color: Colors.transparent),
          borderRadius: BorderRadius.circular(95)),
      child: Center(
          //If user does not have Profile Pic, print first letter of first name
          child: _selectedEvents![index].user.profileImg == null
              ? Text(
                  _selectedEvents![index].user.firstname[0],
                  style: TextStyle(fontSize: 20, color: colorScheme.onPrimary),
                )
              : const Text('I')),
    );
  }
}
