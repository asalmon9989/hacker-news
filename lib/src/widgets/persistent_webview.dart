import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PersistentWebView extends StatefulWidget {
  String url;

  PersistentWebView({this.url});

  @override
  _PersistentWebView createState() => _PersistentWebView();
}

class _PersistentWebView extends State<PersistentWebView>
    with AutomaticKeepAliveClientMixin<PersistentWebView> {
  int _index = 0;
  Completer<WebViewController> _controller = Completer<WebViewController>();
  final Set<Factory<OneSequenceGestureRecognizer>> gestures = {
    Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer()),
  };

  @override
  Widget build(BuildContext context) {
    print(widget.url);
    super.build(context);
    return IndexedStack(
      index: _index,
      children: <Widget>[
        Center(
          child: CircularProgressIndicator(),
        ),
        WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          gestureRecognizers: gestures,
          onWebViewCreated: (controller) {
            if (!_controller.isCompleted) {
              _controller.complete(controller);
            }
          },
          gestureNavigationEnabled: true,
          navigationDelegate: (navigation) {
            if (widget.url != navigation.url) {
              launch(navigation.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageFinished: (url) {
            setState(() {
              _index = 1;
            });
          },
          onWebResourceError: (error) => print(error.description),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
