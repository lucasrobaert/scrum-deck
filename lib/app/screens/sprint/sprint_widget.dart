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
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Deseja excluir a sprint: ${sprint.nome} ?'),
                              content: Text("Essa ação não poderá ser desfeita"),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text('Não')
                                ),
                                TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: Text('Sim')
                                )
                              ],
                            )
                        ).then((confirmed) => {
                          if(confirmed){
                            _bloc.doDelete(sprint.id).then(
                                (_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Sprint deletada!'))
                                  );
                                  _bloc.doFetch();
                                }
                            ).catchError(
                                (_) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Opps! Aconteceu algum erro, por favor, tente novamente!'))
                                  );
                                }
                            )
                          }
                        });
                      },
                    ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Não implementado ainda!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('ok'),
                )
              ],
            )
          );
        },
        child: const Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.green,
      ),
    );
  }
}
