import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

class FullScreenImageViewer extends StatelessWidget {
  static const route = '/image-viewer';

  final String imagePath; // Can be URL or asset path (e.g., "assets/images/photo.jpg" or "https://...")
  final String heroTag;

  const FullScreenImageViewer({
    Key? key,
    required this.imagePath,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Full-screen Image with Zoom & Pan
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Hero(
                tag: heroTag,
                child: InteractiveViewer(
                  panEnabled: true,
                  scaleEnabled: true,
                  minScale: 1.0,
                  maxScale: 5.0,
                  boundaryMargin: EdgeInsets.zero,
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: _buildImageWidget(),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Handle (iOS-style)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 // ⬅️ Don't forget this import!

  Widget _buildImageWidget() {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        errorWidget: (context, url, error) => const Center(
          child: Icon(Icons.broken_image, color: Colors.white, size: 60),
        ),
      );
    } else if (imagePath.startsWith('/')) {
      // Treat as local file path (e.g., from Downloads, Documents, etc.)
      return Image.file(
        File(imagePath), // ✅ Wrap with File()
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.broken_image, color: Colors.white, size: 60),
        ),
      );
    } else {
      // Assume it's an asset path (e.g., "assets/images/photo.jpg")
      return Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.broken_image, color: Colors.white, size: 60),
        ),
      );
    }
  }
}