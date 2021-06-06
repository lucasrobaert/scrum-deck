import 'package:flutter/material.dart';

import 'app/screens/sprint/sprint_module.dart';

class AppWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) =>MaterialApp(
    theme: ThemeData.dark(),
    home: SprintModule()
  );

}