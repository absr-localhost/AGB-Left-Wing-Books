import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data_buku.dart';
import 'layar_beranda.dart';
import 'tema.dart';

/// Animasi pembuka: lingkaran memancar, logo tersingkap dari kiri ke kanan,
/// lalu nama aplikasi muncul.
class LayarPembuka extends StatefulWidget {
  const LayarPembuka({super.key});

  @override
  State<LayarPembuka> createState() => _LayarPembukaState();
}

class _LayarPembukaState extends State<LayarPembuka>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _cincin;
  late final Animation<double> _logo;
  late final Animation<double> _judul;
  late final Animation<double> _tagline;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _cincin = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    );
    _logo = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.10, 0.55, curve: Curves.easeInOutCubic),
    );
    _judul = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.50, 0.78, curve: Curves.easeOutCubic),
    );
    _tagline = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.62, 0.90, curve: Curves.easeOut),
    );
    _c.addStatusListener((status) {
      if (status == AnimationStatus.completed) _lanjut();
    });
    _c.forward();
  }

  void _lanjut() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LayarBeranda(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Warna.biru,
        body: AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Warna.biruTua, Warna.biru],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: _CincinPelukis(_cincin.value)),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.scale(
                          scale: 0.92 + 0.08 * _logo.value,
                          child: ClipRect(
                            clipper: _Penyingkap(_logo.value),
                            child: Image.asset(
                              'assets/logo/logo_putih.png',
                              width: 190,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Opacity(
                          opacity: _judul.value,
                          child: Transform.translate(
                            offset: Offset(0, 14 * (1 - _judul.value)),
                            child: Text(
                              'AGB Left-Wing Books',
                              style: gayaJudul(
                                25,
                                warna: Warna.putih,
                                jarak: 0.3,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Opacity(
                          opacity: _tagline.value,
                          child: Text(
                            'Perpustakaan pemikiran kiri',
                            style: gayaIsi(
                              14,
                              warna: const Color.fromRGBO(255, 255, 255, 0.78),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 36,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 96,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: _c.value,
                              minHeight: 3,
                              backgroundColor:
                                  const Color.fromRGBO(255, 255, 255, 0.18),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Warna.putih,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Versi $versiAplikasi',
                          style: gayaLabel(
                            12,
                            warna: const Color.fromRGBO(255, 255, 255, 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Penyingkap extends CustomClipper<Rect> {
  final double t;
  _Penyingkap(this.t);

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * t, size.height);

  @override
  bool shouldReclip(_Penyingkap oldClipper) => oldClipper.t != t;
}

class _CincinPelukis extends CustomPainter {
  final double t;
  _CincinPelukis(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final pusat = Offset(size.width / 2, size.height * 0.46);
    for (var i = 0; i < 3; i++) {
      final u = (t - i * 0.14).clamp(0.0, 1.0);
      if (u <= 0) continue;
      final jari = 50 + u * size.shortestSide * 0.75;
      final cat = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = Color.fromRGBO(255, 255, 255, (1 - u) * 0.22);
      canvas.drawCircle(pusat, jari, cat);
    }
  }

  @override
  bool shouldRepaint(_CincinPelukis oldDelegate) => oldDelegate.t != t;
}
