import 'dart:io' show Platform;

import 'package:canteen_app/core/utils/helpers/logger.dart';
import 'package:canteen_app/core/utils/media/icons_strings.dart';
import 'package:canteen_app/core/utils/media/text_strings.dart';
import 'package:canteen_app/core/utils/theme/colors.dart';
import 'package:canteen_app/core/widgets/snackbar/snackbars.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/dialog_bottomsheet/custom_bottom_sheet.dart';

class FilePickerHelper {
  final TextEditingController pdfController;
  final Rx<XFile?> documentFile;
  final Function(bool)? onLoadingChanged;

  FilePickerHelper({
    required this.pdfController,
    required this.documentFile,
    this.onLoadingChanged,
  });

  void showBottomSheetForPicker(
    BuildContext context, {
    bool showGallery = true,
    bool showCamera = true,
    bool showPDF = true,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return CustomBottomSheet(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (showGallery)
                ListTile(
                  leading: const Icon(HIcons.pickPhoto),
                  title: const Text(HTexts.chooseFromGallery),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
              if (showCamera && !Platform.isWindows) ...[
                Divider(color: HColors.grey.withValues(alpha: 0.5)),
                ListTile(
                  leading: const Icon(HIcons.camera),
                  title: const Text(HTexts.takePhoto),
                  onTap: () {
                    _pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
              ],
              if (showPDF) ...[
                Divider(color: HColors.grey.withValues(alpha: 0.5)),
                ListTile(
                  leading: const Icon(HIcons.pdf),
                  title: const Text(HTexts.choosePDF),
                  onTap: () {
                    _pickPDF();
                    Navigator.pop(context);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    HLoggerHelper.info('Attempting to pick image from $source');

    // Check platform
    if (Platform.isAndroid) {
      // Check Android version
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final androidVersion = androidInfo.version.sdkInt;

      // Request appropriate permissions based on Android version
      if (source == ImageSource.camera) {
        PermissionStatus cameraStatus = await Permission.camera.request();
        if (!cameraStatus.isGranted) {
          HSnackbars.showSnackbar(
              type: SnackbarType.warning, message: 'Camera permission denied');
          HLoggerHelper.warning('Camera permission denied');
          openAppSettings();
          return;
        }
      }

      if (source == ImageSource.gallery) {
        if (androidVersion >= 33) {
          // For Android 13 and above
          PermissionStatus photosStatus = await Permission.photos.request();
          if (!photosStatus.isGranted) {
            HSnackbars.showSnackbar(
                type: SnackbarType.warning,
                message: 'Photos permission denied');
            HLoggerHelper.warning('Photos permission denied');
            openAppSettings();
            return;
          }
        } else {
          // For Android 12 and below
          PermissionStatus storageStatus = await Permission.storage.request();
          if (!storageStatus.isGranted) {
            HSnackbars.showSnackbar(
                type: SnackbarType.warning,
                message: 'Storage permission denied');
            HLoggerHelper.warning('Storage permission denied');
            openAppSettings();
            return;
          }
        }
      }
    } else if (Platform.isWindows) {
      if (source == ImageSource.camera) {
        HSnackbars.showSnackbar(
            type: SnackbarType.warning,
            message: 'Camera is not supported on Windows');
        HLoggerHelper.warning('Camera is not supported on Windows');
        return;
      }
    }

    // Updated image picking code
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 90,
      maxHeight: 700,
      maxWidth: 550,
    );

    if (pickedFile != null) {
      // final String fileExtension =
      //     pickedFile.path.split('.').last.toLowerCase();
      // if (source == ImageSource.gallery &&
      //     (fileExtension != 'jpg' &&
      //         fileExtension != 'jpeg' &&
      //         fileExtension != 'png')) {
      //   HLoggerHelper.warning('Invalid file type selected');
      //   HSnackbars.showSnackbar(
      //       type: SnackbarType.warning,
      //       message: 'Please select a valid image file (jpg, jpeg, png)');
      //   return;
      // }

      final int fileSize = await pickedFile.length();

      // Ensure we're using proper path separators and handling paths correctly
      final String normalizedPath = pickedFile.path.replaceAll('\\', '/');
      HLoggerHelper.info(
          'Image picked successfully: $normalizedPath\nImage size: ${(fileSize / 1024).toStringAsFixed(2)} KB');

      // Use basename to get just the filename
      final String fileName = normalizedPath.split('/').last;
      pdfController.text = fileName;
      documentFile.value = XFile(normalizedPath);
    } else {
      HLoggerHelper.warning('No image selected');
    }
  }

  Future<void> _pickPDF() async {
    HLoggerHelper.info('Attempting to pick PDF');

    // Check platform
    if (Platform.isAndroid) {
      PermissionStatus manageStatus =
          await Permission.manageExternalStorage.request();

      if (!manageStatus.isGranted) {
        HLoggerHelper.warning('External storage permission denied');
        await Permission.manageExternalStorage.request();
        return;
      }
    }

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        // Normalize path for cross-platform compatibility
        final String normalizedPath =
            result.files.single.path!.replaceAll('\\', '/');
        final XFile xFile = XFile(normalizedPath);
        pdfController.text = xFile.name;
        documentFile.value = xFile;
        HLoggerHelper.info('PDF picked successfully: $normalizedPath');
      } else {
        HLoggerHelper.warning("No file selected");
      }
    } catch (e) {
      HLoggerHelper.error("Error picking file: $e");
    }
  }
}
