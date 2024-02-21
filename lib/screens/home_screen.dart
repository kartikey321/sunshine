import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sunshine/dataProviders/app_data.dart';
import 'package:sunshine/models/usermodel.dart';
import 'package:sunshine/screens/widgets/home_appbar.dart';

import '../services/notification_controller.dart';

class HomeScreen extends StatefulWidget {
  static const String screenName = '/home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!kIsWeb) {
      NotificationController.initializeContext(context);
      NotificationController.startListeningNotificationEvents();
      NotificationController.requestFirebaseToken();
    }
  }

  Query matchCrush(BuildContext context) {
    var provider = Provider.of<AppData>(context);
    UserModel crush = provider.crush!;
    Query query = FirebaseFirestore.instance.collection('Users');
    query.where('name', isEqualTo: crush.name);
    query.where('gender', isEqualTo: crush.gender);
    if (crush.dob != null) {
      query.where('dob', isEqualTo: crush.dob!.toIso8601String());
    }
    if (crush.phoneNo != null) {
      query.where('phoneNo', isEqualTo: crush.phoneNo!);
    }
    if (crush.mailId != null) {
      query.where('mailId', isEqualTo: crush.mailId!);
    }
    if (crush.instaId != null) {
      query.where('instaId', isEqualTo: crush.instaId!);
    }
    if (crush.college != null) {
      query.where('instaId', isEqualTo: crush.instaId!);
    }
    if (crush.nick_name != null) {
      query.where('nick_name', isEqualTo: crush.nick_name!);
    }
    if (crush.year_of_gradutaion != null) {
      query.where('year_of_gradutaion', isEqualTo: crush.year_of_gradutaion!);
    }
    return query;
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppData>(context);
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          double totalHeight = constraints.maxHeight;
          double firstContainerHeight = totalHeight * 2 / 5;
          double secondContainerHeight = totalHeight * 3 / 5;
          double overlayContainerHeight = 128;
          double overlayContainerTop =
              firstContainerHeight - overlayContainerHeight / 2;

          return StreamBuilder(
              stream: matchCrush(context)
                  .snapshots()
                  .map((event) => UserModel.fromMap(event.docs)),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0, vertical: 20),
                                    child: HomeAppBar(
                                      userModel: provider.userModel!,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Text('')
                                ],
                              ),
                              width: double.infinity,
                              height: size.height * (2 / 5) - 73,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                Color(0xFFFE0100),
                                Color(0xFFA70E0D),
                              ])),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: size.width / 2 - 50,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.all(25),
                          height: overlayContainerHeight,
                          width: size.width * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(35)),
                              color: Color(0xFFEBEDF3)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'No Login Found!!',
                                textAlign: TextAlign.start,
                                style: TextStyle(color: Color(0xFF3568E6)),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Color(
                                            0xFFFEFEFF,
                                          ),
                                          width: 0.32),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFFEEF0F5),
                                          Color(0xFFE6E9EF),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(-7.73, -7.73),
                                          color: Colors.white.withOpacity(0.8),
                                          blurRadius: 12.89,
                                        ),
                                        BoxShadow(
                                          offset: Offset(6.44, 6.44),
                                          color: Color(0xFFA6B4C8)
                                              .withOpacity(0.7),
                                          blurRadius: 12.89,
                                        ),
                                      ],
                                    ),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 22,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 7,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  provider.crush!.name,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFF24003F)),
                                                ),
                                                Text(
                                                  provider.crush!.college ?? "",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Color(0xFF9C2CEF),
                                                      fontSize: 12),
                                                ),
                                                SizedBox(
                                                  height: 14,
                                                ),
                                                provider.crush!
                                                            .year_of_gradutaion !=
                                                        null
                                                    ? Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        23),
                                                            color: Color(
                                                                0xFFF6EAFF)),
                                                        child: Center(
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons.settings,
                                                                color:
                                                                    Colors.grey,
                                                                size: 12,
                                                              ),
                                                              SizedBox(
                                                                width: 9,
                                                              ),
                                                              Text(
                                                                provider.crush!
                                                                    .year_of_gradutaion!
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Color(
                                                                        0xFF9C2CEF)),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                                provider.crush!.instaId != null
                                                    ? Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        23),
                                                            color: Color(
                                                                0xFFF6EAFF)),
                                                        child: Center(
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                AntDesign
                                                                    .instagram,
                                                                color:
                                                                    Colors.grey,
                                                                size: 12,
                                                              ),
                                                              SizedBox(
                                                                width: 9,
                                                              ),
                                                              Text(
                                                                provider.crush!
                                                                    .instaId!
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Color(
                                                                        0xFF9C2CEF)),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink()
                                              ],
                                            ),
                                          ),
                                          VerticalDivider(
                                            thickness: 0.5,
                                            color: Color(0xFFDBD9E1),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Image.asset(
                                                  'assets/no_login.png',
                                                  height: 85,
                                                  width: 85,
                                                  fit: BoxFit.cover,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'He is playing hard to get!',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color(0xFF4EA646),
                                                      fontSize: 12),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                              Text(
                                'Refresh',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Color(0xFF3568E6), fontSize: 12),
                              ),
                              SizedBox(
                                height: 52,
                              ),
                              Text(
                                'Is this the profile you were looking for?',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.newsreader(
                                    fontSize: 15, color: Color(0xFF24003F)),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Gradient border
                                    Container(
                                      height: 50,
                                      width: 215,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFFFEFEFF),
                                            Color(0xFFC6CEDA),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Inner container
                                    Container(
                                        padding: EdgeInsets.all(4),
                                        height: 50 -
                                            0.32 *
                                                2, // Subtract the border width
                                        width: 215 -
                                            0.32 *
                                                2, // Subtract the border width
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color(0xFFEEF0F5),
                                              Color(0xFFE6E9EF),
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(-7.73, -7.73),
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              blurRadius: 12.89,
                                            ),
                                            BoxShadow(
                                              offset: Offset(6.44, 6.44),
                                              color: Color(0xFFA6B4C8)
                                                  .withOpacity(0.7),
                                              blurRadius: 12.89,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 10,
                                                child: InkWell(
                                                  child: Container(
                                                    color: Colors.transparent,
                                                    child: Center(
                                                      child: Text(
                                                        'Yes its him',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF9C2CEF),
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                            Expanded(
                                                flex: 3,
                                                child: InkWell(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFB60D0C),
                                                        borderRadius: BorderRadius
                                                            .horizontal(
                                                                right: Radius
                                                                    .circular(
                                                                        24))),
                                                    child: Center(
                                                      child: Text(
                                                        'No',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF9C2CEF),
                                                            fontSize: 15),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 20),
                                  child: HomeAppBar(
                                    userModel: provider.userModel!,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: Text(
                                    'We’ll Find Him',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            width: double.infinity,
                            height: size.height * (2 / 5) - 73,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                              Color(0xFFFE0100),
                              Color(0xFFA70E0D),
                            ])),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: size.width / 2 + 50,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(25),
                        height: overlayContainerHeight,
                        width: size.width * 0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35),
                                topRight: Radius.circular(35)),
                            color: Color(0xFFEBEDF3)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'No Login Found!!',
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Color(0xFF3568E6)),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Color(
                                          0xFFFEFEFF,
                                        ),
                                        width: 0.32),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFEEF0F5),
                                        Color(0xFFE6E9EF),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(-7.73, -7.73),
                                        color: Colors.white.withOpacity(0.8),
                                        blurRadius: 12.89,
                                      ),
                                      BoxShadow(
                                        offset: Offset(6.44, 6.44),
                                        color:
                                            Color(0xFFA6B4C8).withOpacity(0.7),
                                        blurRadius: 12.89,
                                      ),
                                    ],
                                  ),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 22,
                                                backgroundImage: AssetImage(
                                                    'assets/pic_placeholder.png'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                provider.crush!.name,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF24003F)),
                                              ),
                                              Text(
                                                provider.crush!.college ?? "",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xFF9C2CEF),
                                                    fontSize: 12),
                                              ),
                                              SizedBox(
                                                height: 14,
                                              ),
                                              provider.crush!
                                                          .year_of_gradutaion !=
                                                      null
                                                  ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: 85,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          23),
                                                              color: Color(
                                                                  0xFFF6EAFF)),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .stretch,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .settings,
                                                                      color: Colors
                                                                          .grey,
                                                                      size: 12,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 9,
                                                                    ),
                                                                    Text(
                                                                      provider
                                                                          .crush!
                                                                          .year_of_gradutaion!
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Color(0xFF9C2CEF)),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox.shrink(),
                                              SizedBox(
                                                height: 9,
                                              ),
                                              provider.crush!.instaId != null
                                                  ? Column(
                                                      children: [
                                                        Container(
                                                          width: 100,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          23),
                                                              color: Color(
                                                                  0xFFF6EAFF)),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .stretch,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        5.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Icon(
                                                                      AntDesign
                                                                          .instagram,
                                                                      color: Colors
                                                                          .grey,
                                                                      size: 12,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 9,
                                                                    ),
                                                                    Text(
                                                                      provider
                                                                          .crush!
                                                                          .instaId!
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              Color(0xFF9C2CEF)),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : const SizedBox.shrink()
                                            ],
                                          ),
                                        ),
                                        VerticalDivider(
                                          thickness: 0.5,
                                          color: Color(0xFFDBD9E1),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Image.asset(
                                                'assets/no_login.png',
                                                height: 85,
                                                width: 85,
                                                fit: BoxFit.cover,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'He is playing hard to get!',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Color(0xFF4EA646),
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                            Text(
                              'Refresh',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Color(0xFF3568E6), fontSize: 12),
                            ),
                            SizedBox(
                              height: 52,
                            ),
                            Text(
                              'Is this the profile you were looking for?',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.newsreader(
                                  fontSize: 15, color: Color(0xFF24003F)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Gradient border
                                  Container(
                                    height: 50,
                                    width: 215,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFFFEFEFF),
                                          Color(0xFFC6CEDA),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Inner container
                                  Container(
                                      padding: EdgeInsets.all(4),
                                      height: 50 -
                                          0.32 * 2, // Subtract the border width
                                      width: 215 -
                                          0.32 * 2, // Subtract the border width
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFFEEF0F5),
                                            Color(0xFFE6E9EF),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(-7.73, -7.73),
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            blurRadius: 12.89,
                                          ),
                                          BoxShadow(
                                            offset: Offset(6.44, 6.44),
                                            color: Color(0xFFA6B4C8)
                                                .withOpacity(0.7),
                                            blurRadius: 12.89,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 10,
                                              child: InkWell(
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Center(
                                                    child: Text(
                                                      'Yes its him',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF9C2CEF),
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                          Expanded(
                                              flex: 3,
                                              child: InkWell(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(0xFFB60D0C),
                                                      borderRadius: BorderRadius
                                                          .horizontal(
                                                              right: Radius
                                                                  .circular(
                                                                      24))),
                                                  child: Center(
                                                    child: Text(
                                                      'No',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              });
        }),
      ),
    );
  }
}
