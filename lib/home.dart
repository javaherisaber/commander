import 'package:commander/main.dart';
import 'package:commander/sharedpreferences.dart';
import 'package:commander/widget/user_input.dart';
import 'package:flutter/material.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _consoleOutputScrollController = ScrollController();
  final TextEditingController _commandTextController = TextEditingController();
  static const double widgetsWidth = 1000;

  @override
  void initState() {
    super.initState();
    initializeConsole();
  }

  void initializeConsole() async {
    _commandTextController.text = await AppPreferences.lastCommand;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Commander', style: TextStyle(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              command(),
              const SizedBox(height: 16),
              input1(),
              const SizedBox(height: 16),
              input2(),
              const SizedBox(height: 16),
              consoleOutput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget command() {
    return Container(
      width: widgetsWidth,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        controller: _commandTextController,
        onChanged: bloc.onCommandInputChanged,
        decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          hintText: 'Your command here, eg. adb shell',
          hintStyle: TextStyle(color: Colors.black38),
        ),
      ),
    );
  }

  Widget input1() {
    return Container(
      width: widgetsWidth,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: UserInput(
        onChanged: bloc.onInput1Changed,
        onSubmitted: (_) => bloc.onRunInput1ButtonClicked(),
        onRunClick: () => bloc.onRunInput1ButtonClicked(),
        scrollController: _consoleOutputScrollController,
      ),
    );
  }

  Widget input2() {
    return Container(
      width: widgetsWidth,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: UserInput(
        onChanged: bloc.onInput2Changed,
        onSubmitted: (_) => bloc.onRunInput2ButtonClicked(),
        onRunClick: () => bloc.onRunInput2ButtonClicked(),
        scrollController: _consoleOutputScrollController,
      ),
    );
  }

  Widget consoleOutput() {
    return StreamBuilder<List<String>>(
      stream: bloc.consoleOutput,
      builder: (context, snapshot) {
        var items = [];
        if (snapshot.hasData) {
          items = snapshot.requireData;
        } else {
          items = ['Run your command to see the results here!'];
        }
        return Container(
          width: widgetsWidth,
          height: 400,
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          padding: EdgeInsets.all(16),
          color: Colors.black87,
          child: TouchMouseScrollable(
            child: ListView.separated(
              controller: _consoleOutputScrollController,
              separatorBuilder: (context, index) {
                return SizedBox(height: 8);
              },
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return consoleItem(items[index]);
              },
            ),
          ),
        );
      },
    );
  }

  Widget consoleItem(String value) {
    return Text(
      '> $value',
      style: const TextStyle(color: Colors.white),
    );
  }
}
