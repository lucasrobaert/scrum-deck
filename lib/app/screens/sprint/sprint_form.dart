import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_bloc.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_module.dart';

class SprintForm extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SprintFormPage();
  }
}

class SprintFormPage extends StatefulWidget {

  @override
  _SprintFormPageState createState() => _SprintFormPageState();
}

class _SprintFormPageState extends State<SprintFormPage> {
  @override
  Widget build(BuildContext context) {

    final _formKey = GlobalKey<FormState>();
    String _nameSprint = '';
    String _linkSprint = '';

    late TextEditingController nameController = TextEditingController(text: _nameSprint);
    late TextEditingController linkController = TextEditingController(text: _linkSprint);

    late final SprintBloc _bloc = SprintModule.to.getBloc<SprintBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Sprint'),
        actions: [
          IconButton(
              onPressed: (){
                if(_formKey.currentState!.validate()){
                  _formKey.currentState!.save();
                  _bloc.doCreate(nameController.text, linkController.text)
                      .then((_) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sprint criada!'))
                    );
                    _bloc.doFetch();
                  });
                }
              },
              icon: Icon(Icons.check)
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome da Sprint'),
              validator: (value){
                if(value == null || value.trim().isEmpty){
                  return 'O nome não pode ser vazio';
                }
                return null;
              },
              onSaved: (value) => _nameSprint = value!,
            ),
            TextFormField(
              controller: linkController,
              decoration: InputDecoration(labelText: 'Link da Sprint'),
              validator: (value) {
                if(value == null || value.trim().isEmpty){
                  return 'A url não pode ser vazia';
                }
                if(!Uri.parse(value).isAbsolute){
                  return 'Informe uma url válida';
                }

                return null;
              },
              onSaved: (value) => _linkSprint = value!,
            )
          ],
        ),
      ),
    );
  }
}
