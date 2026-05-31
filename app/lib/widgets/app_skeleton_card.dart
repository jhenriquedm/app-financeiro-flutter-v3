import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppSkeletonCard extends StatelessWidget {
  const AppSkeletonCard({
    super.key,
    this.height = 90,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: height,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}