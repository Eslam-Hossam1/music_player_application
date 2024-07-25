import 'package:flutter/material.dart';

class CustomeTextField extends StatelessWidget {
  const CustomeTextField({
    super.key,
    this.onChanged,
  });
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.only(
        right: 12,
        left: 12,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xff31314f)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
          child: TextField(
            autofocus: true,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(left: 12, top: 12, bottom: 8, right: 8),
              border: UnderlineInputBorder(),
              hintText: 'search a song',
              hintStyle: TextStyle(color: Colors.white.withOpacity(.9)),
              suffixIcon: Icon(
                Icons.search,
                color: Colors.white.withOpacity(.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
