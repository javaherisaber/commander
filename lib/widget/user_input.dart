import 'package:flutter/material.dart';

class UserInput extends StatelessWidget {
  const UserInput({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.onRunClick,
    this.scrollController
  });

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onRunClick;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      // controller: textInputController,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        hintText: 'Inputs here separated by comma',
        hintStyle: const TextStyle(color: Colors.black38),
        suffixIcon: IconButton(
          onPressed: () async {
            onRunClick?.call();
            Future.delayed(const Duration(milliseconds: 200), () {
              if (scrollController != null) {
                scrollController!.animateTo(
                  scrollController!.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn,
                );
              }
            });
          },
          icon: const Icon(Icons.send, color: Colors.blue),
        ),
      ),
    );
  }
}
