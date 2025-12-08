import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class ShareScreen extends StatelessWidget {
  final String? sharedText;
  final Uint8List? sharedImage;
  final String? sharedUrl;

  const ShareScreen({
    super.key,
    this.sharedText,
    this.sharedImage,
    this.sharedUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => exit(0),
          child: Text('Close'),
        ),
        middle: const Text('Shared Content'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (sharedText case final value?)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(value, textAlign: TextAlign.center),
              ),
            if (sharedImage case final value?)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.memory(value),
              ),
            if (sharedUrl case final value?)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("URL: $value", textAlign: TextAlign.center),
              ),
          ],
        ),
      ),
    );
  }
}
