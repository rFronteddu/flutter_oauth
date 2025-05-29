import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String assetPath;
  final void Function()? onTap;

  const SquareTile({super.key, required this.assetPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: Image.asset(assetPath, height: 40),
      ),
    );
  }
}
