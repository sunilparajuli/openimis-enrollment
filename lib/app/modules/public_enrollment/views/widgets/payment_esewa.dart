import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EsewaEpay extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<EsewaEpay> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  late WebViewController _webViewController;

  String testUrl = "https://uat.esewa.com.np/epay/main";

  _loadHTMLfromAsset() async {
    String file = await rootBundle.loadString("assets/esewa_v2.html");
    _webViewController.loadUrl(Uri.dataFromString(file,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  // ePay deatils
  double tAmt = 3500;
  double amt = 0;
  double txAmt = 0;
  double psc = 0;
  double pdc = 0;
  String scd = "EPAYTEST";
  String su = "https://tinker.com.np";
  String fu = "https://tinker.com.np";

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox.shrink(),
      ),
      body: WebView(
        initialUrl: "about:blank",
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: Set.from([
          JavascriptChannel(
            name: "message",
            onMessageReceived: (message) {},
          ),
        ]),
        onPageFinished: (data) {
          setState(() {
            String pid = UniqueKey().toString();
            _webViewController.evaluateJavascript(
                'requestPayment(tAmt = $tAmt, amt = $amt, txAmt = $txAmt, psc = $psc, pdc = $pdc, scd = "$scd", pid = "$pid", su = "$su", fu = "$fu")');
          });
        },
        onWebViewCreated: (webViewController) {
          // _controller.complete(webViewController);
          _webViewController = webViewController;
          _loadHTMLfromAsset();
        },
      ),
    );
  }
}