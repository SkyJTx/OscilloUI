import 'dart:async';
import 'dart:isolate';

import 'package:fluent_ui/fluent_ui.dart';

class Task<Arguments, Result> {
  final Key name;
  final FutureOr<Result> Function(Arguments) task;
  final Arguments arguments;

  late final Isolate _isolate;
  late final ReceivePort _mainIsolateReceivePort;
  late final ReceivePort _mainErrorReceivePort;
  late final StreamSubscription _mainIsolateReceivePortSubscription;
  late final StreamSubscription _mainErrorReceivePortSubscription;
  late final Completer<Result> _completer;

  Task({
    required this.name,
    required this.task,
    required this.arguments,
    required Isolate isolate,
    required ReceivePort mainIsolateReceivePort,
    required ReceivePort mainErrorReceivePort,
    required StreamSubscription mainIsolateReceivePortSubscription,
    required StreamSubscription mainErrorReceivePortSubscription,
    required Completer<Result> completer,
  }) {
    _isolate = isolate;
    _mainIsolateReceivePort = mainIsolateReceivePort;
    _mainErrorReceivePort = mainErrorReceivePort;
    _mainIsolateReceivePortSubscription = mainIsolateReceivePortSubscription;
    _mainErrorReceivePortSubscription = mainErrorReceivePortSubscription;
    _completer = completer;
  }

  static Future<Task<Null, Result>> withoutArgs<Result>({
    Key? name,
    required FutureOr<Result> Function() task,
  }) async {
    return withArgs<Null, Result>(
      name: name,
      task: (arguments) => task(),
      arguments: null,
    );
  }

  static Future<Task<Arguments, Result>> withArgs<Arguments, Result>({
    Key? name,
    required FutureOr<Result> Function(Arguments) task,
    required Arguments arguments,
  }) async {
    final completer = Completer<Result>();
    final receivePort = ReceivePort();
    final errorPort = ReceivePort();
    final mainIsolateReceivePortSubscription = receivePort.listen((result) {
      completer.complete(result);
    });
    final mainErrorReceivePortSubscription = errorPort.listen((error) {
      completer.completeError(error);
    });
    final isolate = await Isolate.spawn<List>(
      _taskIsolateEntryPoint<Arguments, Result>,
      [
        receivePort.sendPort,
        task,
        arguments,
      ],
      onError: errorPort.sendPort,
      paused: true,
    );

    return Task<Arguments, Result>(
      name: name ?? UniqueKey(),
      task: task,
      arguments: arguments,
      isolate: isolate,
      mainIsolateReceivePort: receivePort,
      mainErrorReceivePort: errorPort,
      mainIsolateReceivePortSubscription: mainIsolateReceivePortSubscription,
      mainErrorReceivePortSubscription: mainErrorReceivePortSubscription,
      completer: completer,
    );
  }

  static Future<Result> runWithArgs<Arguments, Result>({
    Key? name,
    required FutureOr<Result> Function(Arguments) func,
    required Arguments arguments,
  }) async {
    final task = await withArgs<Arguments, Result>(
      name: name,
      task: func,
      arguments: arguments,
    );
    return task.execute();
  }

  static Future<Result> runWithoutArgs<Result>({
    Key? name,
    required FutureOr<Result> Function() func,
  }) async {
    final task = await withoutArgs<Result>(
      name: name,
      task: func,
    );
    return task.execute();
  }

  static void _taskIsolateEntryPoint<Arguments, Result>(
    List args,
  ) async {
    final sendPort = args[0] as SendPort;
    final func = args[1] as FutureOr<Result> Function(Arguments);
    final arguments = args[2] as Arguments;
    
    final result = await func(arguments);
    sendPort.send(result);
  }

  Future<Result> execute() async {
    _isolate.resume(_isolate.pauseCapability!);

    return _completer.future.whenComplete(() async {
      await Future.wait([
        _mainIsolateReceivePortSubscription.cancel(),
        _mainErrorReceivePortSubscription.cancel(),
      ]);
      _mainIsolateReceivePort.close();
      _mainErrorReceivePort.close();
      _isolate.kill();
    });
  }
}
