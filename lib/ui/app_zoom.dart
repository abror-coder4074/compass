import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const double _defaultMinZoom = 0.75;
const double _defaultMaxZoom = 1.5;
const double _scrollDeltaPerZoomUnit = 1200;

class CompassZoomController extends StatefulWidget {
  const CompassZoomController({
    required this.child,
    this.minZoom = _defaultMinZoom,
    this.maxZoom = _defaultMaxZoom,
    super.key,
  }) : assert(minZoom > 0),
       assert(maxZoom >= minZoom);

  final Widget child;
  final double minZoom;
  final double maxZoom;

  @override
  State<CompassZoomController> createState() => _CompassZoomControllerState();
}

class _CompassZoomControllerState extends State<CompassZoomController> {
  double _zoom = 1;

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent ||
        !HardwareKeyboard.instance.isControlPressed ||
        event.scrollDelta.dy == 0) {
      return;
    }

    GestureBinding.instance.pointerSignalResolver.register(
      event,
      _applyZoomFromScroll,
    );
  }

  void _applyZoomFromScroll(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) {
      return;
    }

    final nextZoom = (_zoom - event.scrollDelta.dy / _scrollDeltaPerZoomUnit)
        .clamp(widget.minZoom, widget.maxZoom)
        .toDouble();
    if ((nextZoom - _zoom).abs() < 0.001) {
      return;
    }

    setState(() {
      _zoom = nextZoom;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery == null) {
      return _buildSignalOverlay(child: widget.child);
    }

    final viewportSize = mediaQuery.size;
    final virtualSize = Size(
      viewportSize.width / _zoom,
      viewportSize.height / _zoom,
    );
    final scaledMediaQuery = _scaleMediaQuery(mediaQuery, virtualSize);

    return _buildSignalOverlay(
      child: ClipRect(
        child: Transform.scale(
          scale: _zoom,
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: virtualSize.width,
            height: virtualSize.height,
            child: MediaQuery(data: scaledMediaQuery, child: widget.child),
          ),
        ),
      ),
    );
  }

  Widget _buildSignalOverlay({required Widget child}) {
    return Stack(
      alignment: Alignment.topLeft,
      fit: StackFit.expand,
      children: [
        child,
        Positioned.fill(
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerSignal: _handlePointerSignal,
          ),
        ),
      ],
    );
  }

  MediaQueryData _scaleMediaQuery(MediaQueryData mediaQuery, Size size) {
    return mediaQuery.copyWith(
      size: size,
      devicePixelRatio: mediaQuery.devicePixelRatio * _zoom,
      padding: _scaleEdgeInsets(mediaQuery.padding),
      viewPadding: _scaleEdgeInsets(mediaQuery.viewPadding),
      viewInsets: _scaleEdgeInsets(mediaQuery.viewInsets),
      systemGestureInsets: _scaleEdgeInsets(mediaQuery.systemGestureInsets),
    );
  }

  EdgeInsets _scaleEdgeInsets(EdgeInsets insets) {
    return EdgeInsets.fromLTRB(
      insets.left / _zoom,
      insets.top / _zoom,
      insets.right / _zoom,
      insets.bottom / _zoom,
    );
  }
}
