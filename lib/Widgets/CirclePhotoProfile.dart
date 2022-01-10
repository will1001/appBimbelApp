import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget circlePhotoProfile(
    BuildContext context, String? photoLink, String _username) {
  if (photoLink == null || photoLink == "") {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150,
        height: 150,
        decoration: new BoxDecoration(
          color: Colors.blue.shade400,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            _username.substring(0, 1),
            style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      ),
    );
  } else {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(80.0),
            child: CachedNetworkImage(
              imageUrl: photoLink,
              imageBuilder: (context, imageProvider) => Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.fill),
                ),
              ),
              placeholder: (context, url) => new CircularProgressIndicator(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
        ],
      ),
    );
  }
}
