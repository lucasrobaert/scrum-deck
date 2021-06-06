import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrum_deck/app/screens/sprint/sprint_api.dart';
import 'package:scrum_deck/app/shared/models/sprint.dart';

class SprintBloc extends BlocBase{
  final SprintApi _api;
  SprintBloc(this._api);

  final _sprintFetcher = PublishSubject<List<Sprint>>();
  final _loading = BehaviorSubject<bool>();


  Stream<List<Sprint>> get sprints => _sprintFetcher.stream;
  Stream<bool> get loading =>_loading.stream;

  doFetch() async {
    _loading.sink.add(true);

    final sprints = await _api.fetchSprints();

    _loading.sink.add(false);
    _sprintFetcher.sink.add(sprints);
  }


  @override
  void dispose() {
    _sprintFetcher.close();
    _loading.close();
    super.dispose();
  }


}