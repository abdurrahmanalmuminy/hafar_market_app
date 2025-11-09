import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:uicons/uicons.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final double? size;
  const UserAvatar({super.key, this.imageUrl, this.size});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: CachedNetworkImage(
        width: size ?? 45,
        height: size ?? 45,
        imageUrl: imageUrl ?? "",
        placeholder:
            (context, url) => avatarPlaceholder(),
        errorWidget:
            (context, url, error) => avatarPlaceholder(),
        fit: BoxFit.cover,
      ),
    );
  }
}

Widget avatarPlaceholder() {
  return Icon(UIcons.solidRounded.user, size: 20);
}
