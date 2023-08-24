import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RCService {
  final remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 1),
        minimumFetchInterval: const Duration(seconds: 1),
      ),
    );

    await settingDefault();
  }

  Future<void> settingDefault() async {
    await remoteConfig.setDefaults( {
      "background_color": 0xFFFFFF33,
      "app_title": "Learn Firebase",
      "show_add": false,
      "add": jsonEncode({
        "title": "New Product",
        "description": "...",
        "imageUrl":
        "https://plus.unsplash.com/premium_photo-1673795753320-a9df2df4461e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80",
      }),
    });
  }

  int get color => remoteConfig.getInt("background_color");

  String get title => remoteConfig.getString("app_title");

  bool get showAdd => remoteConfig.getBool("show_add");

  Add get add {
    final data = remoteConfig.getString("add");
    final json = jsonDecode(data);
    return Add.fromJson(json);
  }

  Future<void> activate() async {
    await remoteConfig.fetchAndActivate();
  }
}

class Add {
  String title;
  String description;
  String imageUrl;

  Add({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Add.fromJson(Map<String, Object?> json) {
    return Add(
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}
