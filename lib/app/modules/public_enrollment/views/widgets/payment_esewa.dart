
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EsewaEpay extends StatefulWidget {
  const EsewaEpay({super.key});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<EsewaEpay> {

  late final WebViewController _webViewController;

  String testUrl = "https://uat.esewa.com.np/epay/main";

  _loadHTMLfromAsset() async {
    String file = await rootBundle.loadString("assets/esewa_v2.html");
    _webViewController.loadHtmlString(file);
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
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        "message",
        onMessageReceived: (message) {},
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            String pid = UniqueKey().toString();
            _webViewController.runJavaScript(
                'requestPayment(tAmt = $tAmt, amt = $amt, txAmt = $txAmt, psc = $psc, pdc = $pdc, scd = "$scd", pid = "$pid", su = "$su", fu = "$fu")');
          },
        ),
      );
    _loadHTMLfromAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
      ),
      body: WebViewWidget(
        controller: _webViewController,
      ),
    );
  }
}