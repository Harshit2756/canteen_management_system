import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:canteen_app/core/utils/helpers/helper_functions.dart';
import 'package:canteen_app/core/utils/media/icons_strings.dart';
import 'package:canteen_app/core/utils/media/text_strings.dart';
import 'package:canteen_app/core/utils/theme/colors.dart';
import 'package:canteen_app/core/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

import '../chips/status.dart';
import '../loading/shimmer/shimmer_container.dart';

class BaseInfoCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final String? pdfUrl;
  final String roleText;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final List<DetailTileData>? detailTiles;
  final Widget? extraWidget;
  final String? statusText;
  final Color? statusBgColor;
  final Color? statusTextColor;

  const BaseInfoCard({
    super.key,
    required this.name,
    this.imageUrl,
    this.pdfUrl,
    required this.roleText,
    this.onEdit,
    this.onDelete,
    this.detailTiles,
    this.extraWidget,
    this.statusText,
    this.statusBgColor,
    this.statusTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(HSizes.buttonPadding12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Profile Image with Share Option
          if (imageUrl != null)
            Center(
              child: InkWell(
                onTap: () {
                  HHelperFunctions.showImagePreview(
                      isFile: false, context, imageUrl!);
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: HColors.primary.withValues(alpha: 0.2),
                        blurRadius: HSizes.sm8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 63,
                    backgroundColor: HColors.white,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: imageUrl ?? '',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const ShimmerContainer.circular(size: 120),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          size: 60,
                          color: HColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          const SizedBox(width: HSizes.buttonPadding12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: HColors.primary,
                    ),
              ),
              const SizedBox(height: HSizes.xs4),
              HStatus(
                text: statusText ?? roleText,
                bgColor: statusBgColor,
                textColor: statusTextColor,
              ),
            ],
          ),
          const SizedBox(height: HSizes.sm8),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (onEdit != null)
                CustomButton(
                  width: context.width * 0.4,
                  onPressed: onEdit,
                  icon: HIcons.edit,
                  text: HTexts.edit,
                ),
              if (onDelete != null) ...[
                CustomButton(
                  onPressed: onDelete,
                  width: context.width * 0.4,
                  icon: HIcons.delete,
                  text: HTexts.delete,
                  borderColor: HColors.error,
                  bgColor: HColors.error,
                ),
              ]
            ],
          ),
          const SizedBox(height: HSizes.spaceBtwItems24),

          // Details Section
          if (detailTiles != null) ...[
            const SizedBox(height: HSizes.sm8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(HSizes.sm8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: List.generate(
                  detailTiles!.length,
                  (index) => _buildDetailTile(
                    context,
                    icon: detailTiles![index].icon,
                    label: detailTiles![index].label,
                    value: detailTiles![index].value,
                    isLast: index == detailTiles!.length - 1,
                  ),
                ),
              ),
            ),
          ],

          // PDF Button
          if (pdfUrl != null) ...[
            const SizedBox(height: HSizes.sm8),
            CustomButton(
              onPressed: () {
                HHelperFunctions.showpdf(context, pdfUrl: pdfUrl!);
              },
              text: 'View PDF',
              margin: const EdgeInsets.symmetric(
                  horizontal: HSizes.buttonPadding12),
            ),
          ],

          // Extra Widget
          if (extraWidget != null) ...[
            const SizedBox(height: HSizes.sm8),
            extraWidget!,
          ],
        ],
      ),
    );
  }

  Widget _buildDetailTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(HSizes.sm8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(HSizes.xs4),
                decoration: BoxDecoration(
                  color: HColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(HSizes.xs4),
                ),
                child:
                    Icon(icon, size: HSizes.iconSm16, color: HColors.primary),
              ),
              const SizedBox(width: HSizes.buttonPadding12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: HSizes.dividerHeight1,
            thickness: HSizes.dividerHeight1,
            color: Colors.grey.shade200,
          ),
      ],
    );
  }
}

class DetailTileData {
  final IconData icon;
  final String label;
  final String value;

  DetailTileData({
    required this.icon,
    required this.label,
    required this.value,
  });
}
