import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:adas/provider/guide_provider.dart';
import 'home_view.dart';

class GuideView extends StatelessWidget {
  const GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome to ADAS",
          body:
              "This is your guide. Swipe through to learn how to use the app.",
          image: const Icon(
            Icons.drive_eta,
            size: 200,
          ),
          decoration: const PageDecoration(
            imagePadding: EdgeInsets.only(top: 50),
            imageFlex: 2,
            imageAlignment: Alignment.center,
            bodyAlignment: Alignment.bottomCenter,
            titleTextStyle: TextStyle(color: Colors.orange, fontSize: 18),
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
          ),
        ),
        PageViewModel(
          title: "Connect Your Car",
          body: "Connect the app to your car through Bluetooth.",
          image: Center(child: Image.asset('assets/image2.png')),
          decoration: const PageDecoration(
            imagePadding: EdgeInsets.only(top: 50),
            imageFlex: 2,
            imageAlignment: Alignment.center,
            bodyAlignment: Alignment.bottomCenter,
            titleTextStyle: TextStyle(color: Colors.orange, fontSize: 18),
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
          ),
        ),
        PageViewModel(
          title: "Control Options",
          body:
              "Choose how you want to move your car between auto and manual modes.",
          image: Center(child: Image.asset('assets/image4.png')),
          decoration: const PageDecoration(
            imagePadding: EdgeInsets.only(top: 50),
            imageFlex: 2,
            imageAlignment: Alignment.center,
            bodyAlignment: Alignment.bottomCenter,
            fullScreen: false,
            titleTextStyle: TextStyle(color: Colors.orange, fontSize: 18),
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
          ),
        ),
        PageViewModel(
          title: "Manual Control",
          body: "Set the speed of the car and drive it.",
          image: Center(child: Image.asset('assets/image5.png')),
          decoration: const PageDecoration(
            imagePadding: EdgeInsets.only(top: 50),
            imageFlex: 2,
            imageAlignment: Alignment.center,
            bodyAlignment: Alignment.bottomCenter,
            titleTextStyle: TextStyle(color: Colors.orange, fontSize: 18),
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
          ),
        ),
        PageViewModel(
          title: "Settings",
          body:
              "Customize the app theme to your preference.\nYou are welcome to visit our site and view our diverse collection of products.",
          image: Center(child: Image.asset('assets/image6.png')),
          decoration: const PageDecoration(
            imagePadding: EdgeInsets.only(top: 50),
            imageFlex: 2,
            imageAlignment: Alignment.center,
            bodyAlignment: Alignment.bottomCenter,
            titleTextStyle: TextStyle(color: Colors.orange, fontSize: 18),
            bodyTextStyle:
                TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
          ),
        ),
      ],
      onDone: () {
        Provider.of<GuideProvider>(context, listen: false).setSeenGuide(true);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
      },
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Get Started",
          style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
