import 'package:flutter/material.dart';

class TreasureRoomPage extends StatelessWidget {
  const TreasureRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Treasure Room")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your Achievements"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) => Icon(Icons.emoji_events, color: Colors.grey, size: 50)),
            ),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("Back to Home")),
          ],
        ),
      ),
    );
  }
}
