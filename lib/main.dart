import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:system_timezone/system_timezone.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Native vs Method Channel',
      home: MyHomePage(title: 'Native vs Method Channel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final b1List = <String>[];
  final b2List = <String>[];
  final b11List = <String>[];
  final b22List = <String>[];

  Future<void> start() async {
    b1List.clear();
    b2List.clear();
    b11List.clear();
    b22List.clear();
    int run = 0;
    while (run < 6) {
      final b1 = benchmark(() => SystemTimezone.getTimezoneName());
      b1List.add(b1.inMicroseconds.toString());
      final b2 = benchmark(() => SystemTimezone.getSupportedTimezones());
      b2List.add(b2.inMicroseconds.toString());

      final b11 =
          await benchmarkAsync(() async => FlutterTimezone.getLocalTimezone());
      b11List.add(b11.inMicroseconds.toString());

      final b22 = await benchmarkAsync(
          () async => FlutterTimezone.getAvailableTimezones());
      b22List.add(b22.inMicroseconds.toString());

      setState(() {});
      run++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SelectionArea(
          child: SingleChildScrollView(
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Get timezone id'),
                  Row(
                    children: [
                      for (final item in b1List) Expanded(child: Text(item)),
                    ],
                  ),
                  Row(
                    children: [
                      for (final item in b11List) Expanded(child: Text(item)),
                    ],
                  ),
                  const Text('Get list of timezones ids'),
                  Row(
                    children: [
                      for (final item in b2List) Expanded(child: Text(item)),
                    ],
                  ),
                  Row(
                    children: [
                      for (final item in b22List) Expanded(child: Text(item)),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      start();
                    },
                    child: const Text('Start'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Duration benchmark(Function() fn) {
  final stopwatch = Stopwatch();
  stopwatch.start();
  fn();
  stopwatch.stop();
  return stopwatch.elapsed;
}

Future<Duration> benchmarkAsync(Future Function() fn) async {
  final stopwatch = Stopwatch();
  stopwatch.start();
  await fn();
  stopwatch.stop();
  return stopwatch.elapsed;
}
