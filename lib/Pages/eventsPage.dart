import 'package:flutter/material.dart';
import 'package:softshares/Components/formAppBar.dart';
import 'package:softshares/classes/event.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.event});

  final Event event;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: formAppbar(
        title: '',
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: colorScheme.onSecondary,
              indicatorColor: colorScheme.secondary,
              splashFactory: NoSplash.splashFactory,
              tabs: const [
                Tab(
                  child: Text('Overview'),
                ),
                Tab(
                  child: Text('Forum'),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cardHeader(colorScheme),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.event.title,
                            style: const TextStyle(fontSize: 26),
                          ),
                          widget.event.img == null
                              ? Container(
                                  height: 120,
                                  color: Color.fromARGB(255, 255, 204, 150),
                                )
                              : Center(
                                  child: Container(
                                    height: 120,
                                    width: double.infinity,
                                    child: Image.network(
                                      'https://backendpint-w3vz.onrender.com/uploads/${widget.event.img!.path}',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Color.fromARGB(
                                              255, 255, 204, 150),
                                          height: 120,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            widget.event.desc,
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Date: ${widget.event.eventDate.day}/${widget.event.eventDate.month}/${widget.event.eventDate.year}',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.amber,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row cardHeader(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 6.0),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  border: Border.all(width: 3, color: Colors.transparent),
                  borderRadius: BorderRadius.circular(95)),
              child: Center(
                  //If user does not have Profile Pic, print first letter of first name
                  child: widget.event.user.profileImg == null
                      ? Text(
                          widget.event.user.firstname[0],
                          style: TextStyle(
                              fontSize: 20, color: colorScheme.onPrimary),
                        )
                      : const Text('I')),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.event.user.firstname} ${widget.event.user.lastName}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
