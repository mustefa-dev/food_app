import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double height; final double borderRadius;
  const ShimmerBox({super.key, required this.height, this.borderRadius = 12});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,
      child: Container(height: height, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(borderRadius))),
    );
  }
}
