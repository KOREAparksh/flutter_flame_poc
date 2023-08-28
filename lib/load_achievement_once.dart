import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class LoadAchievementOnce extends StatelessWidget {
  const LoadAchievementOnce({
    super.key,
    required this.startLevel,
    required this.maxLevel,
  });

  final int startLevel;
  final int maxLevel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("업적...해적....산적...산적 맛있지...")),
      body: GameWidget(
        game: LoadMap(
          startLevel: startLevel,
          maxLevel: maxLevel,
          onArrived: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("마 좀 치나"),
                    content: Text("니가 벌써 여 $maxLevel 까지 다 모았나!"),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("확인"),
                      ),
                    ],
                  );
                });
          },
          onTap: (i) async {
            print("123123");
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("마 좀 치나"),
                    content: Text("니가 벌써 여 ${i + 1} 까지 다 모았나!"),
                    actions: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("확인"),
                      ),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}

class LoadMap extends FlameGame with HasGameRef, DragCallbacks {
  LoadMap({
    required this.startLevel,
    required this.maxLevel,
    required this.onArrived,
    required this.onTap,
  });

  final VoidCallback onArrived;
  final Future<void> Function(int index) onTap;

  final int startLevel;
  final int maxLevel;
  static Vector2 trackSize = Vector2.all(500);

  static const double speed = 0.03;
  static const double padding = 80;
  static final dividerSize = Vector2(0, 20);
  static final itemrSize = Vector2(0, 100);
  final List<TargetComponent> targets = <TargetComponent>[];
  final List<PathComponent> paths = [];

  late final SpriteComponent dagu;
  final World world = World();
  late final CameraComponent cameraComponent;

  bool isHeadingRight = true;
  late double sum = startLevel.toDouble();

  bool isFirstAnimationEnd = false;
  bool isFirstCallFunction = true;

  static final List<Vector2> offsets = [];

  @override
  Color backgroundColor() {
    return Colors.blue;
  }

  /// You must call this Method in OnLoad
  void init() {
    initTargetOffset();
    initPathOffset();
    // loadComponent = LoadComponent(path: path);
  }

  void initTargetOffset() {
    offsets.clear();
    offsets.add(Vector2(padding, 120));
    offsets.add(Vector2(size.x / 2, 120));
    offsets.add(Vector2(size.x - padding, 120));
    offsets.add(Vector2(size.x - padding, 270));
    offsets.add(Vector2(size.x / 2, 270));
    offsets.add(Vector2(padding, 270));
    offsets.add(Vector2(padding, 420));
    offsets.add(Vector2(size.x / 2, 420));
    offsets.add(Vector2(size.x - padding, 420));
    offsets.add(Vector2(size.x - padding, 570));
    offsets.add(Vector2(size.x / 2, 570));
    offsets.add(Vector2(padding, 570));
    offsets.add(Vector2(padding, 720));
    offsets.add(Vector2(size.x / 2, 720));
    offsets.add(Vector2(size.x - padding, 720));
    offsets.add(Vector2(size.x - padding, 870));
    offsets.add(Vector2(size.x / 2, 870));
    offsets.add(Vector2(padding, 870));
    offsets.add(Vector2(padding, 990));
    offsets.add(Vector2(size.x / 2, 990));
    offsets.add(Vector2(size.x - padding, 990));
    offsets.add(Vector2(size.x - padding, 1110));
    offsets.add(Vector2(size.x / 2, 1110));
    offsets.add(Vector2(padding, 1110));
  }

  void initPathOffset() {
    paths.add(PathComponent(
      index: 0,
      sum: sum,
      compSize: Vector2(20, offsets[0].y - 0),
      compPosition: Vector2(padding, 0),
      compAnchor: Anchor.topCenter,
      compAngle: 0,
    ));
    for (int i = 1; i < offsets.length; i++) {
      late final Vector2 position;
      late final Vector2 size;
      late final Anchor anchor;
      late final double angle;

      if (i % 3 == 0) {
        position = Vector2(offsets[i - 1].x, offsets[i - 1].y);
        size = Vector2(20, offsets[i].y - offsets[i - 1].y);
        anchor = Anchor.topCenter;
        angle = 0;
        isHeadingRight = !isHeadingRight;
      } else {
        position = Vector2(offsets[i - 1].x, offsets[i - 1].y);
        size = Vector2(20, offsets[i].x - offsets[i - 1].x);
        anchor = Anchor.topCenter;
        angle = (isHeadingRight) ? pi / -2 : pi / 2;
      }

      paths.add(PathComponent(
        index: i,
        sum: sum,
        compSize: size,
        compPosition: position,
        compAnchor: anchor,
        compAngle: angle,
      ));
    }
  }

