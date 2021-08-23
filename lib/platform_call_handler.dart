import 'package:flutter/services.dart';

typedef OptionalValueChanged<T> = void Function(Object? value);

class PlatformCallHandler {
  final MethodChannel platform;

  final _registry = Map<String, OptionalValueChanged>();

  PlatformCallHandler(this.platform);

  void init() {
    platform.setMethodCallHandler(_platformCallHandler);
  }

  Future<dynamic> _platformCallHandler(MethodCall methodCall) async {
    final method = methodCall.method;
    print("PlatformCallHandler # native call method: $method");
    final callback = _registry[method];
    if (callback != null) {
      callback(methodCall.arguments);
    } else {
      print("PlatformCallHandler # no callback registered for method: $method");
    }
  }

  void registerCallHandler(String methodName, OptionalValueChanged callback) {
    _registry[methodName] = callback;
  }
}
