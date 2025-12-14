import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GaguWebPage extends StatefulWidget {
  const GaguWebPage({super.key});

  @override
  State<GaguWebPage> createState() => _GaguWebPageState();
}

class _GaguWebPageState extends State<GaguWebPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() => _isLoading = true),
          onPageFinished: (url) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse('https://gaguhk.com/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GAGU HK'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}