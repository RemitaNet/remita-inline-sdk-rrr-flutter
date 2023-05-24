import 'dart:developer';

import 'package:remita_flutter_inline/src/core/remita_env.dart';
import 'package:remita_flutter_inline/src/utils/constants.dart';

/// An enum for setting the active environment
/// for which payment/transaction should be processed.
///
enum RemitaEnvironment implements RemitaEnv {
  demo,
  production;

  /// Get base environment url prefix from [RemitaEnvironment]
  @override
  String getUrl() {
    switch (this) {
      case RemitaEnvironment.demo:
        return RemitaConstants.demoUrlPrefix;
      case RemitaEnvironment.production:
        return RemitaConstants.productionUrlPrefix;
      default:
        log('undefined enum value');
        return '';
    }
  }
}
