import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_api.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_bloc.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_widget.dart';

class SprintModule extends ModuleWidget{
  @override
  List<Bloc> get blocs => [
    Bloc((i) => SprintBloc(i.getDependency<SprintApi>())),
  ];


  @override
  Widget get view => SprintWidget();


  @override
  List<Dependency> get dependencies => [
    Dependency((i) => SprintApi())
  ];


  static Inject get to => Inject<SprintModule>.of();

}