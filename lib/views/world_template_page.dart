import 'package:flutter/material.dart';

class WorldTemplatePage extends StatelessWidget {
  final String worldName;
  final int totalLevels;
  // final String backgroundImage;

  const WorldTemplatePage({
    super.key,
    required this.worldName,
    required this.totalLevels,
    // required this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(worldName)),
      body: Stack(
        children: [
          // Background Image
          // Positioned.fill(
          //   child: Image.asset(
          //     backgroundImage,
          //     fit: BoxFit.cover,
          //   ),
          // ),

          // Level Map (Scrollable)
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  '$worldName - Level Map',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: totalLevels,
                    itemBuilder: (context, index) {
                      int level = index + 1;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 30),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/level$level');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          child: Text('Level $level'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/world_select');
                  },
                  child: const Text('Back to World Select'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
