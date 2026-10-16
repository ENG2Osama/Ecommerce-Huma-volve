import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class SharePlusButtom extends StatelessWidget {
  int productId;
  SharePlusButtom({super.key, required this.productId});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),

      child: IconButton(
        onPressed: () async {
          String Massege =
              "Look this Product:https://assignment2-2b662.web.app/products/$productId";
          await SharePlus.instance.share(ShareParams(text: Massege));
        },
        icon: Icon(Icons.share, size: 16),
      ),
    );
  }
}
