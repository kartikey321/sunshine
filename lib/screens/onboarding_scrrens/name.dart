import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sunshine/screens/onboarding_scrrens/goals.dart';
import 'package:sunshine/screens/onboarding_scrrens/missing_dialog.dart';

import '../../dataProviders/app_data.dart';

class NameScreen extends StatefulWidget {
  static const String screenName = '/name';
  final VoidCallback onPressed;
  const NameScreen({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
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
                        'You are brave!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            fontSize: 26,
                            color: Color(0xFF24003F),
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'Thousands, if not millions just never met their valentine because they never took that first step! If your crush feels the same way about you, there is a match.',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF797A79)),
                      ),
                      SizedBox(
                        height: 27,
                      ),
                      Container(
                        height: 41,
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            hintText: 'Enter your crush name',
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF7A10C3)),
                                borderRadius: BorderRadius.circular(15)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF7A10C3)),
                                borderRadius: BorderRadius.circular(15)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF7A10C3)),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      PromiseBox(
                          promiseNo: '1',
                          text:
                              'We won’t reveal your name unless their is a match.'),
                      SizedBox(
                        height: 60,
                      ),
                      Container(
                        child: NextButton(onPressed: () {
                          if (controller.text.isNotEmpty &&
                              controller.text.length > 3) {
                            Provider.of<AppData>(context, listen: false)
                                .updateName(controller.text);
                            widget.onPressed();
                          }
                        }),
                      )
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
}
