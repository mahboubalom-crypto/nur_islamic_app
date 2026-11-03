import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class StopwatchSection extends StatefulWidget {
  const StopwatchSection({super.key});

  @override
  State<StopwatchSection> createState() => _StopwatchSectionState();
}

class _StopwatchSectionState extends State<StopwatchSection> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;

  void _start() {
    _stopwatch.start();
    _ticker = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (mounted) setState(() {});
    });
    setState(() {});
  }

  void _pause() {
    _stopwatch.stop();
    _ticker?.cancel();
    setState(() {});
  }

  void _reset() {
    _stopwatch.stop();
    _stopwatch.reset();
    _ticker?.cancel();
    setState(() {});
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final elapsed = _stopwatch.elapsed;
    final minutes = elapsed.inMinutes % 60;
    final seconds = elapsed.inSeconds % 60;
    final centis = (elapsed.inMilliseconds % 1000) ~/ 10;

    final secondsFraction = (elapsed.inMilliseconds % 60000) / 60000;
    final minutesFraction =
        (elapsed.inMilliseconds % (30 * 60000)) / (30 * 60000);

    final isRunning = _stopwatch.isRunning;
    final hasTime = elapsed.inMilliseconds > 0;

    return Container(
      color: Colors.black,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const buttonAreaHeight =
              68.0 + 60.0; // button size + spacing + safety margin
          const verticalPadding = 16.0 * 2;
          final availableHeight = constraints.maxHeight.isFinite
              ? constraints.maxHeight - buttonAreaHeight - verticalPadding
              : constraints.maxWidth * 0.7; // fallback if unbounded
          final dialSize = math.min(
            constraints.maxWidth - 80,
            availableHeight > 100 ? availableHeight : constraints.maxWidth - 80,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: dialSize,
                  height: dialSize,
                  child: CustomPaint(
                    painter: _StopwatchDialPainter(
                      secondsFraction: secondsFraction,
                      minutesFraction: minutesFraction,
                    ),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '${_twoDigits(minutes)}:${_twoDigits(seconds)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                              ),
                            ),
                            TextSpan(
                              text: ',${_twoDigits(centis)}',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 34,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (hasTime) ...[
                      _RoundIconButton(
                        icon: Icons.refresh,
                        backgroundColor: const Color(0xFF2C2C2E),
                        iconColor: Colors.white,
                        onTap: _reset,
                      ),
                      const SizedBox(width: 28),
                    ],
                    _RoundIconButton(
                      icon: isRunning ? Icons.pause : Icons.play_arrow,
                      backgroundColor: Colors.blue,
                      iconColor: Colors.white,
                      size: 68,
                      onTap: isRunning ? _pause : _start,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final VoidCallback onTap;

  const _RoundIconButton({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: backgroundColor == Colors.blue
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Icon(icon, color: iconColor, size: size * 0.45),
      ),
    );
  }
}

class _StopwatchDialPainter extends CustomPainter {
  final double secondsFraction; // 0..1 over 60s
  final double minutesFraction; // 0..1 over 30min

  _StopwatchDialPainter({
    required this.secondsFraction,
    required this.minutesFraction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // Outer face
    final facePaint = Paint()..color = const Color(0xFF2C2C2E);
    canvas.drawCircle(center, radius, facePaint);

    final rimPaint = Paint()
      ..color = const Color(0xFF3A3A3C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius - 2, rimPaint);

    // Ticks
    final tickPaint = Paint()..color = Colors.grey[500]!;
    for (int i = 0; i < 60; i++) {
      final angle = (i / 60) * 2 * math.pi - math.pi / 2;
      final isMajor = i % 5 == 0;
      final outerR = radius * 0.92;
      final innerR = isMajor ? radius * 0.84 : radius * 0.88;
      final p1 = center + Offset(math.cos(angle), math.sin(angle)) * outerR;
      final p2 = center + Offset(math.cos(angle), math.sin(angle)) * innerR;
      tickPaint.strokeWidth = isMajor ? 2.5 : 1.2;
      canvas.drawLine(p1, p2, tickPaint);
    }

    // Numbers 5,10,...,60
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 5; i <= 60; i += 5) {
      final label = i == 60 ? '60' : '$i';
      final angle = (i / 60) * 2 * math.pi - math.pi / 2;
      final r = radius * 0.72;
      final pos = center + Offset(math.cos(angle), math.sin(angle)) * r;
      textPainter.text = TextSpan(
        text: label,
        style: TextStyle(
          color: i == 60 ? Colors.white : Colors.grey[300],
          fontSize: radius * 0.13,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        pos - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    // Sub dial (minutes, 0-30)
    final subCenter = center + Offset(0, radius * 0.32);
    final subRadius = radius * 0.28;
    final subFacePaint = Paint()..color = const Color(0xFF262628);
    canvas.drawCircle(subCenter, subRadius, subFacePaint);
    final subRimPaint = Paint()
      ..color = const Color(0xFF3A3A3C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(subCenter, subRadius, subRimPaint);

    for (int i = 5; i <= 30; i += 5) {
      final angle = (i / 30) * 2 * math.pi - math.pi / 2;
      final r = subRadius * 0.65;
      final pos = subCenter + Offset(math.cos(angle), math.sin(angle)) * r;
      textPainter.text = TextSpan(
        text: '$i',
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: subRadius * 0.28,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        pos - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    // Sub hand (minutes within 30)
    final subAngle = minutesFraction * 2 * math.pi - math.pi / 2;
    final subHandPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      subCenter,
      subCenter +
          Offset(math.cos(subAngle), math.sin(subAngle)) * (subRadius * 0.75),
      subHandPaint,
    );
    canvas.drawCircle(subCenter, 3, Paint()..color = Colors.white);

    // Main second hand (blue)
    final mainAngle = secondsFraction * 2 * math.pi - math.pi / 2;
    final mainHandPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      center,
      center +
          Offset(math.cos(mainAngle), math.sin(mainAngle)) * (radius * 0.78),
      mainHandPaint,
    );
    canvas.drawCircle(center, 6, Paint()..color = Colors.blue);
    canvas.drawCircle(
      center,
      6,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _StopwatchDialPainter oldDelegate) {
    return oldDelegate.secondsFraction != secondsFraction ||
        oldDelegate.minutesFraction != minutesFraction;
  }
}
