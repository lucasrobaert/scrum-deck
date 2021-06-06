import 'package:flutter/material.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_bloc.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_module.dart';
import 'package:scrum_deck/app/shared/models/sprint.dart';

class SprintWidget extends StatelessWidget {
  late final SprintBloc _bloc = SprintModule.to.getBloc<SprintBloc>();

  @override
  Widget build(BuildContext context) {
    _bloc.doFetch();
    return Scaffold(
      appBar: AppBar(
        title: Text('Sprints'),
      ),
      body: StreamBuilder(
        stream: _bloc.sprints,
        builder: (context, AsyncSnapshot<List<Sprint>> snapshot) {
          if (snapshot.hasData) {
            final sprints = snapshot.data!;
            return ListView.separated(
                itemBuilder: (_, index) {
                  final sprint = sprints[index];
                  return ListTile(
                    title: Text(sprint.nome),
                    subtitle: Text(sprint.link),
                  );
                },
                separatorBuilder: (_, __) => Divider(),
                itemCount: sprints.length);
          }
          return StreamBuilder(
            stream: _bloc.loading,
            builder: (context, AsyncSnapshot<bool> snapshot){
              final loading = snapshot.data ?? false;
              if(loading){
                return Center(child: CircularProgressIndicator());
              }
              return Container();
            },
          );
        },
      ),
    );
  }
}
