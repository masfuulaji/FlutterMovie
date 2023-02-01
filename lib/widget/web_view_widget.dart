import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContentWidget extends StatefulWidget {
  const WebViewContentWidget(
      {super.key, required this.url, required this.title});

  final String url;
  final String title;
  @override
  State<WebViewContentWidget> createState() => _WebViewContentWidgetState();
}

class _WebViewContentWidgetState extends State<WebViewContentWidget> {
  WebViewController? _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    if (widget.url.isNotEmpty) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
              onProgress: (int progress) {
                setState(() {
                  _progress = progress;
                });
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {}),
        )
        ..loadRequest(
          Uri.parse(widget.url),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
        ),
        body: Builder(builder: (context) {
          if (widget.url.isEmpty) {
            return const Center(
              child: Text('Homepage is empty'),
            );
          }
          return Stack(
            children: [
              WebViewWidget(controller: _controller!),
              _progress < 100
                  ? const Positioned.fill(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox()
            ],
          );
        }));
  }
}
