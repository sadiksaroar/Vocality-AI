import 'package:flutter/material.dart';
import 'package:vocality_ai/core/network/api_service.dart';
import 'package:vocality_ai/core/config/app_config.dart';
import 'package:vocality_ai/core/gen/assets.gen.dart';

class BrandWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? color;

  const BrandWidget({
    Key? key,
    this.width,
    this.height,
    this.fontSize,
    this.color,
  }) : super(key: key);

  @override
  State<BrandWidget> createState() => _BrandWidgetState();
}

class _BrandWidgetState extends State<BrandWidget> {
  late final Future<dynamic> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService().getLogo();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          // while loading, show bundled asset
          return _fallback();
        }

        if (snap.hasError || snap.data == null) {
          return _fallback();
        }

        final rawData = snap.data!;

        // Handle both list and map responses
        final data = rawData is List && rawData.isNotEmpty
            ? rawData.first as Map<String, dynamic>
            : rawData as Map<String, dynamic>;

        // look for common fields returned by the API
        final imageUrl =
            (data['image'] ?? data['logo'] ?? data['logo_url']) as String?;
        final name = (data['logo_name'] ?? data['name']) as String?;

        if (imageUrl != null && imageUrl.isNotEmpty) {
          final resolved = imageUrl.startsWith('http')
              ? imageUrl.replaceAll('10.10.7.74:8000', '10.10.7.118:8000')
              : '${AppConfig.httpBase}$imageUrl';
          return Image.network(
            resolved,
            width: widget.width,
            height: widget.height,
            fit: BoxFit.contain,
            errorBuilder: (c, e, s) => _fallback(),
          );
        }

        if (name != null && name.isNotEmpty) {
          return Text(
            name,
            style: TextStyle(
              fontSize: widget.fontSize ?? 32,
              fontWeight: FontWeight.w700,
              color: widget.color ?? Colors.black,
            ),
          );
        }

        return _fallback();
      },
    );
  }

  Widget _fallback() {
    if (widget.width != null || widget.height != null) {
      return Assets.icons.k.image(
        width: widget.width ?? 100.0,
        height: widget.height ?? 100.0,
      );
    }

    return Text(
      'K',
      style: TextStyle(
        fontSize: widget.fontSize ?? 15,
        fontWeight: FontWeight.w700,
        color: widget.color ?? Colors.black,
      ),
    );
  }
}
