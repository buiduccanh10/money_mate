import 'package:flutter/material.dart';

class GradientAnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData? icon;
  final double width;
  final Gradient? gradient;

  const GradientAnimatedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.width = 130,
    this.gradient,
  });

  @override
  State<GradientAnimatedButton> createState() => _GradientAnimatedButtonState();
}

class _GradientAnimatedButtonState extends State<GradientAnimatedButton> {
  double scale = 1.0;

  void _handlePress() {
    setState(() => scale = 1.1);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) setState(() => scale = 1.0);
      widget.onPressed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: widget.width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient:
              widget.gradient ??
              const LinearGradient(
                colors: [
                  Color.fromARGB(255, 63, 148, 66),
                  Color.fromARGB(255, 77, 183, 80),
                  Color.fromARGB(255, 89, 206, 93),
                ],
              ),
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: _handlePress,
          label: Row(
            children: [
              if (widget.icon != null)
                Icon(widget.icon!, size: 28, color: Colors.white),
              const SizedBox(width: 5),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
