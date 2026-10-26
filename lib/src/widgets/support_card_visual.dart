import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/support_card.dart';

/// Original nautical boost-card art — replaces recycled playing-card SVGs.
class SupportCardVisual extends StatelessWidget {
  final SupportCard card;
  final double size;

  const SupportCardVisual({
    super.key,
    required this.card,
    this.size = 72,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.35,
      child: CustomPaint(
        painter: SupportCardVisualPainter(card: card),
      ),
    );
  }
}

class SupportCardVisualPainter extends CustomPainter {
  final SupportCard card;

  SupportCardVisualPainter({required this.card});

  @override
  void paint(Canvas canvas, Size size) {
    final typeColor = _typeColor(card.type);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(10),
    );

    canvas.drawRRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            typeColor.withValues(alpha: 0.35),
            const Color(0xFF0D1B2A),
          ],
        ).createShader(rect.outerRect),
    );

    canvas.drawRRect(
      rect,
      Paint()
        ..color = typeColor.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    _drawTypeIcon(canvas, size, typeColor);
    _drawRankBadge(canvas, size, typeColor);

    final titlePainter = TextPainter(
      text: TextSpan(
        text: card.name,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.92),
          fontSize: size.width * 0.11,
          fontWeight: FontWeight.w700,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 2,
    )..layout(maxWidth: size.width - 8);
    titlePainter.paint(
      canvas,
      Offset(
        (size.width - titlePainter.width) / 2,
        size.height * 0.68,
      ),
    );
  }

  void _drawTypeIcon(Canvas canvas, Size size, Color color) {
    final c = Offset(size.width / 2, size.height * 0.34);
    switch (card.type) {
      case CardType.fishing:
        _drawHook(canvas, c, size.width * 0.22, color);
      case CardType.recovery:
        canvas.drawCircle(
          c,
          size.width * 0.16,
          Paint()..color = color.withValues(alpha: 0.35),
        );
        _drawCross(canvas, c, size.width * 0.12, color);
      case CardType.discovery:
        _drawCompass(canvas, c, size.width * 0.18, color);
      case CardType.utility:
        _drawAnchor(canvas, c, size.width * 0.18, color);
    }
  }

  void _drawRankBadge(Canvas canvas, Size size, Color color) {
    final rankLabel = switch (card.rank) {
      CardRank.ace => 'A',
      CardRank.king => 'K',
      CardRank.queen => 'Q',
      CardRank.jack => 'J',
      CardRank.ten => '10',
      CardRank.nine => '9',
      CardRank.eight => '8',
      CardRank.seven => '7',
      CardRank.six => '6',
      CardRank.five => '5',
      CardRank.four => '4',
      CardRank.three => '3',
      CardRank.two => '2',
    };
    final badge = RRect.fromRectAndRadius(
      Rect.fromLTWH(8, 8, 22, 18),
      const Radius.circular(6),
    );
    canvas.drawRRect(badge, Paint()..color = color.withValues(alpha: 0.45));
    final tp = TextPainter(
      text: TextSpan(
        text: rankLabel,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(8 + (22 - tp.width) / 2, 8 + (18 - tp.height) / 2));
  }

  void _drawHook(Canvas canvas, Offset c, double r, Color color) {
    final path = Path()
      ..moveTo(c.dx, c.dy - r)
      ..quadraticBezierTo(c.dx + r, c.dy - r * 0.2, c.dx + r * 0.6, c.dy + r * 0.5)
      ..quadraticBezierTo(c.dx, c.dy + r, c.dx - r * 0.4, c.dy + r * 0.2);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawCross(Canvas canvas, Offset c, double r, Color color) {
    canvas.drawLine(c - Offset(r, 0), c + Offset(r, 0), Paint()..color = color..strokeWidth = 2.5);
    canvas.drawLine(c - Offset(0, r), c + Offset(0, r), Paint()..color = color..strokeWidth = 2.5);
  }

  void _drawCompass(Canvas canvas, Offset c, double r, Color color) {
    canvas.drawCircle(c, r, Paint()..color = color.withValues(alpha: 0.25));
    for (var i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      canvas.drawLine(
        c,
        c + Offset(math.cos(angle) * r, math.sin(angle) * r),
        Paint()..color = color..strokeWidth = 2,
      );
    }
  }

  void _drawAnchor(Canvas canvas, Offset c, double r, Color color) {
    canvas.drawCircle(c + Offset(0, -r * 0.35), r * 0.25, Paint()..color = color);
    canvas.drawLine(
      c + Offset(0, -r * 0.1),
      c + Offset(0, r * 0.7),
      Paint()..color = color..strokeWidth = 2.5,
    );
    final arm = Path()
      ..moveTo(c.dx - r, c.dy + r * 0.35)
      ..quadraticBezierTo(c.dx, c.dy + r * 0.75, c.dx + r, c.dy + r * 0.35);
    canvas.drawPath(
      arm,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  Color _typeColor(CardType type) {
    return switch (type) {
      CardType.fishing => const Color(0xFF42A5F5),
      CardType.recovery => const Color(0xFF66BB6A),
      CardType.discovery => const Color(0xFFFFCA28),
      CardType.utility => const Color(0xFFAB47BC),
    };
  }

  @override
  bool shouldRepaint(covariant SupportCardVisualPainter oldDelegate) {
    return oldDelegate.card.assetName != card.assetName;
  }
}
