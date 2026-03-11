import 'package:flutter/material.dart';
import 'dart:math' as math;

class CassetteWidget extends StatefulWidget {
  final bool isPlaying;
  const CassetteWidget({super.key, required this.isPlaying});

  @override
  State<CassetteWidget> createState() => _CassetteWidgetState();
}

class _CassetteWidgetState extends State<CassetteWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPlaying) _controller.stop(); else _controller.repeat();

    return Container(
      width: 280,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!, width: 4),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildReel(),
              _buildReel(),
            ],
          ),
          Positioned(
            bottom: 10,
            child: Text("NEIPRAX SONY-AI", style: TextStyle(color: Colors.white24, letterSpacing: 2)),
          ),
        ],
      ),
    );
  }

  Widget _buildReel() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Transform.rotate(
        angle: _controller.value * 2 * math.pi,
        child: Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white54, width: 2),
          ),
          child: const Icon(Icons.star, color: Colors.white38, size: 20),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}