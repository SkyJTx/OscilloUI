part of 'error_base.dart';

final class UnknownError extends ErrorBase {
  UnknownError({
    super.error,
    super.stackTrace,
  }) : super(
          code: '0',
          text: 'Unknown Error',
          messageConstructor: (context) => AppLocalizations.of(context).unknownError,
        );

  @override
  Future<void> raise(BuildContext context) {
    return ErrorDialog.show(
      context,
      error: '${messageConstructor(context)}: $code\n${error.toString()}',
    );
  }
}

final class TimeoutError extends ErrorBase {
  TimeoutError({
    super.error,
    super.stackTrace,
  }) : super(
          code: '408',
          text: 'Request Timeout',
          messageConstructor: (context) => AppLocalizations.of(context).timeoutError,
        );
}

final class UnsupportedPlatformError extends ErrorBase {
  UnsupportedPlatformError({
    super.error,
    super.stackTrace,
  }) : super(
          code: '405',
          text: 'Unsupported Platform',
          messageConstructor: (context) => AppLocalizations.of(context).unsupportedPlatformError,
        );
}

final class RequestError extends ErrorBase {
  RequestError({
    super.error,
    super.stackTrace,
  }) : super(
          code: '400',
          text: 'Request Error',
          messageConstructor: (context) => AppLocalizations.of(context).requestError,
        );
}

final class PermissionDeniedError extends ErrorBase {
  PermissionDeniedError({
    super.error,
    super.stackTrace,
  }) : super(
          code: '403',
          text: 'Permission Denied',
          messageConstructor: (context) => AppLocalizations.of(context).permissionDeniedError,
        );
}
