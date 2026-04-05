import 'package:architecture_learning/core/enums/enums.dart';

class Resource<T> {
  ResourceStatus status;
  T? model;
  String? message;
  int code;

  Resource({
    this.model,
    this.message,
    this.status = ResourceStatus.empty,
    this.code = 0,
  });

  @override
  String toString() {
    return 'Resource{status: $status, model: $model, message: $message, code: $code}';
  }
}
