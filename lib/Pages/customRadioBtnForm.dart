import 'package:flutter/material.dart';

class customRadioBtnForm extends StatefulWidget {
  customRadioBtnForm({super.key});

  Color containerColor = const Color(0xFFFEF7FF);
  Color appBarColor = const Color(0xff80ADD7);
  Color appBarFont = const Color(0xFFFFFFFF);
  Color mainColor = const Color(0xff80ADD7);

  @override
  State<customRadioBtnForm> createState() => _CustomRadioBtnState();
}

class _CustomRadioBtnState extends State<customRadioBtnForm> {
  TextEditingController labelController = TextEditingController();
  TextEditingController numOptController = TextEditingController();

  List<TextEditingController> controllers = [];
  List<String> options = [];
  String userLabel = '';
  int opt_num = 1;

  void clearIndexControllers() {
    for (var controller in controllers) {
      controller.dispose();
    }
    controllers.clear();
  }

  void addControllers(int count) {
    for (int i = 0; i < count; i++) {
      controllers.add(TextEditingController());
    }
  }

  @override
  void initState() {
    super.initState();
    addControllers(opt_num);
    numOptController.text = "1";
  }

  @override
  void dispose() {
    labelController.dispose();
    numOptController.dispose();
    clearIndexControllers();
    super.dispose();
  }

  int returnValues() {
    options.clear();
    int result = 1;
    setState(() {
      if (labelController.text == '') {
        result = -1;
      }
      userLabel = labelController.text;
      for (var controller in controllers) {
        if (controller.text.isEmpty) {
          result = 0;
          break;
        }
        options.add(controller.text);
      }
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.appBarColor,
        foregroundColor: widget.appBarFont,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context, null),
        ),
        title: const Text('Create Radio Button'),
        actions: [
          IconButton(
            onPressed: () {
              if (returnValues() == 1) {
                Navigator.pop(
                    context, {"userLabel": userLabel, "options": options});
              } else {
                print('Invalid options');
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Label',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            labelContent(),
            const Text(
              'Number of options',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            numOptionContent(),
            Expanded(
              child: ListView.builder(
                itemCount: controllers.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      controller: controllers[index],
                      decoration:
                          InputDecoration(labelText: 'Option ${index + 1}'),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: addBtn()),
            ),
          ],
        ),
      ),
    );
  }

  Container numOptionContent() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: numOptController,
        onSubmitted: (value) {
          try {
            int newOptNum = int.parse(numOptController.text);
            if (newOptNum > 0) {
              setState(() {
                opt_num = newOptNum;
                clearIndexControllers();
                addControllers(opt_num);
              });
            } else {
              showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                          'Invalid number of options!Must be a positive number'),
                      content:
                          const Text('Please insert valid number of options'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'Try again');
                            },
                            child: const Text('Try again'))
                      ],
                    );
                  });
              setState(() {
                numOptController.text = "1";
                opt_num = 1;
              });
            }
          } catch (e) {
            print(e);
          }
        },
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF49454F)),
          ),
        ),
      ),
    );
  }

  Container labelContent() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: labelController,
        onSubmitted: (value) {
          userLabel = labelController.text;
        },
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
          label: Text('Label'),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF49454F)),
          ),
        ),
      ),
    );
  }

  ElevatedButton addBtn() {
    return ElevatedButton(
      onPressed: () {
        int result = returnValues();
        //If there is null options
        if (result == -1) {
          showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Invalid label. Must not be empty'),
                  content: const Text('Please insert valid label'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'Try again');
                        },
                        child: const Text('Try again'))
                  ],
                );
              });
        }
        //If a label is null
        else if (result == 0) {
          showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Invalid options. Must not be empty'),
                  content: const Text('Please insert valid options'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'Try again');
                        },
                        child: const Text('Try again'))
                  ],
                );
              });
        } else {
          Navigator.pop(context, {"userLabel": userLabel, "options": options});
        }
      },
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(widget.mainColor),
      ),
      child: Text('Add Fieldtext'),
    );
  }
}
