import 'package:compass/ui/app_zoom.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ctrl scroll zooms app content without scrolling the page', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1;

    final scrollController = ScrollController();
    addTearDown(scrollController.dispose);

    Size? observedSize;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: CompassZoomController(
            child: Builder(
              builder: (context) {
                observedSize = MediaQuery.sizeOf(context);
                return SingleChildScrollView(
                  controller: scrollController,
                  child: const SizedBox(width: 800, height: 2000),
                );
              },
            ),
          ),
        ),
      ),
    );

    expect(observedSize, const Size(800, 600));
    expect(scrollController.offset, 0);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    tester.binding.handlePointerEvent(
      const PointerScrollEvent(
        position: Offset(100, 100),
        scrollDelta: Offset(0, 120),
      ),
    );
    await tester.pump();
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);

    expect(observedSize!.width, closeTo(800 / 0.9, 0.01));
    expect(observedSize!.height, closeTo(600 / 0.9, 0.01));
    expect(scrollController.offset, 0);

    tester.binding.handlePointerEvent(
      const PointerScrollEvent(
        position: Offset(100, 100),
        scrollDelta: Offset(0, 120),
      ),
    );
    await tester.pump();

    expect(scrollController.offset, greaterThan(0));
  });
}
