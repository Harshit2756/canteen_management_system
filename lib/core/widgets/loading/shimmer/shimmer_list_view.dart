import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import 'shimmer_container.dart';
import 'shimmer_list_item.dart';

class ShimmerListView extends StatelessWidget {
  final bool showFilterChips;

  const ShimmerListView({
    super.key,
    this.showFilterChips = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Shimmer effect for the search bar
        const ShimmerContainer.rectangular(
          width: double.infinity,
          height: HSizes.appBarHeight56,
          margin: EdgeInsets.only(
            left: HSizes.md16,
            right: HSizes.md16,
            bottom: HSizes.sm8,
            top: HSizes.xl32, // Match the visitor list padding
          ),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),

        // Shimmer effect for filter chips
        if (showFilterChips)
          Padding(
            padding: const EdgeInsets.only(
              left: HSizes.md16,
              right: HSizes.md16,
              bottom: HSizes.sm8,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      right: index != 3 ? HSizes.sm8 : 0,
                    ),
                    child: const ShimmerContainer.rectangular(
                      width: 85,
                      height: 32,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Shimmer effect for list items
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          padding: const EdgeInsets.all(HSizes.md16),
          separatorBuilder: (_, __) => const SizedBox(height: HSizes.sm8),
          itemBuilder: (_, __) => const ShimmerListItem(),
        ),
      ],
    );
  }
}
