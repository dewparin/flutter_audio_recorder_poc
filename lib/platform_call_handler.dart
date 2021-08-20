import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class PlatformCallHandler {
  final MethodChannel platform;

  final _registry = Map<String, VoidCallback>();

  PlatformCallHandler(this.platform);

  void init() {
    platform.setMethodCallHandler(_platformCallHandler);
  }

  Future<dynamic> _platformCallHandler(MethodCall methodCall) async {
    final method = methodCall.method;
    print("PlatformCallHandler # native call method: $method");
    final callback = _registry[method];
    if (callback != null) {
      callback();
    } else {
      print("PlatformCallHandler # no callback registered for method: $method");
    }
  }

  void registerCallHandler(String methodName, VoidCallback callback) {
    _registry[methodName] = callback;
  }
}
