import 'dart:convert';

class Sprint {
  Sprint({
    required this.id,
    required this.nome,
    required this.link,
  });

  int id;
  String nome;
  String link;

  factory Sprint.fromRawJson(String str) => Sprint.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sprint.fromJson(Map<String, dynamic> json) => Sprint(
    id: json["id"],
    nome: json["nome"],
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nome": nome,
    "link": link,
  };
}
