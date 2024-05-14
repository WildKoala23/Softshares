import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class customRadioBtnForm extends StatefulWidget {
  customRadioBtnForm({super.key});

  Color containerColor = const Color(0xFFFEF7FF);
  Color appBarColor = const Color(0xff80ADD7);
  Color appBarFont = const Color(0xFFFFFFFF);
  Color mainColor = const Color(0xff80ADD7);

  @override
  State<customRadioBtnForm> createState() => _customRadioBtnState();
}

class _customRadioBtnState extends State<customRadioBtnForm> {
  TextEditingController labelController = TextEditingController();
  /*Number of options controller */
  TextEditingController numOptController = TextEditingController();

  /*List of controllers to controll user defined textfields*/
  List<TextEditingController> controllers = [];

  /*Options that the user has created*/
  List<String> options = [];
  /*Label to the Radio Button in the form*/
  String label = '';

  /*Number of options to spawn*/
  int opt_num = 1;

  void clearIndexControllers() {
    for (int i = 0; i < opt_num; i++) {
      controllers.remove(TextEditingController());
    }
  }

  void addControllers() {
    for (int i = 0; i < opt_num; i++) {
      controllers.add(TextEditingController());
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers based on the itemCount
    addControllers();
    /*Placeholder*/
    numOptController.text = "1";
    labelController.text = "Label";
  }

  @override
  void dispose() {
    super.dispose();
    labelController.dispose();
    numOptController.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.appBarColor,
        foregroundColor: widget.appBarFont,
        leading: const Icon(Icons.close),
        title: const Text('Create Radio Button'),
        actions: const [Icon(Icons.check)],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              child: Text(
                'Label',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            labelContent(),
            const SizedBox(
                child: Text(
              'Number of options',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
            numOptionContent(),
            Expanded(
              child: ListView.builder(
                  itemCount: opt_num,
                  itemBuilder: (context, index) {
                    return Container(
                      child: TextField(
                        /*Assign controller based on index */
                        controller: controllers[index],
                        decoration:
                            InputDecoration(labelText: 'Option ${index + 1}'),
                      ),
                    );
                  }),
            )
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
            setState(() {
              clearIndexControllers();
              opt_num = int.parse(numOptController.text);
              addControllers();
            });
          } catch (e) {
            print('Error parsing string to integer: $e');
            opt_num = 1;
          }
        },
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF49454F)))),
      ),
    );
  }

  Container labelContent() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: labelController,
        onSubmitted: (value) {
          label = labelController.text;
        },
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF49454F)))),
      ),
    );
  }
}
