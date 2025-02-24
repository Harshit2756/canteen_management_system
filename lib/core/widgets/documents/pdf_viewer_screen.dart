import 'package:canteen_app/core/widgets/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../../utils/theme/colors.dart';

class PDFViewerScreen extends StatelessWidget {
  final String? pdfUrl;
  final String? pdfFilePath;
  final String title;

  const PDFViewerScreen({
    super.key,
    this.pdfUrl,
    this.pdfFilePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.withText(title: title),
      body: _buildPDFView(),
    );
  }

  Widget _buildErrorWidget(dynamic error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading PDF:\n${error.toString()}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(double progress) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            value: progress / 100,
            valueColor: const AlwaysStoppedAnimation<Color>(HColors.primary),
          ),
          const SizedBox(height: 16),
          Text('Loading PDF: ${progress.toStringAsFixed(1)}%'),
        ],
      ),
    );
  }

  Widget _buildPageErrorWidget(int page, dynamic error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.orange,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading page $page:\n${error.toString()}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPDFView() {
    final PDF pdfWidget = PDF(
      swipeHorizontal: false,
      enableSwipe: true,
      autoSpacing: true,
      pageFling: true,
      defaultPage: 0,
      preventLinkNavigation: false,
      onError: (error) => _buildErrorWidget(error),
      onPageError: (page, error) => _buildPageErrorWidget(page!, error),
    );

    if (pdfUrl != null) {
      return pdfWidget.cachedFromUrl(
        pdfUrl!,
        placeholder: (progress) => _buildLoadingWidget(progress),
        errorWidget: (error) => _buildErrorWidget(error),
      );
    } else if (pdfFilePath != null) {
      return pdfWidget.fromPath(pdfFilePath!);
    }

    return const Center(
      child: Text('No PDF source provided'),
    );
  }
}
