import 'dart:developer';

import 'package:remitta_flutter_inline/src/core/remitta_env.dart';
import 'package:remitta_flutter_inline/src/utils/constants.dart';

/// An enum for setting the active environment
/// for which payment/transaction should be processed.
///
enum RemittaEnvironment implements RemittaEnv {
  demo,
  production;

  /// Get base environment url prefix from [RemittaEnvironment]
  @override
  String getUrl() {
    switch (this) {
      case RemittaEnvironment.demo:
        return RemittaConstants.demoUrlPrefix;
      case RemittaEnvironment.production:
        return RemittaConstants.productionUrlPrefix;
      default:
        log('undefined enum value');
        return '';
    }
  }
}
