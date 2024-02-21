import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sunshine/dataProviders/app_data.dart';
import 'package:sunshine/global_variables.dart';
import 'package:sunshine/models/address.dart';
import 'package:sunshine/models/place.dart';
import 'package:sunshine/screens/onboarding_scrrens/missing_dialog.dart';
import 'package:sunshine/services/location_helper.dart';

import 'goals.dart';

class DateScreen extends StatefulWidget {
  static const String screenName = '/date';
  final VoidCallback onPressed;
  const DateScreen({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<DateScreen> createState() => _DateScreenState();
}

String text1 = '';
String text2 = '';

class _DateScreenState extends State<DateScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        'Date',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            fontSize: 26,
                            color: Color(0xFF24003F),
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'We are looking to set you up for a Valentine’s Day date IRL. Please tell us when and where you wish to go?',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF797A79)),
                      ),
                      SizedBox(
                        height: 27,
                      ),
                      Container(
                        height: 41,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.transparent),
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text1 == ''
                                ? Text(
                                    'Tap to change',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 14, color: Color(0xFF797A79)),
                                  )
                                : Text(
                                    text1,
                                    style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                            IconButton(
                                onPressed: () async {
                                  await showDateTimePicker(
                                      context: context,
                                      value: (DateTime val) {});
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: Color(0xFF24003F),
                                  size: 20,
                                ))
                          ],
                        ),
                      ),
                      text2 != ''
                          ? Text(
                              text2,
                              style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            )
                          : SizedBox.shrink(),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 11, vertical: 7),
                        decoration:
                            BoxDecoration(color: Color(0xFFE8FFE5), boxShadow: [
                          // BoxShadow(
                          //     color: Colors.black.withOpacity(0.25),
                          //     offset: Offset(0, 4),
                          //     blurRadius: 4)
                        ]),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Color(0xFF7A10C3),
                            ),
                            SizedBox(
                              width: 4.5,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Promise 2:',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF00210B)),
                                  ),
                                  Text(
                                    'Your date details are confidential until a match is made.',
                                    style: TextStyle(
                                      letterSpacing: -0.17,
                                      color: Color(0xFF0B7601),
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      NextButton(onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) => MissingDialog());
                        widget.onPressed();
                      })
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  showDateTimePicker({
    required Function(DateTime dateTime) value,
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    value(selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          ));

    await showDialog(
        context: context,
        builder: (context) => MapDialog(
              dateTime: selectedTime == null
                  ? selectedDate
                  : DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    ),
            ));
  }
}

class MapDialog extends StatefulWidget {
  const MapDialog({
    super.key,
    required this.dateTime,
  });
  final DateTime dateTime;

  @override
  State<MapDialog> createState() => _MapDialogState();
}

