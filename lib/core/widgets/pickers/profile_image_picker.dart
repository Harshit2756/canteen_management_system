import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_app/core/utils/constants/sizes.dart';
import 'package:canteen_app/core/utils/helpers/file_picker_helper.dart';
import 'package:canteen_app/core/utils/helpers/helper_functions.dart';
import 'package:canteen_app/core/utils/media/icons_strings.dart';
import 'package:canteen_app/core/utils/theme/colors.dart';
import 'package:canteen_app/core/widgets/buttons/custom_button.dart';
import 'package:canteen_app/core/widgets/loading/shimmer/shimmer_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatelessWidget {
  final Rx<XFile?> selectedImage;
  final TextEditingController imageController;
  final String? imageUrl;
  final RxBool isLoading = false.obs;
  final double heigth;
  final BorderRadiusGeometry borderRadius;
  final double width;
  final bool isButton;

  ProfileImagePicker({
    super.key,
    required this.selectedImage,
    required this.imageController,
    this.imageUrl,
    this.heigth = 120,
    this.width = 120,
    this.isButton = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(100)),
  });

  @override
  Widget build(BuildContext context) {
    final filePickerHelper = FilePickerHelper(
      pdfController: imageController,
      documentFile: selectedImage,
      onLoadingChanged: (loading) => isLoading.value = loading,
    );

    return !isButton
        ? Stack(
            children: [
              Obx(() => Container(
                    width: width,
                    height: heigth,
                    decoration: BoxDecoration(
                      color: HColors.grey.withValues(alpha: 0.1),
                      border: Border.all(color: HColors.grey, width: 3),
                      borderRadius: borderRadius,
                    ),
                    child: isLoading.value
                        ? ShimmerContainer.circular(size: heigth)
                        : _buildImageWidget(context),
                  )),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: HColors.primary,
                  ),
                  child: IconButton(
                    onPressed: () => filePickerHelper.showBottomSheetForPicker(
                      context,
                      showPDF: false,
                    ),
                    icon: const Icon(
                      HIcons.edit,
                      color: HColors.white,
                      size: HSizes.iconSm16,
                    ),
                  ),
                ),
              ),
            ],
          )
        : Column(
            children: [
              Obx(() => Container(
                    width: width,
                    height: heigth,
                    decoration: BoxDecoration(
                      color: HColors.grey.withValues(alpha: 0.1),
                      border: Border.all(color: HColors.grey, width: 3),
                      borderRadius: borderRadius,
                    ),
                    child: isLoading.value
                        ? ShimmerContainer.circular(size: heigth)
                        : _buildImageWidget(context),
                  )),
              const SizedBox(height: HSizes.spaceBtwInputFields16),
              CustomButton(
                  text: 'Select Image',
                  onPressed: () {
                    filePickerHelper.showBottomSheetForPicker(
                      context,
                      showPDF: false,
                    );
                  }),
            ],
          );
  }

  Widget _buildImageWidget(BuildContext context) {
    if (selectedImage.value != null) {
      return _buildLocalImageWidget(context);
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      return _buildNetworkImageWidget(context);
    } else {
      return const Icon(
        HIcons.profile,
        size: HSizes.iconProfile50,
        color: HColors.primary,
      );
    }
  }

  Widget _buildLocalImageWidget(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          HHelperFunctions.showImagePreview(context, selectedImage.value!.path),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.file(
          File(selectedImage.value!.path),
          width: width,
          height: heigth,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildNetworkImageWidget(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          HHelperFunctions.showImagePreview(context, imageUrl!, isFile: false),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: width,
          height: heigth,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const ShimmerContainer.circular(size: 120),
          errorWidget: (context, url, error) => const Icon(
            HIcons.profile,
            size: HSizes.iconProfile50,
            color: HColors.black,
          ),
        ),
      ),
    );
  }
}
