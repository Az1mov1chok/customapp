import 'dart:math';
import 'package:flutter/material.dart';

/// Модель одной темы живого фона
class WallpaperTheme {
  final String id;
  final String name;
  final List<Color> colors;
  final Widget Function() builder;

  const WallpaperTheme({
    required this.id,
    required this.name,
    required this.colors,
    required this.builder,
  });
}

final List<WallpaperTheme> wallpaperThemes = [
  WallpaperTheme(
    id: 'monoglyph',
    name: 'Mono Glyph',
    colors: const [Color(0xFFFFFFFF), Color(0xFF000000)],
    builder: () => const MonoGlyphBackground(),
  ),
  WallpaperTheme(
    id: 'aurora',
    name: 'Aurora',
    colors: const [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
    builder: () => const AuroraBackground(),
  ),
  WallpaperTheme(
    id: 'starfield',
    name: 'Starfield',
    colors: const [Color(0xFF0F172A), Color(0xFF312E81)],
    builder: () => const StarfieldBackground(),
  ),
  WallpaperTheme(
    id: 'particles',
    name: 'Particles',
    colors: const [Color(0xFFEC4899), Color(0xFFF59E0B)],
    builder: () => const ParticlesBackground(),
  ),
  WallpaperTheme(
    id: 'waves',
    name: 'Ocean Waves',
    colors: const [Color(0xFF0891B2), Color(0xFF0E7490)],
    builder: () => const WavesBackground(),
  ),
  WallpaperTheme(
    id: 'bubbles',
    name: 'Bubbles',
    colors: const [Color(0xFF14B8A6), Color(0xFF6366F1)],
    builder: () => const BubblesBackground(),
  ),
  WallpaperTheme(
    id: 'plasma',
    name: 'Plasma',
    colors: const [Color(0xFFDC2626), Color(0xFF7C3AED)],
    builder: () => const PlasmaBackground(),
  ),
];

// ---------------- MONO GLYPH (ч/б, свой знак) ----------------
class MonoGlyphBackground extends StatefulWidget {
  const MonoGlyphBackground({super.key});
  @override
  State<MonoGlyphBackground> createState() => _MonoGlyphBackgroundState();
}

class _MonoGlyphBackgroundState extends State<MonoGlyphBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        // Плавное дыхание между чисто белым и чисто чёрным фоном
        final bgIsWhite = _c.value < 0.5;
        final bg = bgIsWhite ? Colors.white : Colors.black;
        final fg = bgIsWhite ? Colors.black : Colors.white;
        return Container(
          color: bg,
          child: Center(
            child: Transform.scale(
              scale: 1.0 + sin(_c.value * pi) * 0.04,
              child: CustomPaint(
                size: const Size(140, 170),
                painter: _GlyphPainter(fg),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Собственный минималистичный знак "плод с листиком" — не копия
/// чужого логотипа, просто абстрактная ч/б метка для приложения.
class _GlyphPainter extends CustomPainter {
  final Color color;
  _GlyphPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Тело "плода" — два перекрывающихся овала
    final bodyPath = Path();
    final w = size.width;
    final h = size.height;
    bodyPath.addOval(Rect.fromLTWH(w * 0.05, h * 0.25, w * 0.45, h * 0.65));
    bodyPath.addOval(Rect.fromLTWH(w * 0.45, h * 0.25, w * 0.5, h * 0.7));
    canvas.drawPath(bodyPath, paint);

    // Лёгкая выемка слева, как узнаваемый силуэт "откушенного" края
    final bitePaint = Paint()
      ..color = color == Colors.black ? Colors.white : Colors.black
      ..style = PaintingStyle.fill;
    canvas.drawOval(
        Rect.fromLTWH(w * 0.78, h * 0.42, w * 0.22, h * 0.22), bitePaint);

    // Листик
    final leafPath = Path();
    leafPath.moveTo(w * 0.55, h * 0.22);
    leafPath.quadraticBezierTo(
        w * 0.75, h * 0.05, w * 0.88, h * 0.15);
    leafPath.quadraticBezierTo(
        w * 0.68, h * 0.18, w * 0.55, h * 0.22);
    leafPath.close();
    canvas.drawPath(leafPath, paint);

    // Черенок
    final stemPaint = Paint()
      ..color = color
      ..strokeWidth = w * 0.035
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(w * 0.5, h * 0.25), Offset(w * 0.55, h * 0.1), stemPaint);
  }

  @override
  bool shouldRepaint(covariant _GlyphPainter oldDelegate) =>
      oldDelegate.color != color;
}

// ---------------- AURORA ----------------
class AuroraBackground extends StatefulWidget {
  const AuroraBackground({super.key});
  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 8))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => CustomPaint(
        painter: _AuroraPainter(_c.value),
        size: Size.infinite,
      ),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  final double t;
  _AuroraPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0A0A1A);
    canvas.drawRect(Offset.zero & size, bg);

    final colors = [
      const Color(0xFF8B5CF6),
      const Color(0xFF06B6D4),
      const Color(0xFFEC4899),
    ];

    for (int i = 0; i < 3; i++) {
      final path = Path();
      final phase = t * 2 * pi + i * 2;
      final baseY = size.height * (0.3 + i * 0.2);
      path.moveTo(0, baseY);
      for (double x = 0; x <= size.width; x += 10) {
        final y = baseY +
            sin((x / size.width * 2 * pi) + phase) * 60 +
            cos((x / size.width * 3 * pi) + phase * 0.5) * 30;
        path.lineTo(x, y);
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();

      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors[i].withOpacity(0.35), colors[i].withOpacity(0.0)],
        ).createShader(Offset.zero & size)
        ..blendMode = BlendMode.plus;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter oldDelegate) => true;
}

