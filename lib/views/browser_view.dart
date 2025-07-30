import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserView extends StatefulWidget {
  const BrowserView({Key? key}) : super(key: key);

  @override
  _BrowserViewState createState() => _BrowserViewState();
}

class _BrowserViewState extends State<BrowserView> {
  late final WebViewController _controller;
  late final String url;
  bool _isControllerInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isControllerInit) {
      url = ModalRoute.of(context)!.settings.arguments as String;
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(url));
      _isControllerInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          )
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}

