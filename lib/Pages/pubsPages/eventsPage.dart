import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:softshares/Components/comments.dart';
import 'package:softshares/Components/contentAppBar.dart';
import 'package:softshares/Components/formAppBar.dart';
import 'package:softshares/Pages/checkAnswers.dart';
import 'package:softshares/Pages/registerEvent.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/commentClass.dart';
import 'package:softshares/classes/db.dart';
import 'package:softshares/classes/event.dart';
import 'package:softshares/classes/user.dart';
import 'package:softshares/providers/auth_provider.dart';

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
  SQLHelper bd = SQLHelper.instance;
  TextEditingController commentCx = TextEditingController();
  final _commentKey = GlobalKey<FormState>();
  bool isEventCreator = false;
  bool userRegistered = false;
  final box = GetStorage();
  List<int> likedComments = [];
  List<Comment> comments = [];
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  List<String> imagesToDisplay = [];

  LatLng convertCoord(String location) {
    List<String> coords = location.split(" ");
    double lat = double.tryParse(coords[0])!;
    double lon = double.tryParse(coords[1])!;
    return LatLng(lat, lon);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> getLikes() async {
    var data = await api.getComentsLikes(widget.event);
    likedComments = data;
  }

  Future<void> getComments() async {
    comments = await api.getComents(widget.event);
    setState(() {});
  }

  Future isCreator() async {
    User user = await api.getUser(box.read('id'));
    if (user.id == widget.event.user.id) {
      setState(() {
        isEventCreator = true;
      });
    }
  }

  Future getAlbum() async {
    var data = await api.getAlbumEvent(widget.event.id!);
    //imagesToDisplay = data;
  }

  Future isRegistered() async {
    if (isEventCreator) {
      setState(() {
        userRegistered = true;
      });
      return;
    }
    User user = await api.getUser(box.read('id'));
    var data = await api.isRegistered(user.id, widget.event.id!);
    if (data == true) {
      setState(() {
        userRegistered = true;
      });
    }
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
    isCreator();
    isRegistered();
    getLikes();
    getAlbum();
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
        length: 3,
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
                Tab(
                  child: Text('Gallery'),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  eventOverview(colorScheme),
                  userRegistered == true
                      ? forumContent(colorScheme)
                      : const Center(
                          child: Text('Please register to see content'),
                        ),
                  userRegistered == true
                      ? galleryContent()
                      : const Center(
                          child: Text('Please register to see content'),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column galleryContent() {
    return Column(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
              itemCount: imagesToDisplay.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) {
                return Image.network(
                  '${box.read('url')}/uploads/${imagesToDisplay[index]}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color.fromARGB(255, 255, 204, 150),
                    );
                  },
                );
              }),
        )),
        ElevatedButton(
            onPressed: () async {
              await selectImages();
              imageFileList?.forEach((photo) async {
                var file = File(photo.path);
                await api.addToAlbum(widget.event.id!, file);
                setState(() {
                  getAlbum();
                });
              });
            },
            child: const Text('Select images'))
      ],
    );
  }

  Padding forumContent(ColorScheme colorScheme) {
    return Padding(
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
                    padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
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
                            mainAxisAlignment: MainAxisAlignment.end,
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
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            bool liked =
                                likedComments.contains(comments[index].id);
                            return CommentWidget(
                              liked: liked,
                              comment: comments[index],
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
                      await api.createComment(widget.event, commentCx.text);
                      commentCx.clear();
                      await getComments(); // Fetch comments again
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
                border: const OutlineInputBorder(borderSide: BorderSide()),
              ),
            ),
          ),
        ],
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
            const SizedBox(height: 10),
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
                    height: 170,
                    color: const Color.fromARGB(255, 255, 204, 150),
                  )
                : Center(
                    child: Container(
                      height: 170,
                      width: double.infinity,
                      child: Image.network(
                        '${box.read('url')}/uploads/${widget.event.img!.path}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color.fromARGB(255, 255, 204, 150),
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
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Start date: ',
                    style: TextStyle(fontSize: 24),
                  ),
                  TextSpan(
                    text:
                        '${widget.event.eventDate.day}/${widget.event.eventDate.month}/${widget.event.eventDate.year}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Duration: ',
                    style: TextStyle(fontSize: 24),
                  ),
                  TextSpan(
                    text:
                        '${widget.event.event_start!.hour}:${widget.event.event_start!.minute}h - ${widget.event.event_end!.hour}:${widget.event.event_end!.minute}h',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
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
              //Checks if current user is event creator
              child: isEventCreator == false
                  // Checks if currente user is already registered
                  // If so, remove 'register' button
                  ? userRegistered == false
                      ? ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register(
                                        event: widget.event,
                                        areas: widget.areas,
                                      )),
                            );
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                          ),
                          child: Text(
                            'Register for Event',
                            style: TextStyle(color: colorScheme.onPrimary),
                          ),
                        )
                      : Container()
                  : ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CheckAnswers(id: widget.event.id!)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                      ),
                      child: Text(
                        'Check answers',
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
                child: widget.event.user.profileImg == null
                    ? Text(
                        widget.event.user.firstname[0],
                        style: TextStyle(
                          fontSize: 20,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Container(),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User's Name
                Text(
                  "${widget.event.user.firstname} ${widget.event.user.lastName}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                // Spacer to add some gap between the name and the stars
                SizedBox(width: 8),
                // Conditional Star Rating
                if (widget.event.aval != null)
                  ...List.generate(
                    widget.event.aval!.round(),
                    (index) => Icon(
                      Icons.star,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 25,
                    ),
                  ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Future selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }
}
