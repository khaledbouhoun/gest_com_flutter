import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController();
  bool _hasScanned = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    // Calculate a scan window centered on the screen
    final double scanAreaSize = 270.0;
    final Rect scanWindow = Rect.fromCenter(
      center: Offset(screenSize.width / 2, screenSize.height / 2),
      width: scanAreaSize,
      height: scanAreaSize,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            scanWindow: scanWindow,
            onDetect: (capture) {
              if (_hasScanned) return;
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? rawValue = barcode.rawValue;
                if (rawValue != null && rawValue.isNotEmpty) {
                  _hasScanned = true;
                  Navigator.pop(context, rawValue);
                  break;
                }
              }
            },
          ),
          // Custom scanner overlay with pulse animation
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: ScannerOverlayPainter(
                  scanWindow: scanWindow,
                  borderRadius: 20.0,
                  borderWidth: 3.5,
                  borderColor: Colors.cyanAccent,
                  pulseValue: _pulseController.value,
                ),
              );
            },
          ),
          // Interactive animated laser line with trail
          ScanningLaserLine(
            scanWindow: scanWindow,
            color: Colors.cyanAccent,
          ),
          // Header / controls bar (Frosted Glassmorphism look)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GlassButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: const Text(
                        'Scanner un code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    ValueListenableBuilder<MobileScannerState>(
                      valueListenable: controller,
                      builder: (context, state, child) {
                        final isTorchOn = state.torchState == TorchState.on;
                        return GlassButton(
                          onPressed: () => controller.toggleTorch(),
                          child: Icon(
                            isTorchOn ? Icons.flash_on : Icons.flash_off,
                            color: isTorchOn ? Colors.yellowAccent : Colors.white,
                            size: 20,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    GlassButton(
                      onPressed: () => controller.switchCamera(),
                      child: const Icon(Icons.flip_camera_android, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Instruction label at the bottom (Modern layout)
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.qr_code_scanner, color: Colors.cyanAccent, size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Placez le code dans le cadre',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const GlassButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
              width: 1.0,
            ),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: child,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Rect scanWindow;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final double pulseValue;

  ScannerOverlayPainter({
    required this.scanWindow,
    this.borderRadius = 12.0,
    this.borderWidth = 4.0,
    this.borderColor = Colors.blue,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw semi-transparent background
    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutoutPath = Path()..addRRect(RRect.fromRectAndRadius(scanWindow, Radius.circular(borderRadius)));

    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.68)
      ..style = PaintingStyle.fill;

    final finalPath = Path.combine(PathOperation.difference, backgroundPath, cutoutPath);
    canvas.drawPath(finalPath, backgroundPaint);

    // 2. Draw the corner brackets with pulsing opacity/glow
    final borderPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.4 + 0.6 * pulseValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    final double l = 28.0; // corner line length
    final double r = borderRadius;

    final rect = scanWindow;
    final path = Path()
      // Top-Left corner
      ..moveTo(rect.left, rect.top + l)
      ..lineTo(rect.left, rect.top + r)
      ..quadraticBezierTo(rect.left, rect.top, rect.left + r, rect.top)
      ..lineTo(rect.left + l, rect.top)
      // Top-Right corner
      ..moveTo(rect.right - l, rect.top)
      ..lineTo(rect.right - r, rect.top)
      ..quadraticBezierTo(rect.right, rect.top, rect.right, rect.top + r)
      ..lineTo(rect.right, rect.top + l)
      // Bottom-Right corner
      ..moveTo(rect.right, rect.bottom - l)
      ..lineTo(rect.right, rect.bottom - r)
      ..quadraticBezierTo(rect.right, rect.bottom, rect.right - r, rect.bottom)
      ..lineTo(rect.right - l, rect.bottom)
      // Bottom-Left corner
      ..moveTo(rect.left + l, rect.bottom)
      ..lineTo(rect.left + r, rect.bottom)
      ..quadraticBezierTo(rect.left, rect.bottom, rect.left, rect.bottom - r)
      ..lineTo(rect.left, rect.bottom - l);

    // Draw neon glowing shadow under the border
    final glowPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.25 * pulseValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth + 4.0
      ..strokeCap = StrokeCap.round;
    if (pulseValue > 0.1) {
      glowPaint.maskFilter = MaskFilter.blur(BlurStyle.normal, 5.0 * pulseValue);
      canvas.drawPath(path, glowPaint);
    }

    canvas.drawPath(path, borderPaint);

    // 3. Draw a very subtle thin guide rectangle inside the window
    final guidePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(scanWindow, Radius.circular(borderRadius)),
      guidePaint,
    );
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) {
    return oldDelegate.scanWindow != scanWindow || oldDelegate.borderColor != borderColor || oldDelegate.pulseValue != pulseValue;
  }
}

class ScanningLaserLine extends StatefulWidget {
  final Rect scanWindow;
  final Color color;

  const ScanningLaserLine({
    super.key,
    required this.scanWindow,
    this.color = Colors.blueAccent,
  });

  @override
  State<ScanningLaserLine> createState() => _ScanningLaserLineState();
}

class _ScanningLaserLineState extends State<ScanningLaserLine> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double top = widget.scanWindow.top + (widget.scanWindow.height * _controller.value);
        return Positioned(
          left: widget.scanWindow.left + 4,
          top: top - 18,
          width: widget.scanWindow.width - 8,
          height: 20,
          child: CustomPaint(
            painter: LaserPainter(
              color: widget.color,
              isMovingDown: _controller.status == AnimationStatus.forward,
            ),
          ),
        );
      },
    );
  }
}

class LaserPainter extends CustomPainter {
  final Color color;
  final bool isMovingDown;

  LaserPainter({required this.color, required this.isMovingDown});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: isMovingDown ? Alignment.topCenter : Alignment.bottomCenter,
        end: isMovingDown ? Alignment.bottomCenter : Alignment.topCenter,
        colors: [
          color.withValues(alpha: 0.0),
          color.withValues(alpha: 0.2),
          color.withValues(alpha: 0.85),
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw trail
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height - 2), paint);

    // Draw bright laser line
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 2.0);

    final double lineY = isMovingDown ? size.height - 1 : 1;
    canvas.drawLine(Offset(0, lineY), Offset(size.width, lineY), linePaint);
  }

  @override
  bool shouldRepaint(covariant LaserPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isMovingDown != isMovingDown;
  }
}
