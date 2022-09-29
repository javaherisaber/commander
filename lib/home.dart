import 'package:commander/main.dart';
import 'package:commander/sharedpreferences.dart';
import 'package:flutter/material.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _consoleOutputScrollController = ScrollController();
  final TextEditingController _consoleTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeConsole();
  }

  void initializeConsole() async {
    _consoleTextController.text = await AppPreferences.lastCommand;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Commander', style: TextStyle(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold)),
              SizedBox(height: 48),
              SizedBox(
                width: 600,
                child: command(),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: 600,
                child: input(),
              ),
              SizedBox(height: 16),
              consoleOutput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget command() {
    return TextFormField(
      controller: _consoleTextController,
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
    );
  }

  Widget input() {
    return TextField(
      // controller: textInputController,
      onChanged: bloc.onInputChanged,
      onSubmitted: (_) => bloc.onRunButtonClicked(),
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        hintText: 'Inputs here separated with comma',
        hintStyle: const TextStyle(color: Colors.black38),
        suffixIcon: IconButton(
          onPressed: () async {
            bloc.onRunButtonClicked();
            Future.delayed(Duration(milliseconds: 200), () {
              _consoleOutputScrollController.animateTo(
                _consoleOutputScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
              );
            });
          },
          icon: const Icon(Icons.send, color: Colors.blue),
        ),
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
          width: 600,
          height: 400,
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
