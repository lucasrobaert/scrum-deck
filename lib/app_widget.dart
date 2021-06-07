import 'package:flutter/material.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_form.dart';

import 'app/screens/sprint/sprint_module.dart';

class AppWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) =>MaterialApp(
    theme: ThemeData.dark(),
    home: SprintModule(),
    routes: {
      '/sprintform': (_) => SprintForm()
    },
  );

}