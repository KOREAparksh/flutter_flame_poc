import 'dart:math';

import 'package:flutter/material.dart';

class FlutterAchievement extends StatelessWidget {
  const FlutterAchievement({super.key});

  List<PathDetail> _getLogoPath() {
    final List<PathDetail> paths = [];

    final Path path = Path();
    path.moveTo(100, 97);
    path.cubicTo(100, 97, 142, 59, 169, 41);
    path.cubicTo(197, 23, 249, 5, 204, 85);

    paths.add(PathDetail(path));

    final Path bezier2Path = Path();
    bezier2Path.moveTo(0, 70);
    bezier2Path.cubicTo(0, 70, 42, 31, 69, 14);
    bezier2Path.cubicTo(97, -2, 149, -20, 104, 59);

    paths.add(PathDetail(
      bezier2Path,
      translate: [29.45, 151],
      rotation: -1.57,
    ));

    final Path bezier3Path = Path();
    bezier3Path.moveTo(0, 70);
    bezier3Path.cubicTo(0, 70, 44, 27, 69, 14);
    bezier3Path.cubicTo(95, -0.5, 149, -22, 104, 59);

    paths.add(PathDetail(
      bezier3Path,
      translate: [53, 200],
      rotation: -3.1415,
    ));

    final Path bezier4Path = Path();
    bezier4Path.moveTo(0, 70);
    bezier4Path.cubicTo(0, 70, 44, 27, 69, 14);
    bezier4Path.cubicTo(95, -0.5, 149, -22, 104, 59);

    paths.add(PathDetail(
      bezier4Path,
      translate: [122, 77],
      rotation: -4.712,
    ));

    return paths;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("이건 플러터 코드")),
      body: Center(
        child: Stack(
          children: [
            CustomPaint(
              foregroundPainter:
                  ArcLoadPainter(_getLogoPath(), Colors.red, 1.0, false),
              size: const Size(100, 100),
            ),
            AnimatedArcLoad(),
          ],
        ),
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
        print("111111111111111");
        canvas.translate(path[i].translate![0], path[i].translate![1]);
      }
      if (path[i].rotation != null) {
        print("2222222222222222");
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
    <Point<double>>[],
    <Point<double>>[],
    <Point<double>>[],
  ];
  bool isReversed = false;

  List<PathDetail> _playForward() {
    final List<PathDetail> paths = [];
    final double t = curve.value;
    final double b = controller.upperBound;
    double px;
    double py;

    final Path path = Path();
    if (t < b / 2) {
      px = _getCubicPoint(t * 2, 100, 100, 142, 170);
      py = _getCubicPoint(t * 2, 97, 97, 59, 41.22);
      pointList[0].add(Point<double>(px, py));
    } else {
      px = _getCubicPoint(t * 2 - b, 170, 197, 250, 204);
      py = _getCubicPoint(t * 2 - b, 41, 23, 5.5, 85);
      pointList[0].add(Point<double>(px, py));
    }
    path.moveTo(100, 97);

    for (final Point<double> p in pointList[0]) {
      path.lineTo(p.x, p.y);
    }

    paths.add(PathDetail(path));

    final Path bezier2Path = Path();
    if (t < b / 2) {
      px = _getCubicPoint(t * 2, 0, 0, 42, 70);
      py = _getCubicPoint(t * 2, 70, 70, 31, 14.77);
      pointList[1].add(Point<double>(px, py));
    } else {
      px = _getCubicPoint(t * 2 - b, 70, 97, 150, 104);
      py = _getCubicPoint(t * 2 - b, 14.7, -2.01, -20, 59.39);
      pointList[1].add(Point<double>(px, py));
    }
    bezier2Path.moveTo(0, 70.5);

    for (final Point<double> p in pointList[1]) {
      bezier2Path.lineTo(p.x, p.y);
    }

    paths.add(
        PathDetail(bezier2Path, translate: [29.45, 151], rotation: -1.5708));

    final Path bezier3Path = Path();
    if (t < b / 2) {
      px = _getCubicPoint(t * 2, 0, 0, 42, 70);
      py = _getCubicPoint(t * 2, 70, 70, 27.92, 13.7);
      pointList[2].add(Point<double>(px, py));
    } else {
      px = _getCubicPoint(t * 2 - b, 70, 97, 150, 104);
      py = _getCubicPoint(t * 2 - b, 13.7, -0.52, -22, 58.39);
      pointList[2].add(Point<double>(px, py));
    }
    bezier3Path.moveTo(0, 69.5);

    for (final Point<double> p in pointList[2]) {
      bezier3Path.lineTo(p.x, p.y);
    }

    paths.add(PathDetail(bezier3Path, translate: [53, 200], rotation: -3.1415));

    final Path bezier4Path = Path();
    print("123");
    if (t < b / 2) {
      px = _getCubicPoint(t * 2, 0, 0, 43, 70);
      py = _getCubicPoint(t * 2, 70, 70, 27.92, 13.7);
      pointList[3].add(Point<double>(px, py));
    } else {
      px = _getCubicPoint(t * 2 - b, 70, 97, 150, 104);
      py = _getCubicPoint(t * 2 - b, 13.7, -0.52, -22, 58.39);
      pointList[3].add(Point<double>(px, py));
    }
    bezier4Path.moveTo(0, 69.5);

    for (final Point<double> p in pointList[3]) {
      bezier4Path.lineTo(p.x, p.y);
    }

    paths.add(
        PathDetail(bezier4Path, translate: [122.4, 77], rotation: -4.7123));

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
    path.moveTo(100, 97);
    for (Point<double> point in points) {
      path.lineTo(point.x, point.y);
    }

    //2
    final Path bezier2Path = Path();
    bezier2Path.moveTo(0, 70.55);
    for (Point<double> point in pointList[1]) {
      bezier2Path.lineTo(point.x, point.y);
    }

    //3
    final Path bezier3Path = Path();
    bezier3Path.moveTo(0, 69.48);
    for (Point<double> point in pointList[2]) {
      bezier3Path.lineTo(point.x, point.y);
    }

    //4
    final Path bezier4Path = Path();
    bezier4Path.moveTo(0, 69.48);
    for (Point<double> point in pointList[3]) {
      bezier4Path.lineTo(point.x, point.y);
    }

    return <PathDetail>[
      PathDetail(path),
      PathDetail(bezier2Path, translate: [29.45, 151], rotation: -1.5708),
      PathDetail(bezier3Path, translate: [53, 200], rotation: -3.14159),
      PathDetail(bezier4Path, translate: [122.48, 77], rotation: -4.71239),
    ];
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
          reverseAnimation();
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
