import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_conferencing/responsive/responsive.dart';
import 'package:video_conferencing/screens/login_screen.dart';
import 'package:video_conferencing/screens/signup_screen.dart';
import 'package:video_conferencing/widgets/custom_button.dart';
import 'package:video_player/video_player.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';

  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/1.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.play(); // Automatically play the video
        });
      });
    _controller.setLooping(true); // Set the video to loop continuously
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose(); // Dispose of the VideoPlayerController
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      child: Scaffold(
        body: Stack(
          children: [
            if (!kIsWeb) VideoPlayer(_controller),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  // Wrap the image with a Container to add border and padding
                  Container(
                    margin: EdgeInsets.all(40),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white, // Adjust border color as needed
                        width: 5.0, // Adjust border width as needed
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      // Adjust corner radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                              0.2), // Adjust shadow color as needed
                          spreadRadius: 5.0,
                          blurRadius: 10.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0), // Adjust padding as needed
                      child: Image.asset(
                        'assets/images/1.png',
                        height: 200,
                        width: 300,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white, // Adjust border color as needed
                        width: 5.0, // Adjust border width as needed
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      // Adjust corner radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                              0.2), // Adjust shadow color as needed
                          spreadRadius: 5.0,
                          blurRadius: 10.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "|| प्रसारण ऐप ||",
                          style: GoogleFonts.poppins(
                            fontSize: 43,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[600],
                          ),
                        ),
                        Text(
                          "में आपका स्वागत है!",
                          style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30.0),
                    child: CustomButton(
                        onTap: () {
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        },
                        text: "LOG IN"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: CustomButton(
                        onTap: () {
                          Navigator.pushNamed(context, SignupScreen.routeName);
                        },
                        text: "SIGN UP"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
