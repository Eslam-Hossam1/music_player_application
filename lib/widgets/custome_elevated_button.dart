import 'package:flutter/material.dart';

class CustomeElevatedButton extends StatelessWidget {
  const CustomeElevatedButton({
    super.key,
    this.onPressed,
  });
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(10),
          minimumSize: WidgetStatePropertyAll(Size(
              MediaQuery.of(context).size.width * 0.9,
              MediaQuery.of(context).size.height * 0.075)),
          backgroundColor:
              WidgetStatePropertyAll(Color.fromARGB(255, 33, 16, 100)),
        ),
        onPressed: onPressed,
        child: Text(
          "Confirm",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
