import 'package:flutter/material.dart';

class ChooseCityPage extends StatefulWidget {
  const ChooseCityPage({super.key});

  @override
  State<ChooseCityPage> createState() => _ChooseCityPageState();
}

Map<String, String> cities = {
  'Tomar': 'lib/images/tomar.jpg',
  'Viseu': 'lib/images/viseu.jpg',
  'Fundão': 'lib/images/Fundao.jpg',
  'Portoalegre': 'lib/images/Portalegre.jpg',
  'Vilareal': 'lib/images/vilareal.jpg'
};

class _ChooseCityPageState extends State<ChooseCityPage> {
  late String city;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Choose city',
            style: TextStyle(fontSize: 28),
          ),
          centerTitle: true,
        ),
        body: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cities.length,
            itemBuilder: (context, index) {
              var entry = cities.entries.elementAt(index);
              var key = entry.key;
              var value = entry.value;
              return GestureDetector(
                onTap: () {
                  city = key;
                  print('Choosen city: ${key}');
                  Navigator.pop(context, {'index': index + 1});
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 50, 10, 50),
                  child: cityCard(context, key, value),
                ),
              );
            }));
  }

  Container cityCard(BuildContext context, String city, String imagePath) {
    return Container(
        width: 320,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              city,
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ));
  }
}
