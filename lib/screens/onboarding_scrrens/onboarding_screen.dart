import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sunshine/screens/onboarding_scrrens/date.dart';
import 'package:sunshine/screens/onboarding_scrrens/goals.dart';
import 'package:sunshine/screens/onboarding_scrrens/login.dart';
import 'package:sunshine/screens/onboarding_scrrens/name.dart';
import 'package:sunshine/screens/splash_screen.dart';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({Key? key}) : super(key: key);

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final ValueNotifier<int> _pageNotifier = ValueNotifier<int>(0);
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                onPageChanged: (int index) {
                  _pageNotifier.value = index;
                },
                controller: controller,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFFFB3B3),
                          Color(0xFFC80A09).withOpacity(0)
                        ],
                      ),
                    ),
                    child: Image.asset('assets/goals.png'),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFFFB2B2),
                          Color(0xFFFFE9E9).withOpacity(0)
                        ],
                      ),
                    ),
                    child: Image.asset('assets/name.png'),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF263238),
                          Color(0xFF263238).withOpacity(0)
                        ],
                      ),
                    ),
                    child: Image.asset('assets/date.png'),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF263238),
                          Color(0xFFC80A09).withOpacity(0)
                        ],
                      ),
                    ),
                    child: Image.asset('assets/login.png'),
                  ),
                ],
              ),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 4,
                effect: ExpandingDotsEffect(
                  activeDotColor: Color(0xFFC80A09),
                  dotColor: Color(0xFFDECCCC),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.75,
              width: MediaQuery.of(context).size.width,
              child: ValueListenableBuilder(
                valueListenable: _pageNotifier,
                builder: (context, value, child) {
                  switch (value) {
                    case 0:
                      {
                        return Goals(
                          onPressed: () {
                            controller.nextPage(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut);
                          },
                        );
                      }
                    case 1:
                      {
                        return NameScreen(
                          onPressed: () {
                            controller.nextPage(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut);
                          },
                        );
                      }
                    case 2:
                      {
                        return DateScreen(
                          onPressed: () {
                            controller.nextPage(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut);
                          },
                        );
                      }
                    case 3:
                      {
                        return LoginScreen(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, SplashScreen.screenName);
                          },
                        );
                      }
                  }
                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
