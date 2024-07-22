import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:softshares/Components/customCheckbox.dart';
import 'package:softshares/Components/customRadioBtn.dart';
import 'package:softshares/Components/customTextField.dart';
import 'package:softshares/Components/formAppBar.dart';

class createForm extends StatefulWidget {
  createForm({super.key});

  @override
  State<createForm> createState() => _MyWidgetState();

  Color containerColor = const Color(0xFFFEF7FF);
  Color appBarColor = const Color(0xff80ADD7);
  Color appBarFont = const Color(0xFFFFFFFF);
  Color mainColor = const Color(0xff80ADD7);
}

const List<String> options = [
  "Radio Button",
  "Checkbox",
  "Text/Numeric Input",
];
List<Widget> formItens = [];

Map<String, List<String>> form_info = {};

class _MyWidgetState extends State<createForm> {
  String currentOption = options[0];

  void addItemToList(Widget item) {
    setState(() {
      formItens.add(item);
    });
  }

  void sendForm() {
    var data = jsonEncode(form_info);
    print(data);
    // API method to send the data
  }

  // Removes info from map
  void removeInfo(int index) {
    var keyList = form_info.keys.toList();

    var keyToRemove = keyList[index];
    //print(form_info[keyToRemove]);
    form_info.remove(keyToRemove);
  }

  // Adds label and options to a map to send to the database
  void addInfo(String label, List<String>? options, String type) {
    form_info[label] = [];
    if (options != null) {
      for (var option in options) {
        form_info[label]!.add(option);
      }
    }
    form_info[label]!.add(type);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Form'),
        leading: const Icon(Icons.close),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        actions: [
          IconButton(
              onPressed: () {
                sendForm();
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(),
              Expanded(
                // Wrap ListView.builder with Expanded
                child: ListView.builder(
                  itemCount: formItens.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Material(
                        elevation: 1.5,
                        borderOnForeground: false,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 10, bottom: 10, right: 10),
                          decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              border: Border.all(
                                color: Colors.transparent,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                            children: [
                              formItens[index],
                              Positioned(
                                top: 8,
                                right: 8,
                                child: IconButton(
                                  icon: Icon(Icons.delete,
                                      color: colorScheme.onSecondary),
                                  onPressed: () {
                                    removeInfo(index);
                                    setState(() {
                                      formItens.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, top: 15),
                child: addItem(context, colorScheme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton addItem(BuildContext context, ColorScheme colorScheme) {
    return ElevatedButton(
      style: ButtonStyle(
          foregroundColor:
              MaterialStateProperty.all<Color>(colorScheme.onPrimary),
          backgroundColor:
              MaterialStateProperty.all<Color>(colorScheme.primary)),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return formBottomSheet(setState, context, colorScheme);
            });
          },
        );
      },
      child: const Text('Add Items'),
    );
  }

  Container formBottomSheet(
      StateSetter setState, BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        color: colorScheme.primaryContainer,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RadioListTile(
              title: Text(
                options[0],
                style: const TextStyle(fontSize: 24),
              ),
              value: options[0],
              groupValue: currentOption,
              onChanged: (value) {
                setState(() {
                  currentOption = value.toString();
                });
              }),
          RadioListTile(
              title: Text(options[1], style: const TextStyle(fontSize: 24)),
              value: options[1],
              groupValue: currentOption,
              onChanged: (value) {
                setState(() {
                  currentOption = value.toString();
                });
              }),
          RadioListTile(
              title: Text(options[2], style: const TextStyle(fontSize: 24)),
              value: options[2],
              groupValue: currentOption,
              onChanged: (value) {
                setState(() {
                  currentOption = value.toString();
                });
              }),
          ElevatedButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(colorScheme.onPrimary),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(colorScheme.primary),
                  elevation: MaterialStateProperty.all(10)),
              onPressed: () async {
                String route = '';
                Widget? item;

                /*Handles the type of input the user wants to add*/
                /*Single char are to identify the type of input in the database*/
                switch (currentOption) {
                  case "Radio Button":
                    route = "/createRadioBtnForm";
                    final result = await Navigator.pushNamed(context, route);
                    if (result != null && result is Map<String, dynamic>) {
                      item = customRadioBtn(
                          label: result["userLabel"],
                          options: result["options"]);
                      addInfo(result["userLabel"], result["options"], "R");
                    }
                    break;
                  case "Checkbox":
                    final result = await Navigator.pushNamed(
                        context, "/createCheckboxForm");
                    if (result != null && result is Map<String, dynamic>) {
                      item = customCheckbox(
                          label: result["userLabel"],
                          options: result["options"]);
                      addInfo(result["userLabel"], result["options"], "C");
                    }

                    break;
                  case "Text/Numeric Input":
                    //route = "/createFieldTextForm";
                    final result = await Navigator.pushNamed(
                        context, "/createFieldTextForm");
                    if (result != null && result is Map<String, dynamic>) {
                      addInfo(result["userLabel"], null, "T");
                      item = customTextField(
                          label: result["userLabel"],
                          numericInput: result["numeric"]);
                    }
                    break;
                }
                /*Add new item to the form list*/
                if (item != null) {
                  addItemToList(item);
                }
                Navigator.pop(context);
              },
              child: Container(
                width: 150,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Add',
                      style: TextStyle(fontSize: 18),
                    ),
                    Icon(Icons.add)
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
