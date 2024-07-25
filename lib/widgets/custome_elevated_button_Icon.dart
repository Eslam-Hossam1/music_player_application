import 'package:flutter/material.dart';

class CustomeElvatedButtonIcon extends StatelessWidget {
  const CustomeElvatedButtonIcon({
    super.key,
    this.onPresed,
    required this.text,
    required this.internalColor,
    required this.backgroundColor,
    required this.iconData,
  });
  final void Function()? onPresed;
  final String text;
  final Color internalColor;
  final Color backgroundColor;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      iconAlignment: IconAlignment.end,
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        )),
        minimumSize: const WidgetStatePropertyAll(Size(150, 50)),
        padding:
            const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12)),
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        elevation: const WidgetStatePropertyAll(4),
      ),
      onPressed: onPresed,
      label: Builder(builder: (context) {
        return Text(
          text,
          style: TextStyle(
              fontSize: 16, color: internalColor, fontWeight: FontWeight.bold),
        );
      }),
      icon: Icon(
        iconData,
        size: 28,
        color: internalColor,
      ),
    );
  }
}
