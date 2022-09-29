import 'dart:io';

import 'package:commander/bloc.dart';
import 'package:flutter/material.dart';
import 'package:process_run/cmd_run.dart';

import 'app.dart';

final bloc = MyBloc();

void main() {
  runApp(const MyApp());
}