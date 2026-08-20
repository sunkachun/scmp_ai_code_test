import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.avatarUrl,
    required this.index,
  });

  final String avatarUrl;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isSolid = index % 6 < 3;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: isSolid
              ? const BoxDecoration(color: Colors.black, shape: BoxShape.circle)
              : BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
        ),
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: avatarUrl,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => Icon(
              Icons.person,
              size: 32,
              color: isSolid ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
