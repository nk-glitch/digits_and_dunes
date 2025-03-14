import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Settings"),
            Text("• Flutter"),
            Text("• Firebase"),
            Text("• Figma"),
            Text("• GitHub"),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("Back to Home")),
          ],
        ),
      ),
    );
  }
}
