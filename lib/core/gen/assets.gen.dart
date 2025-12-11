// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/Button.png
  AssetGenImage get button => const AssetGenImage('assets/icons/Button.png');

  /// File path: assets/icons/Container.png
  AssetGenImage get container =>
      const AssetGenImage('assets/icons/Container.png');

  /// File path: assets/icons/Google.png
  AssetGenImage get google => const AssetGenImage('assets/icons/Google.png');

  /// File path: assets/icons/Image AI Analysis.png
  AssetGenImage get imageAIAnalysis =>
      const AssetGenImage('assets/icons/Image AI Analysis.png');

  /// File path: assets/icons/Log Out.png
  AssetGenImage get logOut => const AssetGenImage('assets/icons/Log Out.png');

  /// File path: assets/icons/Profile.png
  AssetGenImage get profilePng =>
      const AssetGenImage('assets/icons/Profile.png');

  /// File path: assets/icons/profile.png
  AssetGenImage get profilePng_ =>
      const AssetGenImage('assets/icons/profile.png');

  /// File path: assets/icons/Subscriptions.png
  AssetGenImage get subscriptions =>
      const AssetGenImage('assets/icons/Subscriptions.png');

  /// File path: assets/icons/Time Packages.png
  AssetGenImage get timePackages =>
      const AssetGenImage('assets/icons/Time Packages.png');

  /// File path: assets/icons/apple.png
  AssetGenImage get apple => const AssetGenImage('assets/icons/apple.png');

  /// File path: assets/icons/back_icon.png
  AssetGenImage get backIcon =>
      const AssetGenImage('assets/icons/back_icon.png');

  /// File path: assets/icons/hey julie! which gender describes you_.png
  AssetGenImage get heyJulieWhichGenderDescribesYou => const AssetGenImage(
    'assets/icons/hey julie! which gender describes you_.png',
  );

  /// File path: assets/icons/k.png
  AssetGenImage get k => const AssetGenImage('assets/icons/k.png');

  /// File path: assets/icons/what should nowlii call you_.png
  AssetGenImage get whatShouldNowliiCallYou =>
      const AssetGenImage('assets/icons/what should nowlii call you_.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    button,
    container,
    google,
    imageAIAnalysis,
    logOut,
    profilePng,
    profilePng_,
    subscriptions,
    timePackages,
    apple,
    backIcon,
    heyJulieWhichGenderDescribesYou,
    k,
    whatShouldNowliiCallYou,
  ];
}

class Assets {
  const Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
