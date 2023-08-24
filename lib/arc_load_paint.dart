import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class ArcLoadTest extends StatelessWidget {
  const ArcLoadTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("삼각함수 안한지 10년 다되가는데 제기랄")),
      body: GameWidget(
        game: World(),
      ),
    );
  }
}

class World extends FlameGame with HasGameRef {
  World();

  double dt = 0;
  late final ArcLoad load;

  @override
  Color backgroundColor() {
    return Colors.blue;
  }

  @override
  FutureOr<void> onLoad() {
    load = ArcLoad(maxWidth: size.x, dt: dt);
    add(load);
  }

  @override
  void update(double dt) {
    super.update(dt);
    this.dt += dt;
    load.updateDt(this.dt);
  }
}

class ArcLoadPainter extends CustomPainter {
  double dt;

  final double maxWidth;
  final double radius = 50;

  ArcLoadPainter({
    required this.maxWidth,
    required this.dt,
  });

  void updateDt(double dt) {
    this.dt = dt;
  }

  @override
  void paint(Canvas canvas, Size size) {
    print("dt: $dt");
    final Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 30
      ..style = PaintingStyle.stroke;
    canvas.drawPath(getPath(maxWidth), paint);
  }

  Path getPath(double x) {
    // Path path = Path()
    //   ..moveTo(50, 0)
    //   ..lineTo(50, 200 - radius)
    //   ..moveTo(50 + radius, 200)
    //   ..arcToPoint(Offset(50, 200 - radius), radius: Radius.circular(radius))
    //   ..moveTo(50 + radius, 200)
    //   ..lineTo(maxWidth - 50 - radius, 200)
    //   ..arcToPoint(Offset(maxWidth - 50, 200 + radius),
    //       radius: Radius.circular(radius))
    //   ..lineTo(maxWidth - 50, 400 - radius)
    //   ..arcToPoint(Offset(maxWidth - 50 - radius, 400),
    //       radius: Radius.circular(radius))
    //   ..lineTo(50 + radius, 400)
    //   ..moveTo(50, 400 + radius)
    //   ..arcToPoint(Offset(50 + radius, 400), radius: Radius.circular(radius))
    //   ..moveTo(50, 400 + radius)
    //   ..lineTo(50, 500);

    Path path = Path()
      ..moveTo(50, 0)
      ..lineTo(50, 200 - radius)
      ..cubicTo(50, 200 - radius, 50, 200, 50 + radius, 200)
      ..moveTo(50 + radius, 200)
      ..lineTo(maxWidth - 50 - radius, 200)
      ..cubicTo(maxWidth - 50 - radius, 200, maxWidth - 50, 200, maxWidth - 50,
          200 + radius)
      ..lineTo(maxWidth - 50, 400 - radius);

    return path;
  }

  double _getCubicPoint(double t, double p0, double p1, double p2, double p3) {
    return (pow(1 - t, 3).toDouble()) * p0 +
        3 * pow(1 - t, 2) * t * p1 +
        3 * (1 - t) * pow(t, 2) * p2 +
        pow(t, 3) * p3;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ArcLoad extends CustomPainterComponent {
  double dt;
  final double maxWidth;
  ArcLoad({
    required this.maxWidth,
    required this.dt,
  }) : super(
            painter: ArcLoadPainter(
          maxWidth: maxWidth,
          dt: dt,
        ));

  void updateDt(double dt) {
    painter = ArcLoadPainter(
      maxWidth: maxWidth,
      dt: dt,
    );
  }
}
