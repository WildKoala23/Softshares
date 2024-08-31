import 'package:flutter/material.dart';
import 'package:softshares/Components/appBar.dart';
import 'package:softshares/Components/bottomNavBar.dart';
import 'package:softshares/Components/drawer.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/areaClass.dart';
import 'package:softshares/classes/db.dart';
import '../classes/user.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key, required this.areas, required this.user});

  List<AreaClass> areas;
  User user;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  SQLHelper bd = SQLHelper.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Map<AreaClass, bool> checkBoxSelected = {};
  Map<AreaClass, List<AreaClass>> current_prefs = {};
  Map<AreaClass, List<AreaClass>> new_prefs = {};
  API api = API();
  bool isLoading = true;

  //Get user prefences from database
  Future getPrefs() async {
    current_prefs = await api.getPrefs(widget.user.id);
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  Future savePrefs() async {
    List<AreaClass> newPrefs = [];
    checkBoxSelected.forEach((area, checked) {
      if (checked == true) {
        newPrefs.add(area);
      }
    });
    await bd.insertPreference(newPrefs);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
  }

  /*Callback function to exit screen */
  void closeCallback(context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: MyAppBar(
        iconR: const Icon(Icons.close),
        title: 'Edit Profile',
        rightCallback: closeCallback,
      ),
      drawer: myDrawer(
        areas: widget.areas,
      ),
      bottomNavigationBar: MyBottomBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profilePicture(colorScheme),
            //Name
            Container(
              height: 30,
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: const Text(
                'Preferences',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            //Preferences
            preferencesContent(colorScheme),
            const SizedBox(
              height: 70,
            ),
            saveBtn(context, colorScheme)
          ],
        ),
      ),
    );
  }

  Container saveBtn(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 20, right: 20),
      height: 45,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: colorScheme.onPrimary,
            backgroundColor: colorScheme.primary,
          ),
          onPressed: () async {
            await savePrefs();
            Navigator.pushNamed(context, '/home');
          },
          child: const Text('Save changes')),
    );
  }

  Container preferencesContent(ColorScheme colorScheme) {
    return Container(
      height: 300,
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration:
          BoxDecoration(border: Border.all(color: colorScheme.onSecondary)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            isLoading == false
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: checkBoxSelected.length,
                    itemBuilder: (context, index) {
                      AreaClass key = checkBoxSelected.keys.elementAt(index);
                      bool value = checkBoxSelected.values.elementAt(index);
                      return CheckboxListTile(
                        title: Text(key.areaName),
                        value: value,
                        onChanged: (newValue) {
                          print(key.id);
                          setState(() {
                            checkBoxSelected[key] = newValue!;
                          });
                        },
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }

  Container emailContent(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
            label: Text(
              "Email",
              style: TextStyle(color: colorScheme.onTertiary),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: colorScheme.primary))),
      ),
    );
  }

  Container nameContent(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: TextField(
        controller: nameController,
        decoration: InputDecoration(
            label: Text(
              "Name",
              style: TextStyle(color: colorScheme.onTertiary),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: colorScheme.primary))),
      ),
    );
  }

  Container profilePicture(ColorScheme colorScheme) {
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
                      color: colorScheme.secondary),
                  child: Center(
                    child: Text(
                      widget.user.lastName[0],
                      style:
                          TextStyle(fontSize: 54, color: colorScheme.onPrimary),
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
                      border:
                          Border.all(color: colorScheme.secondary, width: 3),
                      borderRadius: BorderRadius.circular(95)),
                  child: Center(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit,
                        color: colorScheme.secondary,
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
