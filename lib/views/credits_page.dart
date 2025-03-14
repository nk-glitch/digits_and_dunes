import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Credits")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sources & Tools Used"),
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
