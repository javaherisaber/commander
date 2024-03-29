import 'package:commander/sharedpreferences.dart';
import 'package:process_run/cmd_run.dart';
import 'package:rxdart/rxdart.dart';

class MyBloc {
  MyBloc() {
    _initialize();
  }

  final _consoleOutput = BehaviorSubject<List<String>>();

  Stream<List<String>> get consoleOutput => _consoleOutput.stream;

  String? _command;
  String? _input;

  void _initialize() async {
    _command = await AppPreferences.lastCommand;
  }

  void onCommandInputChanged(String value) {
    _command = value;
    AppPreferences.saveLastCommand(value);
  }

  void onInputChanged(String value) {
    _input = value;
  }

  void onRunButtonClicked() async {
    if (_command != null && _command!.contains(RegExp(r'{#}')) && _input == null) {
      runCommand(_command!);
      return;
    }
    if (_input != null && _input!.contains(",")) {
      final inputs = _input!.split(",");
      for (var i in inputs) {
        await Future.delayed(const Duration(milliseconds: 50));
        runCommand(_command!.replaceFirst(RegExp(r'{#}'), i));
      }
    } else {
      runCommand(_command!.replaceFirst(RegExp(r'{#}'), _input!));
    }
  }

  void runCommand(String executable) async {
    // Directory.current = r'C:\Users\Lion\Desktop';
    var result = await runExecutableArguments(executable, [], verbose: true);
    List<String> previousOutput = _consoleOutput.valueOrNull ?? [];
    previousOutput.add(executable);
    final stdout = result.stdout.toString();
    final stderr = result.stderr.toString();
    if (stdout.isNotEmpty) {
      previousOutput.add(stdout);
    }
    if (stderr.isNotEmpty) {
      previousOutput.add(stderr);
    }
    _consoleOutput.value = previousOutput;
  }
}