import 'package:afranco/components/welcome/welcome_header.dart';
import 'package:afranco/components/welcome/welcome_actions.dart';
import 'package:afranco/components/welcome/quick_access_grid.dart';
import 'package:flutter/material.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            WelcomeHeader(),
            SizedBox(height: 32),
            QuickAccessGrid(),
            SizedBox(height: 32),
            WelcomeActions(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}