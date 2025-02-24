import 'package:canteen_app/core/utils/helpers/helper_functions.dart';
import 'package:canteen_app/core/utils/media/icons_strings.dart';
import 'package:canteen_app/core/utils/media/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/helpers/file_picker_helper.dart';

class FilePickerWidget extends StatelessWidget {
  final TextEditingController pdfController;
  final Rx<XFile?> documentFile;

  const FilePickerWidget({
    required this.pdfController,
    required this.documentFile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final filePickerHelper = FilePickerHelper(pdfController: pdfController, documentFile: documentFile);

    return Column(
      children: [
        TextFormField(
          controller: pdfController,
          readOnly: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(HIcons.uploadFile),
            labelText: HTexts.uploadDocument,
            hintText: HTexts.uploadDocument,
            suffixIcon: Obx(() => documentFile.value != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        child: Text(HTexts.view, style: Theme.of(context).textTheme.titleSmall),
                        onPressed: () {
                          HHelperFunctions.showpdf(context, pdfFilePath: documentFile.value!.path);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          documentFile.value = null;
                          pdfController.clear();
                        },
                      ),
                    ],
                  )
                : const SizedBox.shrink()),
          ),
          onTap: () => filePickerHelper.showBottomSheetForPicker(context, showCamera: false, showGallery: false),
        ),
      ],
    );
  }
}
