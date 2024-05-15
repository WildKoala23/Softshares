import 'package:flutter/material.dart';

class customFieldtextForm extends StatefulWidget {
  customFieldtextForm({super.key});

  Color containerColor = const Color(0xFFFEF7FF);
  Color appBarColor = const Color(0xff80ADD7);
  Color appBarFont = const Color(0xFFFFFFFF);
  Color mainColor = const Color(0xff80ADD7);

  @override
  State<customFieldtextForm> createState() => _customFieldtextFormState();
}

class _customFieldtextFormState extends State<customFieldtextForm> {
  TextEditingController userLabelController = TextEditingController();

  String userLabel = '';
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    userLabelController.text = 'Label';
  }

  @override
  void dispose() {
    super.dispose();
    userLabelController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 25, top: 20, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text('Label',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                TextField(
                  controller: userLabelController,
                  onSubmitted: (value) {
                    userLabel = userLabelController.text;
                  },
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF49454F)))),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 25, top: 20, right: 25),
            child: Row(
              children: [
                SizedBox(
                  child: Text(
                    'Numeric input ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: widget.appBarColor,
      foregroundColor: widget.appBarFont,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => {Navigator.pop(context, null)},
      ),
      title: const Text('Create Fieldtext'),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pop(context, {"userLabel":userLabel,"numeric": isChecked});
            },
            icon: const Icon(Icons.check))
      ],
    );
  }
}
