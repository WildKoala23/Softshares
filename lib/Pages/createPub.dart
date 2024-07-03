import 'dart:io';
import 'package:softshares/Pages/createPubs/eventContent.dart';
import 'package:softshares/Pages/createPubs/forumContent.dart';
import 'package:softshares/Pages/createPubs/poiContent.dart';
import 'package:softshares/Pages/createPubs/postContent.dart';
import 'package:softshares/classes/POI.dart';
import '../classes/forums.dart';
import '../classes/event.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:search_map_location/search_map_location.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/publication.dart';
import 'package:softshares/classes/user.dart';

class createPost extends StatefulWidget {
  createPost({super.key, required this.areas});

  List<AreaClass> areas;

  @override
  State<createPost> createState() => _CreatePostState();
}

//Change to current user
User user1 = User(1, 'John', 'Doe', 'john.doe@example.com');

class _CreatePostState extends State<createPost> {
  final API api = API();

  File? _selectedImage;

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descController = TextEditingController();

  late AreaClass selectedArea;
  late AreaClass selectedSubArea;
  late double currentSlideValue;
  late double currentPriceValue;

  //Variables to en/disable rating and price sliders when not necessary
  late bool nonRating;
  late bool nonPrice;

  //Depending on the recurrency, the label for date changes (This variable controls the text)
  String? dateOpt;

  //Variables to help checking if the event is recurrent or not
  List<String> recurrentOpt = ["Weekly", "Monthly"];
  bool recurrent = false;
  late String recurrentValue;

  List<AreaClass> subAreas = [];

  //Variables to validate created content
  final _poiKey = GlobalKey<FormState>();
  final _eventKey = GlobalKey<FormState>();



  @override
  void initState() {
    super.initState();
    selectedArea = widget.areas[0];
    selectedSubArea = selectedArea.subareas![0];
    currentSlideValue = 3;
    recurrentValue = recurrentOpt.first;
    currentPriceValue = 3;
    dateOpt = 'Date';
    nonPrice = true;
    nonRating = true;
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    dateController.dispose();
    descController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: appBar(context, colorScheme),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
              unselectedLabelColor: colorScheme.onSecondary,
              labelColor: colorScheme.onSecondary,
              indicatorColor: colorScheme.primary,
              tabs: const [
                Tab(child: Text('Events')),
                Tab(child: Text('Forums')),
                Tab(child: Text('POI')),
                Tab(child: Text('Posts')),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  EventCreation(areas: widget.areas),
                  ForumCreation(areas: widget.areas),
                  POICreation(areas: widget.areas),
                  PostCreation(areas: widget.areas)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context, ColorScheme colorScheme) {
    return AppBar(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('Create Publication'),
    );
  }




}
