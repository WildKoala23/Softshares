import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:softshares/Components/formAppBar.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/event.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.event});

  final Event event;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late GoogleMapController mapController;
  late LatLng local;
  API api = API();
  TextEditingController commentCx = TextEditingController();
  final _commentKey = GlobalKey<FormState>();

  LatLng convertCoord(String location) {
    List<String> coords = location.split(" ");
    double lat = double.tryParse(coords[0])!;
    double lon = double.tryParse(coords[1])!;
    return LatLng(lat, lon);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    local = convertCoord(widget.event.location!);
  }

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
                  eventOverview(colorScheme),
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

  SingleChildScrollView eventOverview(ColorScheme colorScheme) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            cardHeader(colorScheme),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                widget.event.title,
                style: const TextStyle(fontSize: 26),
              ),
            ),
            const SizedBox(height: 10),
            widget.event.img == null
                ? Container(
                    height: 120,
                    color: const Color.fromARGB(255, 255, 204, 150),
                  )
                : Center(
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      child: Image.network(
                        'https://backendpint-w3vz.onrender.com/uploads/${widget.event.img!.path}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color.fromARGB(255, 255, 204, 150),
                            height: 120,
                          );
                        },
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            Text(
              widget.event.desc,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Date: ${widget.event.eventDate.day}/${widget.event.eventDate.month}/${widget.event.eventDate.year}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: local,
                    zoom: 11.0,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('Event'),
                      position: local,
                    ),
                  },
                ),
              ),
            ),
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                ),
                child: Text(
                  'Register for Event',
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
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
                borderRadius: BorderRadius.circular(95),
              ),
              child: Center(
                // If user does not have Profile Pic, print first letter of first name
                child: widget.event.user.profileImg == null
                    ? Text(
                        widget.event.user.firstname[0],
                        style: TextStyle(
                          fontSize: 20,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : const Text('I'),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.event.user.firstname} ${widget.event.user.lastName}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
