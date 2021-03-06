import 'package:aria2gui/modules/profile.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ServersModel extends ChangeNotifier {
  final LocalStorage ls = LocalStorage("server_list");
  List<Profile> _servers = [];
  int _index = 0;
  List<Profile> get servers => this._servers;
  ServersModel() {
    ls.ready.then((v) {
      if (v) {
        List list = ls.getItem("servers");
        int index = ls.getItem("index");
        if (index != null) {
          this._index = index;
        }
        if (list != null) {
          for (var l in list) {
            _servers.add(Profile.fromJson(l));
          }
        } else {
          ls.setItem("servers", []);
        }
      }
      notifyListeners();
    });
  }

  int get index => _index;

  void setIndex(var index) {
    if (index.runtimeType == String) {
      index = int.parse(index);
    }
    this._index = index;
    ls.setItem("index", index);
    notifyListeners();
  }

  Profile getNow() {
    if (_servers.isEmpty) {
      return Profile("empty", "", "", "");
    } else {
      return _servers[_index];
    }
  }

  add(Profile profile) async {
    List list = ls.getItem("servers");
    list.add(profile);
    await ls.setItem("servers", list);
    _servers.add(profile);
    notifyListeners();
  }

  alter(int index, Profile profile) async {
    List list = ls.getItem("servers");
    list.removeAt(index);
    list.insert(index, profile);
    await ls.setItem("servers", list);
    _servers.removeAt(index);
    _servers.insert(index, profile);
    notifyListeners();
  }

  alterNowProfile(Profile profile) {
    alter(_index, profile);
  }

  delete(int index) async {
    List list = ls.getItem("servers");
    list.removeAt(index);
    if (list.length  == this._index) {
      this._index = this._index - 1;
      await ls.setItem("index", _index);
    }
    await ls.setItem("servers", list);
    _servers.removeAt(index);
    notifyListeners();
  }
}
