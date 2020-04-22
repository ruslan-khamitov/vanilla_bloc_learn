import 'dart:async';

import 'package:bloc_scratch/counter_event.dart';

class CounterBloc {
  int _counter = 0;

  final _counterStateController = StreamController<int>();
  StreamSink<int> get _inCounter => _counterStateController.sink;
  /// Для состояния, публичный стрим только выводящий данные
  Stream<int> get counter => _counterStateController.stream;

  final _counterEventController = StreamController<CounterEvent>();
  // Для действий, публичный стрим только принимающий данные
  Sink<CounterEvent> get counterEventSink => _counterEventController.sink;

  CounterBloc() {
    // каждое полученное через counterEventSink обрабатываем через _mapEventToState
    _counterEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(CounterEvent event) {
    if (event is IncrementEvent) {
      _counter++;
    } else {
      _counter--;
    }

    _inCounter.add(_counter);
  }

  void dispose() {
    _counterStateController.close();
    _counterEventController.close();
  }
}