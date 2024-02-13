import 'package:flutter/services.dart';

class SVGAssetLoader extends AssetBundle {
  final String imagePath;
  SVGAssetLoader({required this.imagePath});
  @override
  Future<ByteData> load(String key) async {
    return await rootBundle.load(imagePath);
  }

  @override
  Future<T> loadStructuredData<T>(String key, Future<T> Function(String value) parser) {
    throw UnimplementedError();
  }
}