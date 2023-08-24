import 'dart:math';

import 'package:flutter/material.dart';

class FlutterAchievement extends StatelessWidget {
  const FlutterAchievement({super.key});

  List<PathDetail> _getLogoPath() {
    final List<PathDetail> paths = [];

    final Path path = Path();
    path.moveTo(50, 50);
    path.cubicTo(50, 50, 0, 300, 400, 300);
    path.cubicTo(400, 300, 1100, 300, 600, 1000);

    paths.add(PathDetail(path));

    return paths;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("이건 플러터 코드")),
      body: Stack(
        children: [
          CustomPaint(
            foregroundPainter:
                ArcLoadPainter(_getLogoPath(), Colors.red, 1.0, false),
            size: const Size(100, 100),
          ),
          AnimatedArcLoad(),
        ],
      ),
    );
  }
}

class PathDetail {
  Path path;
  List<double>? translate = [];
  double? rotation;

  PathDetail(this.path, {this.translate, this.rotation});
}

class ArcLoadPainter extends CustomPainter {
  List<PathDetail> path = [];
  final double blur;
  bool isPlaying;
  final Color color;

  ArcLoadPainter(this.path, this.color, this.blur, this.isPlaying);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.scale(0.5, 0.5);

    for (int i = 0; i < path.length; i++) {
      if (path[i].translate != null) {
        canvas.translate(path[i].translate![0], path[i].translate![1]);
      }
      if (path[i].rotation != null) {
        canvas.rotate(path[i].rotation!);
      }
      if (blur > 0) {
        final MaskFilter blur = MaskFilter.blur(BlurStyle.normal, this.blur);
        paint.maskFilter = blur;
        canvas.drawPath(path[i].path, paint);
      }

      // paint.maskFilter = null;
      canvas.drawPath(path[i].path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class AnimatedArcLoad extends StatefulWidget {
  const AnimatedArcLoad({super.key});

  @override
  State<AnimatedArcLoad> createState() => _AnimatedArcLoadState();
}

class _AnimatedArcLoadState extends State<AnimatedArcLoad>
    with SingleTickerProviderStateMixin {
  late double scale;
  late AnimationController controller;
  late CurvedAnimation curve;
  bool isPlaying = false;
  List<List<Point<double>>> pointList = <List<Point<double>>>[
    <Point<double>>[],
  ];
  bool isReversed = false;

  List<PathDetail> _playForward() {
    final List<PathDetail> paths = [];
    final double t = curve.value;
    final double b = controller.upperBound;
    double px;
    double py;

    // path.moveTo(50, 50);
    // path.cubicTo(50, 50, 0, 300, 400, 300);
    // path.cubicTo(400, 300, 1100, 300, 600, 1000);

    //
    // path.cubicTo(100, 97, 142, 59, 169, 41);
    // path.cubicTo(197, 23, 249, 5, 204, 85);

    final Path path = Path();
    if (t < b / 2) {
      px = _getCubicPoint(t * 2, 50, 50, 0, 400);
      py = _getCubicPoint(t * 2, 50, 50, 300, 300);
      pointList[0].add(Point<double>(px, py));
    } else {
      px = _getCubicPoint(t * 2 - b, 400, 400, 1100, 600);
      py = _getCubicPoint(t * 2 - b, 300, 300, 300, 1000);
      pointList[0].add(Point<double>(px, py));
    }
    path.moveTo(50, 50);

    for (final Point<double> p in pointList[0]) {
      path.lineTo(p.x, p.y);
    }

    paths.add(PathDetail(path));

    return paths;
  }

  List<PathDetail> _playReversed() {
    for (final List<Point<double>> list in pointList) {
      if (list.isNotEmpty) {
        list.removeLast();
      }
    }
    final List<Point<double>> points = pointList[0];

    //1
    final Path path = Path();
    path.moveTo(50, 50);
    for (Point<double> point in points) {
      path.lineTo(point.x, point.y);
    }

    return <PathDetail>[PathDetail(path)];
  }

  List<PathDetail> _getPath() {
    if (isReversed == false) {
      return _playForward();
    }
    return _playReversed();
  }

  void playAnimation() {
    isPlaying = true;
    isReversed = false;
    for (final List<Point<double>> list in pointList) {
      list.clear();
    }
    controller.reset();
    controller.forward();
  }

  void stopAnimation() {
    isPlaying = false;
    controller.stop();
    for (final List<Point<double>> list in pointList) {
      list.clear();
    }
  }

  void reverseAnimation() {
    isReversed = true;
    controller.reverse();
  }

  double _getCubicPoint(double t, double p0, double p1, double p2, double p3) {
    return (pow(1 - t, 3).toDouble()) * p0 +
        3 * pow(1 - t, 2) * t * p1 +
        3 * (1 - t) * pow(t, 2) * p2 +
        pow(t, 3) * p3;
  }

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    curve = CurvedAnimation(parent: controller, curve: Curves.linear)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // reverseAnimation();
        } else if (status == AnimationStatus.dismissed) {
          playAnimation();
        }
      });
    playAnimation();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter:
          ArcLoadPainter(_getPath(), Colors.yellow, 1, isPlaying),
      size: const Size(100, 100),
    );
  }
}
