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
  String? _input1;
  String? _input2;

  void _initialize() async {
    _command = await AppPreferences.lastCommand;
  }

  void onCommandInputChanged(String value) {
    _command = value;
    AppPreferences.saveLastCommand(value);
  }

  void onInput1Changed(String value) {
    _input1 = value;
  }

  void onInput2Changed(String value) {
    _input2 = value;
  }

  void onRunInput1ButtonClicked() async {
    _handleRunInputClick(_input1);
  }

  void onRunInput2ButtonClicked() async {
    _handleRunInputClick(_input2);
  }

  void _handleRunInputClick(String? input) async {
    if (_command != null && _command!.contains(RegExp(r'{#}')) && input == null) {
      runCommand(_command!);
      return;
    }
    if (input != null && input.contains(",")) {
      final inputs = input.split(",");
      for (var i in inputs) {
        await Future.delayed(const Duration(milliseconds: 50));
        runCommand(_command!.replaceFirst(RegExp(r'{#}'), i));
      }
    } else if (input != null) {
      runCommand(_command!.replaceFirst(RegExp(r'{#}'), input));
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