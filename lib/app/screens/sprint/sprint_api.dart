import 'dart:convert';

import 'package:http/http.dart';
import 'package:scrum_deck/app/shared/util/constantes.dart';
import 'package:scrum_deck/app/shared/models/sprint.dart';
import 'package:scrum_deck/app_module.dart';

class SprintApi {
  final _client = AppModule.to.getDependency<Client>();

  Future<List<Sprint>> fetchSprints() async {
    final response =
        await _client.get(Uri.parse('${Constants.API_BASE_URL}/sprint'));

    if (response.statusCode == 200) {
      final List<dynamic> jSprints = json.decode(response.body);
      final sprints = jSprints.map((e) => Sprint.fromJson(e)).toList();

      return sprints;
    } else {
      throw Exception(
          'Erro ao recuperar sprints. Status code: ${response.statusCode}');
    }
  }

  Future deleteSprint(int sprintId) async {
    final response = await _client
        .delete(Uri.parse('${Constants.API_BASE_URL}/sprint/$sprintId'));

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Opps! Erro ao deletar sprint');
    }
  }

  Future createSprint(String name, String link) async {
    final response = await _client.post(
        Uri.parse('${Constants.API_BASE_URL}/sprint'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'nome': name, 'link': link}));

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Erro ao inserir a sprint');
    }
  }
}
