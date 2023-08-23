import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
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

  @override
  Color backgroundColor() {
    return Colors.blue;
  }

  @override
  FutureOr<void> onLoad() {
    add(ArcLoad(maxWidth: size.x));
  }
}

class ArcLoadPainter extends CustomPainter {
  final double maxWidth;
  final double radius = 50;

  ArcLoadPainter({required this.maxWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 30
      ..style = PaintingStyle.stroke;
    canvas.drawPath(getPath(maxWidth), paint);
  }

  Path getPath(double x) {
    Path path = Path()
      ..moveTo(50, 0)
      ..lineTo(50, 200 - radius)
      ..moveTo(50 + radius, 200)
      ..arcToPoint(Offset(50, 200 - radius), radius: Radius.circular(radius))
      ..moveTo(50 + radius, 200)
      ..lineTo(maxWidth - 50 - radius, 200)
      ..arcToPoint(Offset(maxWidth - 50, 200 + radius),
          radius: Radius.circular(radius))
      ..lineTo(maxWidth - 50, 400 - radius)
      ..arcToPoint(Offset(maxWidth - 50 - radius, 400),
          radius: Radius.circular(radius))
      ..lineTo(50, 400);

    return path;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ArcLoad extends CustomPainterComponent {
  ArcLoad({required maxWidth})
      : super(painter: ArcLoadPainter(maxWidth: maxWidth));
}
