import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class createPost extends StatefulWidget {
  const createPost({Key? key}) : super(key: key);

  @override
  State<createPost> createState() => _CreatePostState();
}

List<String> areas = [
  "Education",
  "Gastronomy",
  "Health",
  "Housing",
  "Leisure",
  "Sports",
  "Transports"
];

class _CreatePostState extends State<createPost> {
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String? selectedOption;
  late double currentSlideValue;
  late double currentPriceValue;
  //Variables to en/disable rating and price sliders when not necessary
  late bool nonRating;
  late bool nonPrice;
  List<String> recurrentOpt = ["Weekly", "Monthly"];
  //Depending on the recurrency, the label for date changes (This variable controls the text)
  String? dateOpt;

  bool recurrent = false;
  late String recurrentValue;

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        firstDate: DateTime(1970),
        lastDate: DateTime(2026),
        initialDate: DateTime.now());
    if (_picked != null) {
      setState(() {
        dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedOption = areas[0];
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
                  eventContent(colorScheme),
                  forumContent(colorScheme),
                  poiContent(colorScheme, context),
                  postContent(colorScheme, context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView poiContent(
      ColorScheme colorScheme, BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              child: Text(
                'Title',
                style: TextStyle(fontSize: 22),
              ),
            ),
            TextField(
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
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                print('Selected Images');
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(18.0),
                ),
                height: 221,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image),
                      Text('Add Image +'),
                    ],
                  ),
                ),
              ),
            ),

            Text(
              'Description',
              style: TextStyle(fontSize: 22),
            ),
            TextField(
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
            const SizedBox(
              height: 30,
            ),
            Text(
              'Location',
              style: TextStyle(fontSize: 22),
            ),
            //IMPLEMENT WITH GOOGLE API//
            const TextField(
              //IMPLEMENT WITH GOOGLE API//
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Area',
              style: TextStyle(fontSize: 22),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.onPrimary),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Select Area'),
                underline: SizedBox.shrink(),
                value: selectedOption,
                items: areas.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Rating',
              style: TextStyle(fontSize: 22),
            ),
            Slider(
              min: 1,
              max: 5,
              value: currentSlideValue,
              onChanged: (double value) {
                setState(() {
                  currentSlideValue = value;
                });
              },
              divisions: 4,
              label: currentSlideValue.toString(),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(
                'Advance',
                style: TextStyle(color: colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView forumContent(ColorScheme colorScheme) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Title',
              style: TextStyle(fontSize: 22),
            ),
            TextField(
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
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                print('Selected Images');
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(18.0),
                ),
                height: 221,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image),
                      Text('Add Image +'),
                    ],
                  ),
                ),
              ),
            ),
            const Text(
              'Description',
              style: TextStyle(fontSize: 22),
            ),
            TextField(
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
              'Area',
              style: TextStyle(fontSize: 22),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.onPrimary),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Select Area'),
                underline: SizedBox.shrink(),
                value: selectedOption,
                items: areas.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              child: Text('Create Forum',
                  style: TextStyle(color: colorScheme.onPrimary)),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView eventContent(ColorScheme colorScheme) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Title',
              style: TextStyle(fontSize: 22),
            ),
            TextField(
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
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                print('Selected Images');
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(18.0),
                ),
                height: 221,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image),
                      Text('Add Image +'),
                    ],
                  ),
                ),
              ),
            ),
            const Text(
              'Description',
              style: TextStyle(fontSize: 22),
            ),
            TextField(
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
            Row(
              children: [
                const Text(
                  'Recurrent (weekly/monthly):',
                  style: TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 30),
                Checkbox(
                    value: recurrent,
                    onChanged: (bool? value) {
                      setState(() {
                        recurrent = value!;
                        if (recurrent == true) {
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
            if (recurrent)
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
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
            const SizedBox(height: 30),
            Text(
              dateOpt!,
              style: TextStyle(fontSize: 22),
            ),
            dateContent(colorScheme),
            const SizedBox(height: 30),
            const Text(
              'Area',
              style: TextStyle(fontSize: 22),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.onPrimary),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Select Area'),
                underline: SizedBox.shrink(),
                value: selectedOption,
                items: areas.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/createForm');
              },
              child: Text('Advance',
                  style: TextStyle(color: colorScheme.onPrimary)),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView postContent(
      ColorScheme colorScheme, BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              child: Text(
                'Title',
                style: TextStyle(fontSize: 22),
              ),
            ),
            TextField(
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
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                print('Selected Images');
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(18.0),
                ),
                height: 221,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image),
                      Text('Add Image +'),
                    ],
                  ),
                ),
              ),
            ),

            Text(
              'Description',
              style: TextStyle(fontSize: 22),
            ),
            TextField(
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
            const SizedBox(
              height: 30,
            ),
            Text(
              'Location',
              style: TextStyle(fontSize: 22),
            ),
            //IMPLEMENT WITH GOOGLE API//
            const TextField(
              //IMPLEMENT WITH GOOGLE API//
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Area',
              style: TextStyle(fontSize: 22),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.onPrimary),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Select Area'),
                underline: SizedBox.shrink(),
                value: selectedOption,
                items: areas.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Text(
                  'Rating',
                  style: TextStyle(fontSize: 22),
                ),
                Checkbox(
                    value: nonRating,
                    onChanged: (value) {
                      setState(() {
                        nonRating = value!;
                      });
                    })
              ],
            ),
            if (nonRating)
              Slider(
                min: 1,
                max: 5,
                value: currentSlideValue,
                onChanged: (double value) {
                  setState(() {
                    currentSlideValue = value;
                  });
                },
                divisions: 4,
                label: currentSlideValue.toString(),
              ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Text(
                  'Price',
                  style: TextStyle(fontSize: 22),
                ),
                Checkbox(
                    value: nonPrice,
                    onChanged: (value) {
                      setState(() {
                        nonPrice = value!;
                      });
                    })
              ],
            ),
            if (nonPrice)
              Slider(
                min: 1,
                max: 4,
                value: currentPriceValue,
                onChanged: (double value) {
                  setState(() {
                    currentPriceValue = value;
                  });
                },
                divisions: 3,
                label: currentPriceValue.toString(),
              ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Advance',
                  style: TextStyle(color: colorScheme.onPrimary)),
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

  Container dateContent(ColorScheme colorScheme) {
    return Container(
      child: TextField(
        controller: dateController,
        onTap: () {
          _selectDate();
        },
        readOnly: true,
        decoration: InputDecoration(
            suffixIcon: Icon(Icons.calendar_today),
            label: Text(
              "Date",
              style: TextStyle(color: colorScheme.onTertiary),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: colorScheme.primary))),
      ),
    );
  }
}
