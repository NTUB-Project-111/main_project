import 'package:drw/frontend/utility/front_util.dart';
import 'package:flutter/material.dart';

class WoundOptionButton extends StatefulWidget {
  final String label;
  final String imagePath;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color borderColor; // 若未使用可保留備用
  final Color textColor;

  const WoundOptionButton({
    super.key,
    required this.label,
    required this.imagePath,
    required this.onPressed,
    required this.backgroundColor,
    required this.borderColor,
    this.textColor = Colors.white,
  });

  @override
  State<WoundOptionButton> createState() => _WoundOptionButtonState();
}

class _WoundOptionButtonState extends State<WoundOptionButton> {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.95);
  void _onTapUp(_) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: FrontUtil.textColor.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(widget.imagePath, width: 100),
              const SizedBox(height: 8),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.textColor,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
