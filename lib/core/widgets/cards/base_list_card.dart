import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:canteen_app/core/utils/helpers/helper_functions.dart';
import 'package:canteen_app/core/utils/media/icons_strings.dart';
import 'package:canteen_app/core/utils/media/text_strings.dart';
import 'package:canteen_app/core/utils/theme/colors.dart';
import 'package:canteen_app/core/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../loading/shimmer/shimmer_container.dart';

class BaseListCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final String? pdfUrl;
  final String? roleText;
  final VoidCallback? onEdit;
  final VoidCallback? onCardTap;
  final VoidCallback? onDelete;
  final List<DetailTileData>? detailTiles;
  final Widget? extraWidget;
  final Color? statusBgColor;
  final Color? statusTextColor;
  final RxBool isExpanded = false.obs;
  final bool? isSelectable;
  final bool? isSelected;
  final Widget? leading;

  BaseListCard({
    super.key,
    required this.name,
    this.imageUrl,
    this.pdfUrl,
    this.roleText,
    this.onEdit,
    this.onDelete,
    this.detailTiles,
    this.extraWidget,
    this.statusBgColor,
    this.statusTextColor,
    this.onCardTap,
    this.isSelectable,
    this.isSelected,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Card(
          elevation: HSizes.buttonElevation4,
          shadowColor: HColors.primary.withValues(alpha: 0.3),
          margin: const EdgeInsets.symmetric(
              vertical: HSizes.sm8, horizontal: HSizes.md16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(HSizes.cardRadiusMd12),
            side: BorderSide(
              color:
                  isSelected == true ? HColors.primary : Colors.grey.shade200,
              width: isSelected == true ? 2 : 1,
            ),
          ),
          // color: isSelected == true ? HColors.primary.withValues(alpha:0.5) : null,
          child: InkWell(
            onTap: onCardTap ?? toggleExpanded,
            borderRadius: BorderRadius.circular(HSizes.cardRadiusMd12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(HSizes.buttonPadding12),
                  child: Row(
                    children: [
                      if (leading != null) ...[
                        leading!,
                        const SizedBox(width: HSizes.sm8),
                      ],
                      InkWell(
                        onTap: () {
                          if (imageUrl != null) {
                            HHelperFunctions.showImagePreview(
                                isFile: false, context, imageUrl!);
                          }
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
                            radius: 25,
                            backgroundColor: HColors.white,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: imageUrl ?? '',
                                width: 46,
                                height: 46,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const ShimmerContainer.circular(size: 46),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.person,
                                  size: 30,
                                  color: HColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: HSizes.buttonPadding12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: HColors.primary,
                                  ),
                            ),
                            if (roleText != null && roleText!.isNotEmpty) ...[
                              const SizedBox(height: HSizes.xs4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: HSizes.sm8,
                                    vertical: HSizes.xxs2),
                                decoration: BoxDecoration(
                                  color: statusBgColor ??
                                      HColors.primary.withValues(alpha: 0.1),
                                  border: Border.all(
                                    color: statusBgColor ??
                                        HColors.primary.withValues(alpha: 0.5),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      HSizes.cardRadiusMd12),
                                ),
                                child: Text(
                                  roleText ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color:
                                            statusTextColor ?? HColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (onEdit != null || onDelete != null)
                        PopupMenuButton(
                          icon: Icon(HIcons.menu,
                              color: Colors.grey[600], size: HSizes.iconSm16),
                          elevation: HSizes.buttonElevation4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(HSizes.sm8),
                          ),
                          itemBuilder: (context) => [
                            if (onEdit != null)
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    const Icon(HIcons.edit,
                                        size: HSizes.iconSm16,
                                        color: HColors.primary),
                                    const SizedBox(width: HSizes.sm8),
                                    Text(
                                      HTexts.edit,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            if (onDelete != null)
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    const Icon(HIcons.delete,
                                        size: HSizes.iconSm16,
                                        color: HColors.error),
                                    const SizedBox(width: HSizes.sm8),
                                    Text(
                                      HTexts.delete,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit' && onEdit != null) {
                              onEdit!();
                            } else if (value == 'delete' && onDelete != null) {
                              onDelete!();
                            }
                          },
                        ),
                      if (detailTiles != null)
                        IconButton(
                          icon: Icon(
                            isExpanded.value ? HIcons.collapse : HIcons.expande,
                            color: Colors.grey[600],
                          ),
                          onPressed: toggleExpanded,
                        ),
                    ],
                  ),
                ),
                if (extraWidget != null) extraWidget!,
                if (isExpanded.value && detailTiles != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(HSizes.buttonPadding12, 0,
                        HSizes.buttonPadding12, HSizes.buttonPadding12),
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
                if (isExpanded.value &&
                    (pdfUrl != null || imageUrl != null)) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (pdfUrl != null) ...[
                        const Spacer(),
                        CustomButton(
                          width: context.width * 0.4,
                          onPressed: () {
                            HHelperFunctions.showpdf(context, pdfUrl: pdfUrl!);
                          },
                          text: 'View PDF',
                        ),
                      ],
                      if (imageUrl != null) ...[
                        const Spacer(),
                        CustomButton(
                          width: context.width * 0.4,
                          onPressed: () {
                            HHelperFunctions.showImagePreview(
                                isFile: false, context, imageUrl!);
                          },
                          text: 'View Image',
                        ),
                        const Spacer(),
                      ]
                    ],
                  ),
                  const SizedBox(height: HSizes.sm8)
                ]
              ],
            ),
          ),
        ));
  }

  void toggleExpanded() => isExpanded.value = !isExpanded.value;

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
