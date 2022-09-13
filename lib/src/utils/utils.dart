import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:remitta_flutter_inline/src/data/environment_enum.dart';
import 'package:remitta_flutter_inline/src/data/payment_request.dart';
import 'package:remitta_flutter_inline/src/utils/constants.dart';

class RemittaUtils {
  static String getHtmlTemplate(PaymentRequest paymentRequest) {
    var url = paymentRequest.environment.getUrl();
    var publicKey = paymentRequest.key;
    var rrr = paymentRequest.rrr;
    String html = ''' 
      <!DOCTYPE html> <html lang="en"> <header><meta name="viewport" content="initial-scale=1.0"/></header> <body onload="makePayment()"> <script>function makePayment(){var paymentEngine=RmPaymentEngine.init({key:'$publicKey', processRrr: true, extendedData:{customFields: [{name:"rrr", value:'$rrr'}]}, onSuccess: function (response){console.log(JSON.stringify(response));}, onError: function (response){console.log(JSON.stringify(response));}, onClose: function (){console.log("onClose");},}); paymentEngine.openIframe();}</script> <script type="text/javascript" src="$url/payment/v1/remita-pay-inline.bundle.js"> </script> </body> </html>
    ''';
    return html;
  }

  static InAppWebViewGroupOptions inAppBrowserOptions = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
      contentBlockers: [],
      javaScriptCanOpenWindowsAutomatically: true,
      javaScriptEnabled: true,
      preferredContentMode: UserPreferredContentMode.RECOMMENDED,
      supportZoom: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      allowContentAccess: true,
      allowFileAccess: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  static String getUrl(RemittaEnvironment remittaEnv) {
    return remittaEnv.getUrl();
  }

  static bool isValidPaymentRequest(PaymentRequest request) {
    if (request.key.isEmpty) {
      throw Exception(RemittaConstants.exceptionRRR);
    }
    if (request.rrr.isEmpty) {
      throw Exception(RemittaConstants.exceptionRRR);
    }
    return true;
  }
}
