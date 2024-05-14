import 'package:flutter/material.dart';
import 'package:softshares/Components/customRadioBtn.dart';
import 'package:softshares/Components/customTextField.dart';

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
  "TextField",
  "Number Input"
];

class _MyWidgetState extends State<createForm> {
  List<Widget> formItens = [customTextField(label: 'Name')];
  String currentOption = options[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.appBarColor,
        foregroundColor: widget.appBarFont,
        leading: const Icon(Icons.close),
        title: const Text('Create Form'),
        actions: const [Icon(Icons.check)],
      ),
      body: Center(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          const SizedBox(),
          Expanded(
              child: Container(
                  child: ListView.builder(
                      itemCount: formItens.length,
                      itemBuilder: (contex, index) {
                        return formItens[index];
                      }))),
          ElevatedButton(
            style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all<Color>(widget.mainColor)),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return formBottomSheet(setState, context);
                  });
                },
              );
            },
            child: const Text('Add Items'),
          ),
        ]),
      ),
    );
  }

  Container formBottomSheet(StateSetter setState, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        color: widget.containerColor,
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
          RadioListTile(
              title: Text(options[3], style: const TextStyle(fontSize: 24)),
              value: options[3],
              groupValue: currentOption,
              onChanged: (value) {
                setState(() {
                  currentOption = value.toString();
                });
              }),
          ElevatedButton(
              style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all<Color>(widget.mainColor),
              ),
              onPressed: () async {
                String route = '';
                Widget? item;
                /*Handles the type of input the user wants to add*/
                switch (currentOption) {
                  case "Radio Button":
                    route = "/createRadioBtnForm";
                    final result = await Navigator.pushNamed(context, route);
                    if (result != null && result is Map<String, dynamic>) {
                      item = customRadioBtn(
                          label: result["userLabel"],
                          options: result["options"]);
                    }
                    print(currentOption);
                    break;
                  case "Checkbox":
                    print(currentOption);
                    break;
                  case "TextField":
                    print(currentOption);
                    break;
                  case "Number Input":
                    print(currentOption);
                    break;
                }
                /*Add new item to the form list*/
                if (item != null) {
                  setState(() {
                    formItens.add(item!);
                  });
                }
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

  Scaffold radioBtnConf(BuildContext context) {
    List<String> optionsRadio = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.appBarColor,
        foregroundColor: widget.appBarFont,
        leading: const Icon(Icons.close),
        title: const Text('Create Radio Button'),
        actions: const [Icon(Icons.check)],
      ),
      body: Column(
        children: [
          ElevatedButton(
            style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all<Color>(widget.mainColor)),
            onPressed: () {
              print("It is I, Pajama Man");
              Navigator.pop(context);
            },
            child: const Text('Add Radio Button'),
          ),
        ],
      ),
    );
  }
}
