import 'package:flutter/material.dart';
import 'package:softshares/Components/appBar.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import './classes/user.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  Map<String, bool> checkBoxSelected = {
    'Education': false,
    'Gastronomy': false,
    'Health': false,
    'Housing': false,
    'Leisure': false,
    'Sports': false,
    'Transports': false
  };

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  User user = User('Guilherme', 'Pedrinho', 'Software Engineer', 'Viseu',
      "email@example.com", 23, 09, 2001);

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
    nameController.text = "${user.firstname}  ${user.lastName}";
    emailController.text = user.email;
    dateController.text = "${user.year}-${user.month}-${user.day}";
    cityController.text = user.location;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    dateController.dispose();
    cityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(iconR: const Icon(Icons.close), title: 'Edit Profile'),
      drawer: myDrawer(location: 'Viseu'),
      bottomNavigationBar: MyBottomBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profilePicture(),
            //Name
            nameContent(),
            //Email
            emailContent(),
            //Date
            dateContent(),
            //City
            cityContent(),
            Container(
              height: 30,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: const Text(
                'Preferences',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            //Preferences
            preferencesContent(),
            const SizedBox(
              height: 70,
            ),
            saveBtn(context)
          ],
        ),
      ),
    );
  }

  Container saveBtn(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 20, right: 20),
      height: 45,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF80ADD7),
          ),
          onPressed: () => {Navigator.pop(context)},
          child: const Text('Save changes')),
    );
  }

  Container preferencesContent() {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.checkBoxSelected.length,
              itemBuilder: (context, index) {
                String key = widget.checkBoxSelected.keys.elementAt(index);
                bool value = widget.checkBoxSelected.values.elementAt(index);
                return CheckboxListTile(
                  title: Text(key),
                  value: value,
                  onChanged: (newValue) {
                    setState(() {
                      widget.checkBoxSelected[key] = newValue!;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Container cityContent() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        controller: cityController,
        decoration: const InputDecoration(
            label: Text(
              'City',
              style: TextStyle(color: Color(0xFF79747E)),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff80ADD7)))),
      ),
    );
  }

  Container dateContent() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        controller: dateController,
        onTap: () {
          _selectDate();
        },
        decoration: const InputDecoration(
            suffixIcon: Icon(Icons.calendar_today),
            label: Text(
              "Date",
              style: TextStyle(color: Color(0xFF79747E)),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff80ADD7)))),
      ),
    );
  }

  Container emailContent() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        controller: emailController,
        decoration: const InputDecoration(
            label: Text(
              "Email",
              style: TextStyle(color: Colors.black),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff80ADD7)))),
      ),
    );
  }

  Container nameContent() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        controller: nameController,
        decoration: const InputDecoration(
            label: Text(
              "Name",
              style: TextStyle(color: Colors.black),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff80ADD7)))),
      ),
    );
  }

  Container profilePicture() {
    return Container(
      height: 220,
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          height: 170,
          width: 170,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent, width: 3),
              borderRadius: BorderRadius.circular(95)),
          child: Center(
            child: Stack(children: [
              Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(75),
                      color: Color(0xff00C2FF)),
                  child: Center(
                    child: Text(
                      user.lastName[0],
                      style: TextStyle(fontSize: 54, color: Colors.white),
                    ),
                  )),
              Positioned(
                top: 105,
                left: 105,
                child: Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xff00C2FF), width: 3),
                      borderRadius: BorderRadius.circular(95)),
                  child: Center(
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        color: Color(0xff00C2FF),
                        size: 22,
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
