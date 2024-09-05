import 'package:openimis_app/app/data/local/base/i_entity.dart';

class AppConfigEntity implements IEntity {
  String? domainName;
  String? appVersion;
  String? apiBaseUrl;
  String? supportEmail;

  AppConfigEntity({
    required this.domainName,
    required this.appVersion,
    required this.apiBaseUrl,
    required this.supportEmail,
  });

  @override
  AppConfigEntity.fromMap(dynamic map) {
    domainName = map['domain_name'];
    appVersion = map['app_version'];
    apiBaseUrl = map['api_base_url'];
    supportEmail = map['support_email'];
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['domain_name'] = domainName;
    map['app_version'] = appVersion;
    map['api_base_url'] = apiBaseUrl;
    map['support_email'] = supportEmail;
    return map;
  }
}
