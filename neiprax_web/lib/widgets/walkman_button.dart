import 'package:flutter/material.dart';

class WalkmanButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isPressed;
  final Color? color; // 1. Add this line

  const WalkmanButton({
    super.key, 
    required this.icon, 
    required this.onTap, 
    this.isPressed = false,
    this.color, // 2. Add this line
  });

  @override
  Widget build(BuildContext context) {
    // 3. Use the passed color or fallback to Silver
    final buttonColor = color ?? const Color(0xFFC0C0C0); 

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 65,
        height: 45,
        decoration: BoxDecoration(
          color: buttonColor, // 4. Apply the color here
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black26, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              offset: const Offset(-2, -2),
              blurRadius: 2,
            ),
            const BoxShadow(
              color: Colors.black38,
              offset: Offset(2, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }
}