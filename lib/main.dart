import 'package:flutter/material.dart';
import 'package:flutter_flame_poc/arc_load_paint.dart';
import 'package:flutter_flame_poc/falling_poop_game.dart';
import 'package:flutter_flame_poc/flutter_achievement.dart';
import 'package:flutter_flame_poc/load_achievement.dart';
import 'package:flutter_flame_poc/load_achievement_once.dart';
import 'package:flutter_flame_poc/test.dart';
import 'package:flutter_flame_poc/waves.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("자 드가자~")),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FallingPoopGameScreen(),
                    ));
              },
              child: const Text("떨어지는 똥 먹기 game start"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Test(),
                    ));
              },
              child: const Text("component test start"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FlutterAchievement(),
                    ));
              },
              child: const Text("플러터로 만든 업적 start"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ArcLoadTest(),
                    ));
              },
              child: const Text("곡선 load start"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoadAchievement(),
                    ));
              },
              child: const Text("업적 start"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoadAchievementOnce(
                        startLevel: 0,
                        maxLevel: 23,
                      ),
                    ));
              },
              child: const Text("업적 애니메이션 한번에 start"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoadAchievementOnce(
                        startLevel: 6,
                        maxLevel: 17,
                      ),
                    ));
              },
              child: const Text("업적 애니메이션 6 ~ 10 start"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const WavesTest(),
                    ));
              },
              child: const Text("물결테스트"),
            ),
          ],
        ),
      ),
    );
  }
}
