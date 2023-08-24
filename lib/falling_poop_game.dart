import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class FallingPoopGameScreen extends StatelessWidget {
  const FallingPoopGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: RacingGame(),
    );
  }
}

class RacingGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  late Player player;
  double nextSpawnSeconds = 0;

  @override
  FutureOr<void> onLoad() async {
    player = Player(
      position: Vector2(size.x * 0.25, size.y - 20),
      color: Colors.blue,
    );
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
      player.color = Colors.red;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    nextSpawnSeconds -= dt;
    if (nextSpawnSeconds < 0) {
      add(Star(Vector2(size.x * (Random().nextInt(10) > 5 ? 0.75 : 0.25), 0)));
      nextSpawnSeconds = 0.001 + Random().nextDouble();
    }
  }
}

class Player extends RectangleComponent with CollisionCallbacks {
  static const playerSize = 96.0;
  int totalCount = 0;
  Color color;
  late TextComponent textComponent;

  Player({required position, required this.color})
      : super(
          position: position,
          size: Vector2.all(playerSize),
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    paint.color = color;
    add(RectangleHitbox());

    textComponent = TextComponent(
      text: '',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 40,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(playerSize / 2, playerSize / 2),
    );
    add(textComponent);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is Star) {
      textComponent.text = '${++totalCount}';
    } else {
      super.onCollisionStart(intersectionPoints, other);
    }
  }
}

class Star extends RectangleComponent with HasGameRef, CollisionCallbacks {
  static const starSize = 64.0;
  final speed;

  Star(position)
      : speed = Random().nextInt(10) + 3,
        super(
          position: position,
          size: Vector2.all(starSize),
          anchor: Anchor.bottomCenter,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    paint.color = Colors.yellow;
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y = position.y + speed;
    if (position.y - starSize > gameRef.size.y) {
      removeFromParent();
    }
  }

  @override
  bool onComponentTypeCheck(PositionComponent other) {
    if (other is Star) {
      return false;
    } else {
      return super.onComponentTypeCheck(other);
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is Player) {
      removeFromParent();
    } else {
      super.onCollisionStart(intersectionPoints, other);
    }
  }
}
