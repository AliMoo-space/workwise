import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Shows a full-screen interactive image viewer.
///
/// Supports both in-memory [bytes] (e.g. a freshly picked avatar) and
/// remote [imageUrl] URLs. For protected URLs pass [httpHeaders] so the
/// Authorization header is included in the request.
Future<void> showProfilePhotoViewer(
  BuildContext context, {
  Uint8List? bytes,
  String? imageUrl,
  // HTTP headers forwarded to Image.network for protected image URLs.
  Map<String, String>? httpHeaders,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black87,
    builder: (context) {
      final screenSize = MediaQuery.sizeOf(context);
      final image = bytes != null
          ? Image.memory(bytes, fit: BoxFit.contain)
          : Image.network(
              imageUrl!,
              headers: httpHeaders,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.broken_image_outlined,
                color: Colors.white,
                size: 64,
              ),
            );

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenSize.width - 48,
                  maxHeight: screenSize.height - 48,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: image,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                tooltip: 'Close image',
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}
