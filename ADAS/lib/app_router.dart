import 'package:adas/views/guide_view.dart';
import 'package:adas/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adas/provider/guide_provider.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GuideProvider>(
      builder: (context, guideProvider, child) {
        if (guideProvider.seenGuide) {
          return const HomeView();
        } else {
          return const GuideView();
        }
      },
    );
  }
}
