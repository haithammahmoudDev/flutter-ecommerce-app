import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:fit_store/data/services/notifications/lib/core/navigation/navigation_service.dart';
import 'package:fit_store/features/home/domain/entities/product_entity.dart';
import 'package:fit_store/routes/routes.dart';
import 'package:flutter/material.dart';

class DeepLinkHandler {
  DeepLinkHandler({required this.fetchProductById});

  /// Loads a product by its id. Return null if it does not exist.
  final Future<ProductEntity?> Function(String id) fetchProductById;

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  Future<void> init() async {
    // App was closed and opened from a link
    final initial = await _appLinks.getInitialLink();
    if (initial != null) {
      await _handle(initial);
    }

    // App is running and a link is tapped
    _sub = _appLinks.uriLinkStream.listen(_handle);
  }

  Future<void> _handle(Uri uri) async {
    debugPrint('DeepLink received: $uri');

    // Expected: https://fit-store.vercel.app/product/<id>
    if (uri.pathSegments.length == 2 && uri.pathSegments[0] == 'product') {
      final id = uri.pathSegments[1];

      try {
        final product = await fetchProductById(id);
        if (product == null) {
          debugPrint('DeepLink: product $id not found');
          return;
        }

        NavigationService.pushNamed(
          TRoutes.productDetails,
          arguments: product,
        );
      } catch (e) {
        debugPrint('DeepLink error: $e');
      }
    }
  }

  void dispose() => _sub?.cancel();
}