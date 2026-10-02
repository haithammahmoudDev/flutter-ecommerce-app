import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Opens the PayPal approval page inside the app.
/// Pops with `true` when the buyer approved, `false` when cancelled/closed.
class PayPalWebViewScreen extends StatefulWidget {
  const PayPalWebViewScreen({
    super.key,
    required this.approvalUrl,
    this.returnUrl = 'https://example.com/return',
    this.cancelUrl = 'https://example.com/cancel',
  });

  final String approvalUrl;

  /// Must match return_url / cancel_url used in the create-paypal-order function.
  final String returnUrl;
  final String cancelUrl;

  @override
  State<PayPalWebViewScreen> createState() => _PayPalWebViewScreenState();
}

class _PayPalWebViewScreenState extends State<PayPalWebViewScreen> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _finished = false;

  void _finish(bool approved) {
    if (_finished || !mounted) return;
    _finished = true;
    Navigator.of(context).pop(approved);
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _loading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onNavigationRequest: (request) {
            if (request.url.startsWith(widget.returnUrl)) {
              _finish(true);
              return NavigationDecision.prevent;
            }
            if (request.url.startsWith(widget.cancelUrl)) {
              _finish(false);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.approvalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayPal'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _finish(false),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}