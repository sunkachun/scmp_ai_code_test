import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StaffListShimmer extends StatelessWidget {
  const StaffListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          final isSolid = index % 6 < 3;
          return ListTile(
            leading: Container(
              width: 56,
              height: 56,
              decoration: isSolid
                  ? const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    )
                  : BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
            ),
            title: Container(
              width: 180,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            subtitle: Container(
              width: 120,
              height: 12,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        },
      ),
    );
  }
}
