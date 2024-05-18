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
        length: 3,
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
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  eventContent(colorScheme),
                  forumContent(colorScheme),
                  poiContent(colorScheme, context)
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
                  border: Border.all(),
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
              child: const Text('Advance'),
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
                  border: Border.all(),
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
              child: const Text('Create Forum'),
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
            const Text(
              'Date',
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
                  border: Border.all(),
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
              child: const Text('Advance'),
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
      title: Text('Create Post'),
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
