import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class LoadAchievementOnce extends StatelessWidget {
  const LoadAchievementOnce({
    super.key,
    required this.maxLevel,
  });

  final int maxLevel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("업적...해적....산적...산적 맛있지...")),
      body: GameWidget(
        game: World(maxLevel: maxLevel),
      ),
    );
  }
}

class World extends FlameGame with HasGameRef, DragCallbacks {
  World({required this.maxLevel});

  final int maxLevel;

  static const double speed = 0.03;
  static const double padding = 80;
  static final dividerSize = Vector2(0, 20);
  static final itemrSize = Vector2(0, 100);
  final List<TargetComponent> targets = <TargetComponent>[];
  final List<PathComponent> paths = [];

  // late final LoadComponent loadComponent;

  bool isHeadingRight = true;
  double sum = 0;

  double cameraIndex = 0;
  bool isFirst = true;

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
  }

  void initPathOffset() {
    paths.add(PathComponent(
      index: 0,
      sum: -1,
      compColor: Colors.grey,
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
        sum: -1,
        compColor: Colors.grey,
        compSize: size,
        compPosition: position,
        compAnchor: anchor,
        compAngle: angle,
      ));
    }
  }

  @override
  FutureOr<void> onLoad() {
    offsets.clear();
    init();

    for (var path in paths) {
      add(path);
    }

    for (int i = 0; i < offsets.length; i++) {
      targets.add(
        TargetComponent(
          position: offsets[i],
          text: "${i + 1} 입니다.",
        ),
      );
      add(targets[i]);
    }

    // add(loadComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (maxLevel <= -1) {
      return;
    }
    if (maxLevel < sum + speed) {
      sum = maxLevel.toDouble();
    } else {
      sum += speed;
    }

    int index = sum.toInt();

    paths[index].sum = sum;

    print(sum);

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

  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
  }
}

class TargetComponent extends CircleComponent {
  final String text;

  TargetComponent({
    required position,
    required this.text,
  }) : super(
          radius: 40,
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
}

class PathComponent extends RectangleComponent {
  int index;
  double sum;
  Color compColor;
  Vector2 compSize;
  Vector2 compPosition;
  Anchor compAnchor;
  double compAngle;

  double redY = 0;
  late RectangleComponent grey;
  late RectangleComponent red;

  PathComponent({
    required this.index,
    required this.sum,
    required this.compColor,
    required this.compSize,
    required this.compPosition,
    required this.compAnchor,
    required this.compAngle,
  });

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    grey = RectangleComponent(
      size: compSize,
      position: compPosition,
      anchor: compAnchor,
      angle: compAngle,
    );
    red = RectangleComponent(
      size: Vector2(compSize.x, 1),
      position: compPosition,
      anchor: compAnchor,
      angle: compAngle,
    );
    grey.paint.color = compColor;
    red.paint.color = Colors.red;
    add(grey);
    add(red);
  }

  @override
  void update(double dt) {
    super.update(dt);
    int sumIndex = sum.toInt();
    if (index <= sumIndex) {
      double ySize = compSize.y * (sum - sumIndex);
      red.size = Vector2(compSize.x, ySize);
    }
  }
}



// class LoadComponent extends CustomPainterComponent {
//   final Path path;

//   LoadComponent({required this.path})
//       : super(
//           painter: ArcLoadPainter(
//             path,
//             Colors.red,
//           ),
//         );
// }

// class ArcLoadPainter extends CustomPainter {
//   Path path;
//   final Color color;

//   ArcLoadPainter(this.path, this.color);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = color
//       ..strokeWidth = 18
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round;
//     canvas.scale(0.5, 0.5);
//     canvas.drawPath(path, paint);

//     // for (int i = 0; i < path.length; i++) {
//     //   if (path[i].translate != null) {
//     //     canvas.translate(path[i].translate![0], path[i].translate![1]);
//     //   }
//     //   if (path[i].rotation != null) {
//     //     canvas.rotate(path[i].rotation!);
//     //   }
//     //   if (blur > 0) {
//     //     final MaskFilter blur = MaskFilter.blur(BlurStyle.normal, this.blur);
//     //     paint.maskFilter = blur;
//     //     canvas.drawPath(path[i].path, paint);
//     //   }

//     //   // paint.maskFilter = null;
//     //   canvas.drawPath(path[i].path, paint);
//     // }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }

//   @override
//   bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
