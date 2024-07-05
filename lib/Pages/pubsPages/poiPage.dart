import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:softshares/Components/formAppBar.dart';
import 'package:softshares/classes/ClasseAPI.dart';
import 'package:softshares/classes/POI.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class POIPage extends StatefulWidget {
  const POIPage({super.key, required this.poi});

  final POI poi;

  @override
  State<POIPage> createState() => _PostPageState();
}

class _PostPageState extends State<POIPage> {
  late GoogleMapController mapController;
  late LatLng local;
  API api = API();
  TextEditingController commentCx = TextEditingController();
  final _commentKey = GlobalKey<FormState>();

  LatLng convertCoord(String location) {
    List<String> coords = location.split(" ");
    double lat = double.tryParse(coords[0])!;
    double lon = double.tryParse(coords[1])!;
    return LatLng(lat, lon);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    local = convertCoord(widget.poi.location!);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: formAppbar(title: widget.poi.title),
        body: Stack(
          children: [SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                cardHeader(colorScheme),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.poi.title,
                  style: const TextStyle(fontSize: 26),
                ),
                widget.poi.img == null
                    ? Container(
                        color: Color.fromARGB(255, 159, 255, 150),
                        height: 120,
                      )
                    : Image.network(
                        'https://backendpint-w3vz.onrender.com/uploads/${widget.poi.img!.path}',
                        //Handles images not existing
                        errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Color.fromARGB(255, 159, 255, 150),
                          height: 120,
                        );
                      }),
                Row(
                  children: [
                    Text(widget.poi.desc),
                    Row(
                        children: List.generate(
                            widget.poi.aval.round(),
                            (start) => Icon(
                                  Icons.euro,
                                  color: colorScheme.secondary,
                                  size: 25,
                                )))
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                const Divider(
                  height: 0,
                  thickness: 2,
                  indent: 25,
                  endIndent: 25,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  height: 250,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: local,
                        zoom: 11.0,
                      ),
                      markers: {
                        Marker(markerId: MarkerId('Event'), position: local)
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Form(
                      key: _commentKey,
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter comment';
                          }
                          return null;
                        },
                        controller: commentCx,
                        decoration: InputDecoration(
                          label: const Text('Add comment'),
                          suffixIcon: IconButton(
                              onPressed: () async {
                                if (_commentKey.currentState!.validate()) {
                                  await api.createComment(
                                      widget.poi, commentCx.text);
                                }
                              },
                              icon: const Icon(Icons.send)),
                          border:
                              const OutlineInputBorder(borderSide: BorderSide()),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),]
        ));
  }

  Row cardHeader(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 6.0),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  border: Border.all(width: 3, color: Colors.transparent),
                  borderRadius: BorderRadius.circular(95)),
              child: Center(
                  //If user does not have Profile Pic, print first letter of first name
                  child: widget.poi.user.profileImg == null
                      ? Text(
                          widget.poi.user.firstname[0],
                          style: TextStyle(
                              fontSize: 20, color: colorScheme.onPrimary),
                        )
                      : const Text('I')),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.poi.user.firstname} ${widget.poi.user.lastName}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
