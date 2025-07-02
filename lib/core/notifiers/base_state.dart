import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {
  final Status status;
  final String error;

  const BaseState({
    this.status = Status.initial,
    this.error = '',
  });

  bool get isCancelled => status == Status.cancelled;
  bool get isFailure => status == Status.failure;
  bool get isInitial => status == Status.initial;
  bool get isLoading => status == Status.loading;
  bool get isPartialSuccess => status == Status.partialSuccess;
  bool get isSuccess => status == Status.success;

  @override
  List<Object?> get props => [status, error];

  BaseState copyWith({
    Status? status,
    String? error,
  });
}

enum Status {
  initial,
  loading,
  success,
  failure,
  partialSuccess,
  cancelled,
  error,
}
