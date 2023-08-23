import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_poc/test.dart';

class LoadAchievement extends StatelessWidget {
  const LoadAchievement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("업적...해적....산적...산적 맛있지...")),
      body: GameWidget(
        game: World(),
      ),
    );
  }
}

class World extends FlameGame with HasGameRef, DragCallbacks {
  static final dividerSize = Vector2(0, 20);
  static final itemrSize = Vector2(0, 100);
  final List<TestComponent> list = <TestComponent>[];
  late final cc;
  late final CircleComponent centerComp;

  double cameraIndex = 0;
  bool isFirst = true;

  World();

  @override
  Color backgroundColor() {
    return Colors.blue;
  }

  @override
  FutureOr<void> onLoad() {
    for (int i = 0; i < 8; i++) {
      list.add(
        TestComponent(
          size: Vector2(200, itemrSize.y),
          position:
              Vector2(size.x / 2, (itemrSize.y * i) + (dividerSize.y * i)),
          text: "$i 입니다.",
        ),
      );
      add(list[i]);
    }

    centerComp = CircleComponent(
      position: Vector2(size.x / 2, size.y / 2),
      radius: 10,
      anchor: Anchor.center,
      priority: 10,
    );
    centerComp.paint.color = Colors.red;
    add(centerComp);

    centerComp.position.y = list.first.position.y - (itemrSize.y / 2);
    gameRef.camera.followComponent(centerComp);

    cc = CameraComponent.withFixedResolution(width: 400, height: 800);

    add(cc);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isFirst && centerComp.position.y >= list.last.y) {
      if (isFirst == true) {
        isFirst = false;
      }
      return;
    }
    if (isFirst) {
      centerComp.position.y = centerComp.position.y + 5;
    }
  }

  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    centerComp.position.y = centerComp.position.y - event.delta.y;
  }
}

class TestComponent extends RectangleComponent {
  final String text;
  TestComponent({
    required size,
    required position,
    required this.text,
  }) : super(
          size: size,
          position: position,
          anchor: Anchor.center,
        );

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    final textComponent = TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.red),
      ),
      size: Vector2.all(20),
      position: Vector2(
        size.x / 2,
        size.y / 2,
      ),
      anchor: Anchor.center,
    );
    add(textComponent);
  }
}
