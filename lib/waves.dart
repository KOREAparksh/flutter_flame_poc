import 'dart:math';

import 'package:flutter/material.dart';

class WavesTest extends StatefulWidget {
  const WavesTest({super.key});

  @override
  State<WavesTest> createState() => _WavesTestState();
}

class _WavesTestState extends State<WavesTest>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  );

  double percent = 0.0;
  double height = 30;

  @override
  void initState() {
    super.initState();
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text("예림님이 꿈꾸던 바로 그것")),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "대충 시간 나오던 거기",
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: CustomPaint(
                        painter: _WaveCustomPainter(
                          animationValue: _animationController.value,
                          maxWidth: screenWidth,
                          maxHeight: screenHeight,
                          percent: percent,
                          height: height,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text("파도높이"),
                  ),
                  Expanded(
                    child: Slider(
                      onChanged: (v) {
                        percent = v;
                        setState(() {});
                      },
                      value: percent,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text("높이"),
                  ),
                  Expanded(
                    child: Slider(
                      min: 10,
                      max: 100,
                      onChanged: (v) {
                        height = v;
                        setState(() {});
                      },
                      value: height,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WaveCustomPainter extends CustomPainter {
  _WaveCustomPainter({
    required this.animationValue,
    required this.maxWidth,
    required this.maxHeight,
    required this.percent,
    required this.height,
  });
  final double animationValue;
  final double maxWidth;
  final double maxHeight;
  final double percent;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    double heightParameter = height;
    double periodParameter = 0.3;

    Paint paint = Paint()
      ..color = const Color(0x55C869FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Path path = Path();
    // TODO: do operations here

    for (double x = 0; x < maxWidth; x++) {
      path.lineTo(
          x,
          defaultHeight() +
              heightParameter *
                  sin(animationValue * pi * 2 +
                      periodParameter * x * (pi / 180)));
      path.moveTo(x, maxHeight);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  double defaultHeight() {
    if ((maxHeight) * (1 - percent) >= maxHeight - 200) {
      return maxHeight - 200;
    }
    return ((maxHeight) * (1 - percent));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
