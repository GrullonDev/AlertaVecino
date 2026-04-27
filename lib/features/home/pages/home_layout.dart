import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/home/widgets/home_greeting.dart';
import 'package:neighbour_alert/features/home/widgets/home_panic_button.dart';
import 'package:neighbour_alert/features/home/widgets/home_quick_actions.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            HomeGreeting(),
            SizedBox(height: 32),
            Center(child: HomePanicButton()),
            SizedBox(height: 40),
            HomeQuickActions(),
          ],
        ),
      ),
    );
  }
}
