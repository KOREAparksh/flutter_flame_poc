import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class LoadAchievement extends StatelessWidget {
  const LoadAchievement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("업적...해적...산적..")),
      body: GameWidget(game: Map()),
    );
  }
}

class Map extends FlameGame {
  Map();
}
