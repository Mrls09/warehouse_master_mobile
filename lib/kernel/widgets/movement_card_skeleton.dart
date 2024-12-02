import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MovementCardSkeleton extends StatelessWidget {
  const MovementCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 120, height: 20, color: Colors.white),
                  Container(width: 80, height: 20, color: Colors.white),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 100, height: 20, color: Colors.white),
                  Container(width: 100, height: 50, color: Colors.white),
                ],
              ),
              const SizedBox(height: 10),
              Container(width: double.infinity, height: 20, color: Colors.white),
              const SizedBox(height: 10),
              Container(width: 150, height: 20, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}