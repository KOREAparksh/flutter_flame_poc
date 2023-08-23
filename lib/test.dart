import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("테스트...테스토스테론...")),
      body: Column(
        children: [
          Expanded(
            child: GameWidget(game: Map()),
          ),
        ],
      ),
    );
  }
}

class Map extends FlameGame with TapDetector, DoubleTapDetector {
  late final GameOverButton gameOverButton;
  late final SpriteComponent player;
  late NineTileBoxComponent nineTileBoxComponent;
  late NineTileBoxComponent nineTileBoxComponent2;

  Map();

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    //text
    add(GameOverPanel(position: Vector2(size.x / 2, size.y / 2)));
    gameOverButton = GameOverButton(
      Vector2(size.x * 0.25, size.y - 20),
    );

    //button
    add(gameOverButton);

    //sprite
    final sprite = await Sprite.load("search_empty.png");
    player = SpriteComponent(
      size: Vector2.all(50),
      sprite: sprite,
      position: Vector2(50, 50),
      anchor: Anchor.center,
    );

    add(player);

    //parallax
    final data = [
      ParallaxImageData("nfc_android.png"),
      ParallaxImageData("search_empty.png"),
    ];
    final parallax = await loadParallaxComponent(
      data,
      baseVelocity: Vector2(20, 0),
      velocityMultiplierDelta: Vector2(3.8, 1.0),
    );
    add(parallax);

    //Tile
    // final tiled = TiledComponent('map.tmx', Size(16, 16));
    // final tile = NineTileBox(await Sprite.load('map.tmx'));

    final sprite2 = Sprite(await images.load('nine-box.png'));
    final boxSize = Vector2.all(300);
    final nineTileBox = NineTileBox(sprite2, destTileSize: 148);
    add(
      nineTileBoxComponent = NineTileBoxComponent(
        nineTileBox: nineTileBox,
        position: size / 2,
        size: boxSize,
        anchor: Anchor.center,
      ),
    );

    //tile2
    final sprite3 = Sprite(await images.load('speech-bubble.png'));
    final boxSize3 = Vector2.all(300);
    final nineTileBox3 = NineTileBox.withGrid(
      sprite3,
      leftWidth: 31,
      rightWidth: 5,
      topHeight: 5,
      bottomHeight: 21,
    );
    add(
      nineTileBoxComponent = NineTileBoxComponent(
        nineTileBox: nineTileBox3,
        position: size / 2,
        size: boxSize3,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void onTap() {
    nineTileBoxComponent.scale.scale(1.2);
  }

  @override
  void onDoubleTap() {
    nineTileBoxComponent.scale.scale(0.8);
  }

  @override
  void update(double dt) {
    super.update(dt);
    player.angle += 0.01;
  }
}

class GameOverPanel extends PositionComponent {
  bool visible = false;

  GameOverPanel({required position}) : super(position: position);

  @override
  void onLoad() {
    final gameOverText = GameOverText(); // GameOverText is a Component
    add(gameOverText);
  }

  @override
  void render(Canvas canvas) {
    if (visible) {} // If not visible none of the children will be rendered
  }
}

class GameOverText extends TextComponent {
  GameOverText()
      : super(
          text: '123',
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 40,
            ),
          ),
          anchor: Anchor.center,
          position: Vector2(0, 0),
        );
}

class GameOverButton extends ButtonComponent {
  GameOverButton(position)
      : super(
          button: RectangleComponent(
            size: Vector2.all(100),
          ),
          anchor: Anchor.center,
          position: position,
        );
}

class NineTileBoxExample extends FlameGame with TapDetector, DoubleTapDetector {
  static const String description = '''
    If you want to create a background for something that can stretch you can
    use the `NineTileBox` which is showcased here.\n\n
    Tap to make the box bigger and double tap to make it smaller.
  ''';

  late NineTileBoxComponent nineTileBoxComponent;

  @override
  Future<void> onLoad() async {
    final sprite = Sprite(await images.load('map-level1.png'));
    final boxSize = Vector2.all(300);
    final nineTileBox = NineTileBox(sprite, destTileSize: 148);
    add(
      nineTileBoxComponent = NineTileBoxComponent(
        nineTileBox: nineTileBox,
        position: size / 2,
        size: boxSize,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void onTap() {
    nineTileBoxComponent.scale.scale(1.2);
  }

  @override
  void onDoubleTap() {
    nineTileBoxComponent.scale.scale(0.8);
  }
}
