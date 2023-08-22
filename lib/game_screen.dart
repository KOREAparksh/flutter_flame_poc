import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: RacingGame());
  }
}

class RacingGame extends FlameGame {
  @override
  FutureOr<void> onLoad() {
    final player = Player(position: Vector2(size.x * 0.25, size.y - 20));
    add(player);
  }
}

class Player extends RectangleComponent {
  static const playerSize = 96.0;
  Player({required position})
      : super(
          position: position,
          size: Vector2.all(playerSize),
          anchor: Anchor.bottomCenter,
        );
}
