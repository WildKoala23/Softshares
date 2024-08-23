import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:softshares/Components/comments.dart';
import 'package:softshares/Components/contentAppBar.dart';
import 'package:softshares/Components/formAppBar.dart';
import 'package:softshares/Pages/registerEvent.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/event.dart';
import 'package:softshares/classes/user.dart';

class EventPage extends StatefulWidget {
  EventPage({super.key, required this.event, required this.areas});

  final Event event;
    List<AreaClass> areas;

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

  Map<User, String> comments = {};

  Future<void> getComments() async {
    comments = await api.getComents(widget.event);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    commentCx.dispose();
  }

  @override
  void initState() {
    super.initState();
    local = convertCoord(widget.event.location!);
    getComments();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: contentAppBar(
        pub: widget.event,
        areas: widget.areas,
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
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                cardHeader(colorScheme),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, bottom: 5.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.event.title,
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.event.desc,
                                  style: TextStyle(fontSize: 18),
                                ),
                                const Divider(
                                  color: Colors.black,
                                  height: 30,
                                  thickness: 2,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                comments.isEmpty
                                    ? const Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.sentiment_dissatisfied,
                                              size: 50,
                                            ),
                                            Text(
                                              'So empty',
                                              style: TextStyle(fontSize: 24),
                                            ),
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: comments.length,
                                        itemBuilder: (context, index) {
                                          User user =
                                              comments.keys.elementAt(index);
                                          String comment = comments[user]!;
                                          return CommentWidget(
                                            userFirstName: user.firstname,
                                            userLastName: user.lastName,
                                            comment: comment,
                                            colorScheme: colorScheme,
                                            onReply: (String) {},
                                          );
                                        },
                                      ),
                              ],
                            ),
                          ),
                        ),
                        Form(
                          key: _commentKey,
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter comment';
                              }
                              return null;
                            },
                            controller: commentCx,
                            decoration: InputDecoration(
                              label: const Text('Add comment'),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  if (_commentKey.currentState!.validate()) {
                                    await api.createComment(
                                        widget.event, commentCx.text);
                                    commentCx.clear();
                                    await getComments(); // Fetch comments again
                                  }
                                },
                                icon: const Icon(Icons.send),
                              ),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide()),
                            ),
                          ),
                        ),
                      ],
                    ),
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
              style: const TextStyle(fontSize: 20),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Register(id: widget.event.id!)),
                  );
                },
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
