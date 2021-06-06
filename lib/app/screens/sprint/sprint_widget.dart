import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_bloc.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_form.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_module.dart';
import 'package:scrum_deck/app/shared/models/sprint.dart';

class SprintWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Sprints'),
      ),
      body: SprintPage(),
    );
  }
}

class SprintPage extends StatefulWidget {
  @override
  _SprintPageState createState() => _SprintPageState();
}

class _SprintPageState extends State<SprintPage> {
  late final SprintBloc _bloc = SprintModule.to.getBloc<SprintBloc>();
  var _isVisible;
  late ScrollController _hideButtonController;

  @override
  initState() {
    super.initState();
    _isVisible = true;
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _bloc.doFetch();
    return Scaffold(
      body: StreamBuilder(
        stream: _bloc.sprints,
        builder: (context, AsyncSnapshot<List<Sprint>> snapshot) {
          if (snapshot.hasData) {
            final sprints = snapshot.data!;
            return SafeArea(
              child: ListView.separated(
                  controller: _hideButtonController,
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
                                    title: Text(
                                        'Deseja excluir a sprint: ${sprint.nome} ?'),
                                    content: Text(
                                        "Essa ação não poderá ser desfeita"),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text('Não')),
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: Text('Sim'))
                                    ],
                                  )).then((confirmed) => {
                                if (confirmed)
                                  {
                                    _bloc.doDelete(sprint.id).then((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          'Sprint deletada!',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.green,
                                      ));
                                      _bloc.doFetch();
                                    }).catchError((_) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          'Opps! Aconteceu algum erro, por favor, tente novamente!',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                      ));
                                    })
                                  }
                              });
                        },
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => Divider(),
                  itemCount: sprints.length),
            );
          }
          return StreamBuilder(
            stream: _bloc.loading,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              final loading = snapshot.data ?? false;
              if (loading) {
                return Center(child: CircularProgressIndicator());
              }
              return Container();
            },
          );
        },
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return SprintForm();
                });
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}
