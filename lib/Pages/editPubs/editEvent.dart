import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:search_map_location/widget/search_widget.dart';
import 'package:softshares/Components/appBar.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/db.dart';
import 'package:softshares/classes/event.dart';
import 'package:softshares/classes/user.dart';

class EditEvent extends StatefulWidget {
  EditEvent({super.key, required this.pub, required this.areas});

  Event pub;
  List<AreaClass> areas;

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final API api = API();
  SQLHelper bd = SQLHelper.instance;

  File? _selectedImage;

  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descController = TextEditingController();

  late AreaClass selectedArea;
  late AreaClass selectedSubArea;

  String? location;

  //Depending on the recurrency, the label for date changes (This variable controls the text)
  String? dateOpt;

  //Variables to help checking if the event is recurrent or not
  List<String> recurrentOpt = ["Weekly", "Monthly", "yearly"];
  bool recurrent = false;
  late String recurrentValue;

  late TimeOfDay start_time;
  late TimeOfDay end_time;

  final _eventKey = GlobalKey<FormState>();

  @override
  void initState() {
    dateController.text = widget.pub.eventDate.toString().split(" ")[0];
    start_time = widget.pub.event_start!;
    end_time = widget.pub.event_end!;
    recurrentValue = recurrentOpt.first;
    titleController.text = widget.pub.title;
    descController.text = widget.pub.desc;
    super.initState();
    for (var area in widget.areas) {
      if (area.subareas != null) {
        for (var subArea in area.subareas!) {
          if (subArea.id == widget.pub.subCategory) {
            selectedArea = area;
            selectedSubArea = subArea;
          }
        }
      }
    }
  }

  void rigthCallBack(context) {
    print('search');
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    dateController.dispose();
    descController.dispose();
  }

