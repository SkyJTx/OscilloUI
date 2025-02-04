part of 'error_base.dart';

final class UnknownError extends ErrorBase {
  UnknownError({
    super.error,
    super.stackTrace,
  }) : super(
    code: '0',
    messageConstructor: (context) => AppLocalizations.of(context).unknownError,
  );
}

final class TimeoutError extends ErrorBase {
  TimeoutError({
    super.error,
    super.stackTrace,
  }) : super(
    code: '408',
    messageConstructor: (context) => AppLocalizations.of(context).timeoutError,
  );
}

final class UnsupportedPlatformError extends ErrorBase {
  UnsupportedPlatformError({
    super.error,
    super.stackTrace,
  }) : super(
    code: '405',
    messageConstructor: (context) => AppLocalizations.of(context).unsupportedPlatformError,
  );
}

final class RequestError extends ErrorBase {
  RequestError({
    super.error,
    super.stackTrace,
  }) : super(
    code: '400',
    messageConstructor: (context) => AppLocalizations.of(context).requestError,
  );
}