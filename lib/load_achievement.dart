import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

class LoadAchievement extends StatelessWidget {
  const LoadAchievement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("업적...")),
      body: Column(
        children: [
          Expanded(
            child: GameWidget(game: Map()),
          ),
        ],
      ),
    );
  }
}

class Map extends FlameGame {
  Map();

  @override
  void update(double dt) {
    super.update(dt);
  }
}