  @override
  FutureOr<void> onLoad() async {
    init();

    cameraComponent = CameraComponent(world: world)
      ..viewfinder.position = Vector2(size.x / 2, size.y / 2)
      ..viewfinder.anchor = Anchor.center;
    addAll([world, cameraComponent]);

    for (var path in paths) {
      world.add(path);
    }

    for (int i = 0; i < offsets.length; i++) {
      targets.add(
        TargetComponent(
          index: i,
          position: offsets[i],
          radius: 25,
          text: "${i + 1} 입니다.",
          onTap: onTap,
        ),
      );
      world.add(targets[i]);
    }

    final daguImage = await Sprite.load("dagu.png");
    dagu = SpriteComponent(
      sprite: daguImage,
      size: Vector2.all(70),
      position: Vector2(padding, 70 / 2),
      anchor: Anchor.bottomCenter,
      priority: 10,
    );
    dagu.position.clamp(Vector2(0, 0), Vector2(size.x, size.y));
    world.add(dagu);

    cameraComponent.follow(dagu, verticalOnly: true);
    cameraComponent.setBounds(Rectangle.fromLTWH(size.x / 2, size.y / 2,
        size.x / 2, targets.last.position.y - size.y + 100));
  }

  @override
  void update(double dt) async {
    super.update(dt);
    if (maxLevel <= -1) {
      return;
    }
    if (maxLevel < sum + speed) {
      isFirstAnimationEnd = true;
      cameraComponent.removed;
      sum = maxLevel.toDouble();
      if (isFirstCallFunction == true) {
        isFirstCallFunction = false;
        onArrived.call();
      }
      return;
    } else {
      sum += speed;
    }

    int index = sum.toInt();

    if (index < paths.length) {
      paths[index].sum = sum;
    }
    // print(paths[index].position);

    final rotate = index % 6;

    if (rotate == 0 || rotate == 3) {
      final double newY;
      newY = paths[index].y +
          (paths[index + 1].y - paths[index].y) * (sum - index);
      dagu.position.y = newY;
    } else if (rotate == 1 || rotate == 2) {
      final double newX;
      newX = paths[index].x +
          (paths[index + 1].x - paths[index].x) * (sum - index);
      dagu.position.x = newX;
    } else if (rotate == 4 || rotate == 5) {
      final double newX;
      newX = paths[index].x +
          (paths[index + 1].x - paths[index].x) * (sum - index);
      dagu.position.x = newX;
    }

    // dagu.position = paths[index].position;
    // dagu.position.y += 20 * speed;
    // cameraComponent.moveTo(dagu.)

    ///////////////////////////////////////////////

    // print(sum);

    // if (isFirst && centerComp.position.y >= list.last.y) {
    //   if (isFirst == true) {
    //     isFirst = false;
    //   }
    //   return;
    // }
    // if (isFirst) {
    //   centerComp.position.y = centerComp.position.y + 5;
    // }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (isFirstAnimationEnd == false) {
      return;
    }
    // if (cameraComponent.viewport.position.y + event.delta.y > 0 ||
    //     (cameraComponent.viewport.position.y + event.delta.y).abs() >
    //         targets.last.position.y) {
    //   return;
    // }
    // cameraComponent.viewport.position.y += event.delta.y;
  }
}

class TargetComponent extends CircleComponent with TapCallbacks {
  final String text;
  final int index;
  final Future<void> Function(int index) onTap;

  TargetComponent({
    required position,
    required double radius,
    required this.text,
    required this.index,
    required this.onTap,
  }) : super(
          radius: 20,
          position: position,
          anchor: Anchor.center,
          children: [
            TextComponent(
              text: text,
              textRenderer: TextPaint(
                style: const TextStyle(color: Colors.red),
              ),
              size: Vector2.all(0),
              position: Vector2(20, 20),
              // anchor: Anchor.center,
            )
          ],
        );

  @override
  void onTapDown(TapDownEvent event) async {
    super.onTapDown(event);
    if (!event.handled) {
      print("2222");
      onTap(index);
    }
  }
}

class PathComponent extends RectangleComponent {
  int index;
  double sum;
  final Color defaultColor = Colors.grey;
  final Color passedRoadColor = Colors.red;
  Vector2 compSize;
  Vector2 compPosition;
  Anchor compAnchor;
  double compAngle;

  double redY = 0;
  late RectangleComponent red;

  PathComponent({
    required this.index,
    required this.sum,
    required this.compSize,
    required this.compPosition,
    required this.compAnchor,
    required this.compAngle,
  }) : super(
          size: compSize,
          position: compPosition,
          anchor: compAnchor,
          angle: compAngle,
        );

  @override
  FutureOr<void> onLoad() {
    super.onLoad();

    paint.color = defaultColor;

    priority = 0;

    red = RectangleComponent(
      size: Vector2(size.x, 0),
      position: Vector2(0, 0),
      anchor: Anchor.topLeft,
      angle: 0,
      priority: 100,
    );
    // grey.paint.color = compColor;
    red.paint.color = passedRoadColor;
    // add(grey);
    add(red);
  }

  @override
  void update(double dt) {
    super.update(dt);
    int sumIndex = sum.toInt();
    if (index <= sumIndex) {
      double newY = size.y * (sum - sumIndex);
      if (index < sumIndex) {
        newY = size.y;
      }
      red.size = Vector2(size.x, newY);
    }
  }
}
