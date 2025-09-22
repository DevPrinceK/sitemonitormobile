import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'auth/login_screen.dart';
import 'tabs_root_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final AnimationController _ringsCtrl;
  late final AnimationController _logoCtrl;
  late final AnimationController _titleCtrl;
  late final AnimationController _breathCtrl;

  @override
  void initState() {
    super.initState();
    _bgCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat();
    _ringsCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..forward();
    _logoCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..forward();
    _titleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _breathCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2600))
      ..repeat(reverse: true);

    // Stagger title appearance after logo mostly drawn
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _titleCtrl.forward();
    });

    // Navigate after total sequence
    Future.delayed(const Duration(milliseconds: 2400), _finish);
  }

  void _finish() {
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    final route =
        auth.isAuthenticated ? const TabsRootScreen() : const LoginScreen();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => route));
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _ringsCtrl.dispose();
    _logoCtrl.dispose();
    _titleCtrl.dispose();
    _breathCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated radial gradient background
          AnimatedBuilder(
            animation: _bgCtrl,
            builder: (context, _) {
              final t = _bgCtrl.value;
              // Subtle color lerp for ambiance
              final c1 = Color.lerp(colorScheme.primary, colorScheme.secondary,
                  0.3 + 0.2 * math.sin(t * math.pi * 2))!;
              final c2 = Color.lerp(
                  colorScheme.tertiary,
                  colorScheme.primaryContainer,
                  0.3 + 0.2 * math.cos(t * math.pi * 2))!;
              return DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0.0 + 0.05 * math.sin(t * math.pi * 2),
                        -0.1 + 0.05 * math.cos(t * math.pi * 2)),
                    radius: 1.2,
                    colors: [c1, c2],
                  ),
                ),
              );
            },
          ),
          // Pulsating radar rings
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _ringsCtrl,
                builder: (context, _) => CustomPaint(
                  painter: _RingsPainter(
                    _ringsCtrl.value,
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.15),
                  ),
                ),
              ),
            ),
          ),
          // Center content (logo + title)
          // Center logo drawing only
          Center(
            child: AnimatedBuilder(
              animation: _logoCtrl,
              builder: (context, _) => CustomPaint(
                size: const Size(140, 140),
                painter: _LogoPainter(
                  progress: Curves.easeOutCubic.transform(_logoCtrl.value),
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          // Bottom breathing app title
          Positioned(
            left: 0,
            right: 0,
            bottom: 48,
            child: AnimatedBuilder(
              animation: _breathCtrl,
              builder: (context, _) {
                // Use a smooth sinusoidal curve for breathing effect
                final t = _breathCtrl.value; // 0..1
                final wave = (math.sin((t * 2 * math.pi)) + 1) / 2; // 0..1
                final scale = 0.94 + wave * 0.06; // 0.94 - 1.00
                final opacity = 0.65 + wave * 0.35; // 0.65 - 1.0
                return Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: scale,
                    child: Text(
                      'Site Monitor',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                            color: colorScheme.onPrimary,
                          ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  final double t; // 0..1
  final Color ringColor;
  _RingsPainter(this.t, this.ringColor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = (size.shortestSide * 0.55);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw multiple rings with phase offsets
    const ringCount = 4;
    for (int i = 0; i < ringCount; i++) {
      final phase = (t + i / ringCount) % 1.0;
      final radius = phase * maxRadius;
      final opacity = (1 - phase).clamp(0.0, 1.0) * 0.7;
      if (opacity < 0.05) continue;
      paint.color = ringColor.withOpacity(opacity);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.ringColor != ringColor;
}

class _LogoPainter extends CustomPainter {
  final double progress; // 0..1
  final Color color;
  _LogoPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Simple stylized monitoring glyph: outer circle + pulse waveform + check mark
    final path = Path();
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.45;
    // Circle
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    // Waveform inside
    final waveWidth = radius * 1.4;
    final left = center.dx - waveWidth / 2;
    final midY = center.dy;
    final segment = waveWidth / 6;
    final wave = Path()
      ..moveTo(left, midY)
      ..relativeLineTo(segment, -20)
      ..relativeLineTo(segment, 40)
      ..relativeLineTo(segment, -30)
      ..relativeLineTo(segment, 20)
      ..relativeLineTo(segment, -10)
      ..relativeLineTo(segment, 0);

    // Check mark overlay (small)
    final check = Path();
    final cStart = Offset(center.dx - 12, center.dy + 18);
    check.moveTo(cStart.dx, cStart.dy);
    check.lineTo(cStart.dx + 10, cStart.dy + 10);
    check.lineTo(cStart.dx + 28, cStart.dy - 14);

    // Combine
    final combined = Path()
      ..addPath(wave, Offset.zero)
      ..addPath(check, Offset.zero);

    // Convert to metrics for progressive draw
    // Collect path metrics for progressive drawing
    final metrics = [...path.computeMetrics(), ...combined.computeMetrics()];
    final drawPath = Path();
    for (final m in metrics) {
      final len = m.length * progress;
      drawPath.addPath(m.extractPath(0, len), Offset.zero);
    }

    canvas.drawPath(drawPath, stroke);
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
