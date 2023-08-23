import 'package:flutter/material.dart';

class FlutterAchievement extends StatelessWidget {
  const FlutterAchievement({super.key});
  final images = const [
    "assets/images/map-level1.png",
    "assets/images/nfc_android.png",
    "assets/images/nine-box.png",
    "assets/images/search_empty.png",
    "assets/images/speech-bubble.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("이건 플러터 코드")),
      body: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(child: Text("$index")),
                ),
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Image.asset(images[index % 5]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
