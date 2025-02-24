import 'package:canteen_app/core/utils/constants/extension/platform_extensions.dart';
import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:canteen_app/core/utils/media/icons_strings.dart';
import 'package:canteen_app/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class HSearchBar extends StatelessWidget {
  final SearchController searchController;
  final String hintText;
  final Widget? trailing;

  const HSearchBar({
    super.key,
    required this.searchController,
    this.hintText = 'Search',
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      constraints: PlatformHelper.isDesktop ? const BoxConstraints(maxWidth: 400, minHeight: 50) : null,
      backgroundColor: const WidgetStatePropertyAll(HColors.white),
      elevation: const WidgetStatePropertyAll(0.0),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
            // borderRadius: BorderRadius.all(Radius.circular(HSizes.sm8)),
            ),
      ),
      side: WidgetStatePropertyAll(
        BorderSide(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      controller: searchController,
      hintText: hintText,
      leading: const Padding(padding: EdgeInsets.all(HSizes.sm8), child: Icon(HIcons.search, color: Colors.black, size: HSizes.lg24)),
      trailing: [
        IconButton(
          onPressed: () => searchController.clear(),
          icon: const Icon(HIcons.close, color: Colors.black, size: HSizes.lg24),
        ),
        trailing ?? const SizedBox(),
      ],
    );
  }
}
