import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:softshares/classes/db.dart';

// ignore: must_be_immutable, camel_case_types
class myDrawer extends StatefulWidget {
  myDrawer({super.key});

  @override
  State<myDrawer> createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {
  late String cityName; // Change with user's city
  final SQLHelper bd = SQLHelper.instance;
  final box = GetStorage();
  late int cityId = box.read('selectedCity');

  Future<bool> _getCity(int id) async {
    var data = await bd.getCityName(id);
    // await bd.checkTable();
    setState(() {
      cityId = box.read('selectedCity');
      cityName = data!;
    });
    return true;
  }

  Map<String, Icon> areas = {
    "Education": const Icon(Icons.school),
    "Gastronomy": const Icon(Icons.restaurant),
    "Health": const Icon(Icons.local_hospital),
    "Housing": const Icon(Icons.house),
    "Leisure": const Icon(Icons.live_tv),
    "Sports": const Icon(Icons.sports),
    "Transports": const Icon(Icons.train)
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      width: 262,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          SafeArea(
              child: FutureBuilder(
            future: _getCity(cityId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return header(colorScheme, context);
              } else {
                return (Center(
                  child: CircularProgressIndicator(),
                ));
              }
            },
          )),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Calendar'),
            onTap: () {
              Navigator.pushNamed(context, '/Calendar');
            },
          ),
          ListTile(
            leading: const Icon(Icons.pin_drop),
            title: const Text('Points of interest - POI'),
            onTap: () {
              Navigator.pushNamed(context, '/PointOfInterest');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/Profile');
            },
          ),
          const Divider(
            height: 0,
            thickness: 2,
            indent: 25,
            endIndent: 25,
          ),
          const ListTile(
            contentPadding: EdgeInsets.only(left: 25),
            title: Text('Areas',
                style: TextStyle(
                  fontSize: 14,
                )),
          ),
          Column(
            children: areas.entries
                .map((e) => areaTile(e.key, e.value, context))
                .toList(),
          ),
        ],
      ),
    );
  }

  Container header(ColorScheme scheme, BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      //alignment: Alignment.bottomCenter,
      height: 80,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1)),
              elevation: 0,
              backgroundColor: Colors.transparent),
          onPressed: () async {
            final selectedCity =
                await Navigator.pushNamed(context, '/chooseCity');
            if (selectedCity != null && selectedCity is Map<String, dynamic>) {
              box.write('selectedCity', selectedCity['index']);
              _getCity(selectedCity['index']);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_history,
                    color: scheme.onSecondary,
                    size: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    cityName,
                    style: TextStyle(fontSize: 24, color: scheme.onSecondary),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_right,
                size: 40,
                color: scheme.onSecondary,
              ),
            ],
          )),
    );
  }

  ListTile areaTile(String title, Icon icon, context) {
    final String route = '/$title';
    return ListTile(
      leading: icon,
      title: Text(title),
      onTap: () => {Navigator.pushNamed(context, route)},
    );
  }
}
