import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oscillo_ui/component/errors/error_base.dart';

class ErrorCubit extends Cubit<ErrorBase?> {
  ErrorCubit._internal(super.state);

  static ErrorCubit? _instance;

  factory ErrorCubit({
    ErrorBase? initialState,
  }) {
    _instance ??= ErrorCubit._internal(initialState);
    return _instance!;
  }

  void handlingError({
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (error is ErrorBase) {
      setError(error);
    } else {
      setError(UnknownError(
        error: error,
        stackTrace: stackTrace,
      ));
    }
  }

  T? calls<T>(T Function() callback) {
    try {
      return callback();
    } on ErrorBase catch (e) {
      setError(e);
    } catch (e, stackTrace) {
      handlingError(
        error: e,
        stackTrace: stackTrace,
      );
    }

    return null;
  }

  void setError(ErrorBase error) {
    emit(error);
  }

  void clearError() {
    emit(null);
  }
}
