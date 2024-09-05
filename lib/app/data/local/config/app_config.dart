import 'package:openimis_app/app/data/remote/base/idto.dart';
import 'dart:convert';

import '../../remote/base/idto.dart';

// To parse this JSON data, do
//
//     final appConfig = appConfigFromJson(jsonString);

AppConfig appConfigFromJson(String str) => AppConfig.fromJson(json.decode(str));

String appConfigToJson(AppConfig data) => json.encode(data.toJson());

class AppConfig implements IDto {
  String? domainName;
  String? appVersion;
  String? apiBaseUrl;
  String? supportEmail;

  AppConfig({
    this.domainName,
    this.appVersion,
    this.apiBaseUrl,
    this.supportEmail,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    domainName: json["domain_name"] as String?,
    appVersion: json["app_version"] as String?,
    apiBaseUrl: json["api_base_url"] as String?,
    supportEmail: json["support_email"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "domain_name": domainName,
    "app_version": appVersion,
    "api_base_url": apiBaseUrl,
    "support_email": supportEmail,
  };

  AppConfig copyWith({
    String? domainName,
    String? appVersion,
    String? apiBaseUrl,
    String? supportEmail,
  }) => AppConfig(
    domainName: domainName ?? this.domainName,
    appVersion: appVersion ?? this.appVersion,
    apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
    supportEmail: supportEmail ?? this.supportEmail,
  );
}
