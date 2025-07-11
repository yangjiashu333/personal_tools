import 'package:flutter/material.dart';

class JobBlock extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  const JobBlock({
    super.key,
    required this.text,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange : Colors.orange,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.deepOrange.withValues(alpha: 0.4),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}