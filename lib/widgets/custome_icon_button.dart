import 'package:flutter/material.dart';

class CustomeIconButton extends StatelessWidget {
  const CustomeIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });
  final IconData icon;

  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(.07),
          borderRadius: BorderRadius.circular(16)),
      child: Center(
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 32,
          ),
        ),
      ),
    );
  }
}