class _MapDialogState extends State<MapDialog> {
  final controller = TextEditingController();
  Marker? _marker;
  late MapController mapController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapController = MapController();
  }

  // Future<LatLng?> geocodeAddress(String address) async {
  //   try {
  //     final url = Uri.parse(
  //         'https://api.mapbox.com/geocoding/v5/mapbox.places/$address.json?access_token=${GlobalVariables.mapboxKey}');
  //     final response = await http.get(url);
  //
  //     if (response.statusCode == 200) {
  //       final features = jsonDecode(response.body)['features'];
  //       if (features.isNotEmpty) {
  //         final firstFeature = features[0];
  //         final coordinates = firstFeature['geometry']['coordinates'];
  //         final latitude = coordinates[1];
  //         final longitude = coordinates[0];
  //         return LatLng(latitude, longitude);
  //         // Use the latitude and longitude to center the map or create markers
  //         // mapController.animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
  //       } else {
  //         // Handle no results found
  //       }
  //     } else {
  //       // Handle API error
  //     }
  //   } catch (error) {
  //     // Handle network or other errors
  //   }
  // }

  Future<List<Prediction>> searchPlaces(String query) async {
    try {
      Uri uri = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=$query&key=${GlobalVariables.mapsApiKey}');
      var res = await http.get(uri);
      var data = jsonDecode(res.body);
      return (data['predictions'] as List)
          .map((e) => Prediction.fromJson(e))
          .toList();
    } catch (e) {}
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.hardEdge,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(28),
      // ),
      child: Container(
        width: 0.84 * MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(color: Color(0xFFECE6F0)),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              'Select Venue',
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF49454F),
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 18),
            TypeAheadField(
              controller: controller,
              suggestionsCallback: (search) async => searchPlaces(search),
              builder: (context, controller, focusNode) {
                return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                    ));
              },
              itemBuilder: (context, place) {
                return ListTile(
                  title: Text(place.mainText ?? ''),
                  subtitle: Text(place.secondaryText ?? ''),
                );
              },
              onSelected: (place) async {
                String url =
                    'https://maps.googleapis.com/maps/api/place/details/json?placeid=${place.placeId}&key=${GlobalVariables.mapsApiKey}';
                var res = await http.get(Uri.parse(url));
                var data = jsonDecode(res.body);
                Address address = Address.fromMap(data);
                mapController.move(
                    LatLng(address.latitude, address.longitude), 16);
                controller.text = address.placeFormattedAddress;
                // mapController.move(center, zoom)
              },
            ),
            SizedBox(
              height: 18,
            ),
            FutureBuilder(
                future: determinePosition(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var url =
                        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${snapshot.data!.latitude},${snapshot.data!.longitude}&key=${GlobalVariables.mapsApiKey}';
                    http.get(Uri.parse(url)).then((res) {
                      var data = jsonDecode(res.body);
                      controller.text = data['results'][0]['formatted_address'];
                    });
                    return Container(
                      height: 400,
                      child: FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter: LatLng(snapshot.data!.latitude,
                              snapshot.data!.longitude),
                          initialZoom: 16.0,
                          interactionOptions:
                              InteractionOptions(flags: InteractiveFlag.all),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          DragMarkers(
                            markers: [
                              DragMarker(
                                key: GlobalKey<DragMarkerWidgetState>(),
                                point: LatLng(snapshot.data!.latitude,
                                    snapshot.data!.longitude),
                                size: const Size.square(75),
                                offset: const Offset(0, -20),
                                dragOffset: const Offset(0, -35),
                                builder: (_, __, isDragging) {
                                  if (isDragging) {
                                    return const Icon(
                                      Icons.edit_location,
                                      size: 75,
                                      color: Colors.blueGrey,
                                    );
                                  }
                                  return const Icon(
                                    Icons.location_on,
                                    size: 50,
                                    color: Colors.blueGrey,
                                  );
                                },
                                onDragStart: (details, point) =>
                                    debugPrint("Start point $point"),
                                onDragEnd: (details, point) async {
                                  var url =
                                      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${point.latitude},${point.longitude}&key=${GlobalVariables.mapsApiKey}';
                                  var res = await http.get(Uri.parse(url));
                                  var data = jsonDecode(res.body);
                                  controller.text =
                                      data['results'][0]['formatted_address'];
                                },
                                onTap: (point) => debugPrint("on tap"),
                                onLongPress: (point) =>
                                    debugPrint("on long press"),
                                scrollMapNearEdge: true,
                                scrollNearEdgeRatio: 2.0,
                                scrollNearEdgeSpeed: 2.0,
                              ),
                              // marker with position information
                            ],
                            alignment: Alignment.topCenter,
                          )
                        ],
                      ),
                    );
                  }
                  return CircularProgressIndicator();
                }),
            SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.roboto(
                        color: Color(0xFFC80A09),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  width: 35,
                ),
                InkWell(
                  onTap: () {
                    text1 = DateFormat('d MMM. yyyy, @ h:mm a')
                        .format(widget.dateTime);
                    text2 = controller.text;
                    Provider.of<AppData>(context, listen: false)
                        .updateTimeVenue(time: widget.dateTime, venue: text2);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: GoogleFonts.roboto(
                        color: Color(0xFF0B7601),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
