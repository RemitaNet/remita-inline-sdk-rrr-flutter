import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:remitta_flutter_inline/src/core/remitta_webview.dart';
import 'package:remitta_flutter_inline/src/data/environment_enum.dart';
import 'package:remitta_flutter_inline/src/data/payment_request.dart';
import 'package:remitta_flutter_inline/src/utils/constants.dart';
import 'package:remitta_flutter_inline/src/utils/utils.dart';

/// [RemittaInLineView], a [StatefulWidget] for accepting payment.
///
/// When mounted will load an [InAppWebView] widget that opens a Remitta payment modal.
///
/// <br>
/// To receive a [ConsoleMessage] from the payment modal, use one of the following;
/// * [RemittaWebView.listener] method: to listen for [ConsoleMessage] from the [InAppWebView].
/// * [Navigator.pop]: When the widget is popped, it passes [ConsoleMessage] back.
///
class RemittaInLineView extends StatefulWidget implements RemittaWebView {
  final PaymentRequest paymentRequest;
  final StreamController<ConsoleMessage> _streamController = StreamController<ConsoleMessage>();

  RemittaInLineView({required this.paymentRequest, Key? key}) : super(key: key);

  @override
  State<RemittaInLineView> createState() => _RemittaInLineViewState();

  @override
  Stream<ConsoleMessage> listener() => _streamController.stream;
}

class _RemittaInLineViewState extends State<RemittaInLineView> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey _webViewKey = GlobalKey();
  late InAppWebViewController? _webViewController;
  late bool _isWebViewActive;
  late bool _isLoading;

  @override
  void initState() {
    _isWebViewActive = true;
    _isLoading = true;
    super.initState();
  }

  @override
  void dispose() {
    widget._streamController.close();
    _isWebViewActive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _isWebViewActive = true;
    return MaterialApp(
      debugShowCheckedModeBanner: widget.paymentRequest.environment == RemittaEnvironment.demo,
      navigatorKey: navigatorKey,
      home: getContentView(context),
    );
  }

  Widget getContentView(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: WillPopScope(
        onWillPop: () => showAlertDialog(),
        child: Stack(
          children: [
            _isLoading
                ? Container(
                    color: Colors.white,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: RemittaConstants.greenColor,
                      ),
                    ),
                  )
                : Container(),
            getWebView(),
          ],
        ),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      backgroundColor: RemittaConstants.greenColor,
      title: const Text('Remitta Payment'),
      leading: GestureDetector(
        onTap: () {
          showAlertDialog().then((value) {
            if (value == true) {
              onPopScreen(context, ConsoleMessage(message: 'onClose'));
            }
          });
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  InAppWebView getWebView() {
    return InAppWebView(
      key: _webViewKey,
      initialUrlRequest: URLRequest(url: Uri.parse("about:blank")),
      initialOptions: RemittaUtils.inAppBrowserOptions,
      onWebViewCreated: (InAppWebViewController controller) async {
        _webViewController = controller;
        await _webViewController?.loadData(data: RemittaUtils.getHtmlTemplate(widget.paymentRequest));
      },
      onConsoleMessage: (InAppWebViewController controller, ConsoleMessage consoleMessage) {
        _webViewController?.stopLoading();
        widget._streamController.sink.add(consoleMessage);
        onPopScreen(context, consoleMessage);
      },
      onLoadStop: (InAppWebViewController controller, Uri? url) {
        setState(() => _isLoading = false);
      },
    );
  }

  /// Calls [Navigator.pop] to remove widget and send [ConsoleMessage].
  ///
  /// The [ConsoleMessage] is received from remitta payment modal via inAppWebView.
  void onPopScreen(BuildContext context, ConsoleMessage console) {
    if (_isWebViewActive == true) {
      if (console.message.contains('onClose') || console.message.contains('transactionId')) {
        Navigator.pop(context, console);
        _isWebViewActive = false;
      }
    }
  }

  Future<bool> showAlertDialog() async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Do you want to go back?'),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('NO'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('YES'),
            ),
          ],
        );
      },
    );
    return shouldPop ?? false;
  }
}