// ---------------- STARFIELD ----------------
class StarfieldBackground extends StatefulWidget {
  const StarfieldBackground({super.key});
  @override
  State<StarfieldBackground> createState() => _StarfieldBackgroundState();
}

class _Star {
  double x, y, z, r;
  _Star(this.x, this.y, this.z, this.r);
}

class _StarfieldBackgroundState extends State<StarfieldBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 20))
        ..repeat();
  final List<_Star> _stars =
      List.generate(120, (i) {
    final rnd = Random(i);
    return _Star(rnd.nextDouble(), rnd.nextDouble(), rnd.nextDouble(),
        rnd.nextDouble() * 2 + 0.5);
  });

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => CustomPaint(
        painter: _StarfieldPainter(_stars, _c.value),
        size: Size.infinite,
      ),
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  final List<_Star> stars;
  final double t;
  _StarfieldPainter(this.stars, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    for (final s in stars) {
      final twinkle = (sin(t * 2 * pi * 3 + s.z * 10) + 1) / 2;
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.3 + twinkle * 0.7);
      canvas.drawCircle(
          Offset(s.x * size.width, s.y * size.height), s.r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) => true;
}

// ---------------- PARTICLES ----------------
class ParticlesBackground extends StatefulWidget {
  const ParticlesBackground({super.key});
  @override
  State<ParticlesBackground> createState() => _ParticlesBackgroundState();
}

class _Particle {
  double x, y, vx, vy, r;
  _Particle(this.x, this.y, this.vx, this.vy, this.r);
}

class _ParticlesBackgroundState extends State<ParticlesBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 6))
        ..repeat();
  final List<_Particle> _particles = List.generate(40, (i) {
    final rnd = Random(i * 7);
    return _Particle(rnd.nextDouble(), rnd.nextDouble(),
        (rnd.nextDouble() - 0.5) * 0.3, (rnd.nextDouble() - 0.5) * 0.3,
        rnd.nextDouble() * 4 + 2);
  });

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => CustomPaint(
        painter: _ParticlesPainter(_particles, _c.value),
        size: Size.infinite,
      ),
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;
  _ParticlesPainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF450A0A), Color(0xFF78350F)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    final points = <Offset>[];
    for (final p in particles) {
      final x = ((p.x + p.vx * t) % 1.0 + 1.0) % 1.0 * size.width;
      final y = ((p.y + p.vy * t) % 1.0 + 1.0) % 1.0 * size.height;
      points.add(Offset(x, y));
      final paint = Paint()..color = const Color(0xFFF59E0B).withOpacity(0.8);
      canvas.drawCircle(Offset(x, y), p.r, paint);
    }

    final linePaint = Paint()
      ..color = const Color(0xFFEC4899).withOpacity(0.15)
      ..strokeWidth = 1;
    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final d = (points[i] - points[j]).distance;
        if (d < 90) {
          canvas.drawLine(points[i], points[j], linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) => true;
}

