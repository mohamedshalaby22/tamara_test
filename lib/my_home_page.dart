import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: TamaraWidget(
              checkout:
                  'https://checkout-sandbox.tamara.co/checkout/b23a6e59-5a31-40c6-88f9-5e343bb827c6?locale=ar_SA&orderId=660f8341-407e-46b8-b1a2-d20e542e45c3&show_item_images=with_item_images_shown',
              success: 'https://extrasoft.net/',
              failed: 'https://beclean.ae/checkout/failure',
              cancel: 'https://beclean.ae/checkout/cancel',
              onPaymentSuccess: () {
                print('success');
              },
              onPaymentCancel: () {
                print('cancel');
              },
              onPaymentFailed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class TamaraWidget extends StatefulWidget {
  const TamaraWidget(
      {Key? key,
      required this.checkout,
      required this.success,
      required this.failed,
      required this.cancel,
      required this.onPaymentSuccess,
      required this.onPaymentCancel,
      required this.onPaymentFailed})
      : super(key: key);
  final String checkout, success, failed, cancel;
  final VoidCallback onPaymentSuccess, onPaymentFailed, onPaymentCancel;

  @override
  State<TamaraWidget> createState() => _TamaraWidgetState();
}

class _TamaraWidgetState extends State<TamaraWidget> {
  InAppWebViewController? webViewController;
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          InAppWebView(
            onProgressChanged: (controller, progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
            shouldOverrideUrlLoading:
                (controller, shouldOverrideUrlLoadingRequest) async {
              var uri = shouldOverrideUrlLoadingRequest.request.url;
              if (uri != null && uri.toString().startsWith(widget.success)) {
                widget.onPaymentSuccess();
                return NavigationActionPolicy.CANCEL;
              } else if (uri != null &&
                  uri.toString().startsWith(widget.failed)) {
                widget.onPaymentFailed();
                return NavigationActionPolicy.CANCEL;
              } else if (uri != null &&
                  uri.toString().startsWith(widget.cancel)) {
                widget.onPaymentCancel();
                return NavigationActionPolicy.CANCEL;
              }
              return NavigationActionPolicy.ALLOW;
            },
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform:
                    InAppWebViewOptions(useShouldOverrideUrlLoading: true),
                ios: IOSInAppWebViewOptions(
                  applePayAPIEnabled: true,
                )),
            initialUrlRequest: URLRequest(
              url: Uri.parse(
                  'https://www.google.com/search?q=extrasoft&oq=extrasoft&aqs=chrome..69i57j46i199i433i465i512j0i67i650l2j46i67i433i650j46i433i512j46i512j0i131i433i512j0i433i512j0i512.4240j0j7&sourceid=chrome&ie=UTF-8'),
            ),
          ),
          progress < 1.0
              ? LinearProgressIndicator(value: progress)
              : Container(),
        ],
      )),
    );
  }
}

/*
   Expanded(
              child: TamaraCheckout(
            'https://checkout-sandbox.tamara.co/checkout/b23a6e59-5a31-40c6-88f9-5e343bb827c6?locale=ar_SA&orderId=660f8341-407e-46b8-b1a2-d20e542e45c3&show_item_images=with_item_images_shown',
            'https://beclean.ae/checkout/success',
            'https://beclean.ae/checkout/failure',
            'https://beclean.ae/checkout/cancel',
            onPaymentSuccess: () {
              print('success');
            },
            onPaymentFailed: () {
              print('failed');
            },
            onPaymentCanceled: () {
              print('canceld');
            },
          )),
 */
