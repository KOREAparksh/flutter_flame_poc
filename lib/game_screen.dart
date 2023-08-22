import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: RacingGame());
  }
}

class RacingGame extends FlameGame with TapCallbacks {
  late Player player;

  @override
  FutureOr<void> onLoad() async {
    player = Player(position: Vector2(size.x * 0.25, size.y - 20));
    add(player);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!event.handled) {
      final touchPoint = event.canvasPosition;
      if (touchPoint.x > size.x / 2) {
        player.position = Vector2(size.x * 0.75, size.y - 20);
      } else {
        player.position = Vector2(size.x * 0.25, size.y - 20);
      }
    }
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

class Star extends RectangleComponent with HasGameRef {
  static const starSize = 64.0;

  Star(position)
      : super(
          position: position,
          size: Vector2.all(starSize),
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    paint.color = Colors.yellow;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y = position.y + 5;
    if (position.y - size.y > gameRef.size.y) {
      removeFromParent();
    }
  }
}
