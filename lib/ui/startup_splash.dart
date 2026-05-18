import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'compass_theme.dart';

const Color _startupTransparentBackground = Color(0x00000000);

class CompassStartupSplashApp extends StatelessWidget {
  const CompassStartupSplashApp({
    this.backgroundColor = _startupTransparentBackground,
    super.key,
  });

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Compass',
      color: backgroundColor,
      theme: buildCompassTheme(),
      home: CompassStartupSplash(backgroundColor: backgroundColor),
    );
  }
}

class CompassStartupErrorApp extends StatelessWidget {
  const CompassStartupErrorApp({
    required this.error,
    required this.onRetry,
    super.key,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Compass',
      color: _startupTransparentBackground,
      theme: buildCompassTheme(),
      home: CompassStartupErrorScreen(error: error, onRetry: onRetry),
    );
  }
}

class CompassStartupSplash extends StatelessWidget {
  const CompassStartupSplash({
    this.backgroundColor = _startupTransparentBackground,
    super.key,
  });

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final contentWidth = math.max(280.0, math.min(520.0, screenWidth - 64));
    final iconSize = math.max(138.0, math.min(188.0, contentWidth * 0.36));

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Transform.translate(
          offset: const Offset(0, -24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                CompassAssets.splashIcon,
                width: iconSize,
                height: iconSize,
                filterQuality: FilterQuality.high,
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: contentWidth,
                child: const Text(
                  'Loading, please wait ...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF4B4B4B),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: contentWidth,
                height: 10,
                child: const _WindowsLoadingBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompassStartupErrorScreen extends StatelessWidget {
  const CompassStartupErrorScreen({
    required this.error,
    required this.onRetry,
    super.key,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 42,
                  color: CompassColors.warning,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Compass could not start',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: CompassColors.mutedText,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 22),
                ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WindowsLoadingBar extends StatefulWidget {
  const _WindowsLoadingBar();

  @override
  State<_WindowsLoadingBar> createState() => _WindowsLoadingBarState();
}

class _WindowsLoadingBarState extends State<_WindowsLoadingBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1450),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _WindowsLoadingBarPainter(_controller));
  }
}

class _WindowsLoadingBarPainter extends CustomPainter {
  _WindowsLoadingBarPainter(this.animation) : super(repaint: animation);

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final trackHeight = math.min(8.0, size.height);
    final trackRect = Rect.fromLTWH(
      0,
      (size.height - trackHeight) / 2,
      size.width,
      trackHeight,
    );

    canvas.drawRect(trackRect, Paint()..color = Colors.white);
    canvas.drawRect(
      trackRect,
      Paint()
        ..color = const Color(0xFFC5C5C5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    final t = animation.value;
    final easedPosition = Curves.easeInOutCubic.transform(t);
    final pulse = math.sin(math.pi * t);
    final segmentWidth = size.width * (0.18 + (0.22 * pulse));
    final segmentLeft =
        -segmentWidth + ((size.width + segmentWidth) * easedPosition);
    final segmentRect = Rect.fromLTWH(
      segmentLeft,
      trackRect.top + 1,
      segmentWidth,
      math.max(1, trackHeight - 2),
    );

    canvas.save();
    canvas.clipRect(trackRect.deflate(1));
    canvas.drawRect(segmentRect, Paint()..color = const Color(0xFF0789A2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WindowsLoadingBarPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