  List<AreaClass> subAreas = [];
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: MyAppBar(
            iconR: const Icon(Icons.close),
            title: 'Edit',
            rightCallback: rigthCallBack),
        body: SingleChildScrollView(
          child: Form(
            key: _eventKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Title',
                    style: TextStyle(fontSize: 22),
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please insert title';
                      }
                      return null;
                    },
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  _selectedImage == null
                      ? GestureDetector(
                          onTap: () {
                            _pickImageFromGallery();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            height: 220,
                            child: Center(
                              child: Image.network(
                                'https://backendpint-w3vz.onrender.com/uploads/${widget.pub.img!.path}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: const Color.fromARGB(
                                        255, 255, 204, 150),
                                    height: 170,
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            _pickImageFromGallery();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(
                                  20), // Specifies the border radius
                              border: Border.all(
                                color: Colors.transparent, // Border color
                                width: 2, // Border width
                              ),
                            ),
                            height: 220,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 22),
                  ),
                  TextFormField(
                    onChanged: (text) {
                      descController.text = text;
                    },
                    textCapitalization: TextCapitalization.sentences,
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Body text (optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                    maxLines: null,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Location',
                    style: TextStyle(fontSize: 22),
                  ),
                  SearchLocation(
                    apiKey: 'AIzaSyA3epbybrdf3ULh-07utpw9CZV4S-hL450',
                    country: 'PT',
                    onSelected: (place) async {
                      final geolocation = await place.geolocation;

                      location =
                          '${geolocation?.coordinates.latitude} ${geolocation?.coordinates.longitude}';
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Text(
                        'Recurrent (weekly/monthly):',
                        style: TextStyle(fontSize: 22),
                      ),
                      const SizedBox(height: 30),
                      Checkbox(
                          value: widget.pub.recurring,
                          onChanged: (bool? value) {
                            setState(() {
                              widget.pub.recurring = value!;
                              if (widget.pub.recurring == true) {
                                dateOpt = 'Start Date';
                              } else {
                                dateOpt = 'Date';
                              }
                            });
                          }),
                    ],
                  ),
                  //If the event is recurrent
                  //Add a dropdown to select type
                  if (widget.pub.recurring)
                    Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: colorScheme.onPrimary),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: DropdownButton<String>(
                        underline: SizedBox.shrink(),
                        isExpanded: true,
                        value: recurrentValue,
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            recurrentValue = value!;
                          });
                        },
                        items: recurrentOpt
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  dateContent(colorScheme, _eventKey),
                  const Text(
                    'Time',
                    style: TextStyle(fontSize: 22),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme
                            .onPrimary, // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                      borderRadius: BorderRadius.circular(
                          8.0), // Optional: Add rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${start_time.hour}:${start_time.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(fontSize: 24),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    final TimeOfDay? timeOfDay =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: start_time,
                                            initialEntryMode:
                                                TimePickerEntryMode.dial);
                                    if (timeOfDay != null) {
                                      setState(() {
                                        start_time = timeOfDay;
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Choose start time',
                                    style:
                                        TextStyle(color: colorScheme.onPrimary),
                                  ))
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${end_time.hour}:${end_time.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(fontSize: 24),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    final TimeOfDay? timeOfDay =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: end_time,
                                            initialEntryMode:
                                                TimePickerEntryMode.dial);
                                    if (timeOfDay != null) {
                                      setState(() {
                                        end_time = timeOfDay;
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Choose end time',
                                    style:
                                        TextStyle(color: colorScheme.onPrimary),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const Text(
                    'Area',
                    style: TextStyle(fontSize: 22),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.onPrimary),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0))),
                    child: DropdownButton<AreaClass>(
                      isExpanded: true,
                      hint: const Text('Select Area'),
                      underline: const SizedBox.shrink(),
                      value: selectedArea,
                      items: widget.areas.map((AreaClass area) {
                        return DropdownMenuItem<AreaClass>(
                          value: area,
                          child: Text(area.areaName),
                        );
                      }).toList(),
                      onChanged: (AreaClass? value) {
                        setState(() {
                          selectedArea = value!;
                          selectedSubArea = selectedArea.subareas![0];
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Sub Area',
                    style: TextStyle(fontSize: 22),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.onPrimary),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0))),
                    child: DropdownButton<AreaClass>(
                      isExpanded: true,
                      hint: const Text('Select Sub Area'),
                      underline: const SizedBox.shrink(),
                      value: selectedSubArea,
                      items: selectedArea.subareas!.map((AreaClass area) {
                        return DropdownMenuItem<AreaClass>(
                          value: area,
                          child: Text(area.areaName),
                        );
                      }).toList(),
                      onChanged: (AreaClass? value) {
                        setState(() {
                          selectedSubArea = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary),
                    onPressed: () async {
                      if (_eventKey.currentState!.validate()) {
                        print(dateController.text);
                        User user = (await bd.getUser())!;
                        Event post = Event(
                            widget.pub.id,
                            user,
                            descController.text,
                            titleController.text,
                            false,
                            selectedSubArea.id,
                            DateTime.now(),
                            _selectedImage,
                            location,
                            DateTime.parse(dateController.text),
                            recurrent,
                            recurrentValue,
                            start_time,
                            end_time);
                        try {
                          await api.editEvent(post);
                        } catch (e) {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Error editing post'),
                              content: const Text(
                                  'An error occurred while editing the Post'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/home'); // Close the dialog
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                        Navigator.pushNamed(context, '/home');
                      }
                    },
                    child: Text('Edit Event',
                        style: TextStyle(color: colorScheme.onPrimary)),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Container dateContent(ColorScheme colorScheme, GlobalKey key) {
    return Container(
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please insert date';
          }
          return null;
        },
        controller: dateController,
        onTap: () {
          _selectDate();
        },
        readOnly: true,
        decoration: InputDecoration(
            suffixIcon: const Icon(Icons.calendar_today),
            label: Text(
              "Date",
              style: TextStyle(color: colorScheme.onPrimary),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: colorScheme.primary))),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now().add(const Duration(days: 7)),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        initialDate: DateTime.now().add(const Duration(days: 7)));
    if (_picked != null) {
      setState(() {
        dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  Future _pickImageFromGallery() async {
    try {
      final returnedImg =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (returnedImg != null) {
        setState(() {
          _selectedImage = File(returnedImg.path);
        });
      }
    } on PlatformException {
      // Silently ignore PlatformException
    }
  }
}