// ---------------- WAVES ----------------
class WavesBackground extends StatefulWidget {
  const WavesBackground({super.key});
  @override
  State<WavesBackground> createState() => _WavesBackgroundState();
}

class _WavesBackgroundState extends State<WavesBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 5))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => CustomPaint(
        painter: _WavesPainter(_c.value),
        size: Size.infinite,
      ),
    );
  }
}

class _WavesPainter extends CustomPainter {
  final double t;
  _WavesPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF082F49), Color(0xFF0C4A6E)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    final layers = [
      (const Color(0xFF0891B2), 0.55, 1.0),
      (const Color(0xFF06B6D4), 0.65, 1.4),
      (const Color(0xFF67E8F9), 0.78, 2.0),
    ];

    for (final (color, heightFrac, speed) in layers) {
      final path = Path();
      final baseY = size.height * heightFrac;
      path.moveTo(0, size.height);
      path.lineTo(0, baseY);
      for (double x = 0; x <= size.width; x += 8) {
        final y = baseY +
            sin((x / size.width * 4 * pi) + t * 2 * pi * speed) * 18;
        path.lineTo(x, y);
      }
      path.lineTo(size.width, size.height);
      path.close();
      canvas.drawPath(path, Paint()..color = color.withOpacity(0.55));
    }
  }

  @override
  bool shouldRepaint(covariant _WavesPainter oldDelegate) => true;
}

// ---------------- BUBBLES ----------------
class BubblesBackground extends StatefulWidget {
  const BubblesBackground({super.key});
  @override
  State<BubblesBackground> createState() => _BubblesBackgroundState();
}

class _Bubble {
  double x, startDelay, speed, r;
  _Bubble(this.x, this.startDelay, this.speed, this.r);
}

class _BubblesBackgroundState extends State<BubblesBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 10))
        ..repeat();
  final List<_Bubble> _bubbles = List.generate(25, (i) {
    final rnd = Random(i * 3);
    return _Bubble(rnd.nextDouble(), rnd.nextDouble(),
        rnd.nextDouble() * 0.6 + 0.4, rnd.nextDouble() * 14 + 4);
  });

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => CustomPaint(
        painter: _BubblesPainter(_bubbles, _c.value),
        size: Size.infinite,
      ),
    );
  }
}

class _BubblesPainter extends CustomPainter {
  final List<_Bubble> bubbles;
  final double t;
  _BubblesPainter(this.bubbles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF134E4A), Color(0xFF312E81)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    for (final b in bubbles) {
      final progress = ((t * b.speed + b.startDelay) % 1.0);
      final y = size.height * (1 - progress);
      final x = b.x * size.width + sin(progress * 4 * pi) * 15;
      final paint = Paint()
        ..color = const Color(0xFF99F6E4).withOpacity(0.35 * (1 - progress))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(Offset(x, y), b.r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BubblesPainter oldDelegate) => true;
}

// ---------------- PLASMA ----------------
class PlasmaBackground extends StatefulWidget {
  const PlasmaBackground({super.key});
  @override
  State<PlasmaBackground> createState() => _PlasmaBackgroundState();
}

class _PlasmaBackgroundState extends State<PlasmaBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(seconds: 7))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => CustomPaint(
        painter: _PlasmaPainter(_c.value),
        size: Size.infinite,
      ),
    );
  }
}

class _PlasmaPainter extends CustomPainter {
  final double t;
  _PlasmaPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF18181B);
    canvas.drawRect(Offset.zero & size, bg);

    final blobs = [
      (const Color(0xFFDC2626), 0.3, 0.3, 1.0),
      (const Color(0xFF7C3AED), 0.7, 0.4, 1.3),
      (const Color(0xFFDB2777), 0.5, 0.7, 0.8),
    ];

    for (final (color, bx, by, speed) in blobs) {
      final angle = t * 2 * pi * speed;
      final cx = (bx + 0.15 * cos(angle)) * size.width;
      final cy = (by + 0.15 * sin(angle)) * size.height;
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [color.withOpacity(0.55), color.withOpacity(0.0)],
        ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: 180))
        ..blendMode = BlendMode.plus;
      canvas.drawCircle(Offset(cx, cy), 180, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PlasmaPainter oldDelegate) => true;
}
