import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_app/core/utils/constants/extension/formatter.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../widgets/documents/pdf_viewer_screen.dart';
import '../../widgets/loading/shimmer/shimmer_container.dart';
import '../../widgets/snackbar/snackbars.dart';
import '../constants/enums/enums.dart';
import '../constants/sizes.dart';
import '../media/icons_strings.dart';
import '../theme/colors.dart';

class HHelperFunctions {
  static Future<void> exportToExcel({
    required String sheetName,
    required List<String> headers,
    required List<List<String>> rows,
    required RxBool isLoading,
  }) async {
    isLoading.value = true;
    try {
      var excel = Excel.createExcel();
      excel.rename('Sheet1', sheetName);

      Sheet sheetObject = excel[sheetName];

      // Add the report headers
      sheetObject
          .appendRow(headers.map((header) => TextCellValue(header)).toList());

      // Add data rows
      for (var row in rows) {
        sheetObject.appendRow(row.map((cell) => TextCellValue(cell)).toList());
      }

      var fileBytes = excel.save();

      if (fileBytes != null) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/$sheetName.xlsx';
        File(path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);

        HSnackbars.showSnackbar(
            type: SnackbarType.success, message: 'File saved at $path');

        OpenFile.open(path);
      }
    } catch (e) {
      HSnackbars.showSnackbar(
          type: SnackbarType.error, message: 'Failed to export data');
    } finally {
      isLoading.value = false;
    }
  }

  // List<T> transformList<T>(
  //     List data, T Function(Map<String, dynamic>) fromJson) {
  //   return data.map((item) => fromJson(item as Map<String, dynamic>)).toList();
  // }

  
  static Color getStatusBgColor(String status) {
    final visitorStatus = status.toStatusEnum();
    switch (visitorStatus) {
      case Status.PENDING:
        return HColors.pendingBgColor;
      case Status.APPROVED:
        return HColors.approvedBgColor;
      case Status.REJECTED:
        return HColors.rejectedBgColor;
      default:
        return Colors.grey.shade100;
    }
  }

  static Color getStatusColor(String status) {
    final visitorStatus = status.toStatusEnum();
    switch (visitorStatus) {
      case Status.PENDING:
        return HColors.pendingColor;
      case Status.APPROVED:
        return HColors.approvedColor;
      case Status.REJECTED:
        return HColors.rejectedColor;
      default:
        return Colors.grey;
    }
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static void showImagePreview(BuildContext context, String imagePath,
      {bool isFile = true}) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.center,
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    maxHeight: MediaQuery.of(context).size.height * 0.9,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(HSizes.cardRadiusLg16),
                    child: isFile
                        ? Image.file(File(imagePath), fit: BoxFit.contain)
                        : CachedNetworkImage(
                            imageUrl: imagePath,
                            fit: BoxFit.contain,
                            placeholder: (context, url) =>
                                const ShimmerContainer.rectangular(
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            errorWidget: (context, url, error) => const Center(
                              child: Icon(Icons.error, color: HColors.error),
                            ),
                          ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                    color: HColors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(HIcons.close, color: HColors.white),
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Close preview',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showpdf(BuildContext context, {String? pdfUrl, pdfFilePath}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(
          pdfFilePath: pdfFilePath,
          pdfUrl: pdfUrl,
          title: 'Document Preview',
        ),
      ),
    );
  }
}
