import 'package:cached_network_image/cached_network_image.dart';
import 'package:nuPro/library/components/image/io_image_placeholder_widget.dart';

class IOImageNetworkWidget extends CachedNetworkImage {
  IOImageNetworkWidget({
    super.key,
    required super.imageUrl,
    super.fit,
    double placeHolderIconSize = 30,
  }) : super(
          errorWidget: (context, url, error) {
            return IOImagePlaceholderWidget(
              iconSize: placeHolderIconSize,
            );
          },
          placeholder: (context, url) {
            return IOImagePlaceholderWidget(
              iconSize: placeHolderIconSize,
            );
          },
        );
}
