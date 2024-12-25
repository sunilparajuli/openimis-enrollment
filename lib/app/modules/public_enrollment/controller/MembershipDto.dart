import 'package:openimis_app/app/data/remote/base/idto.dart';

class MemberShipCard implements IDto {
  MemberShipCard({
    required this.pdfBase64,
  });

  MemberShipCard.fromJson(Map<String, dynamic> json)
      : pdfBase64 = json['pdf_base64'];

  final String pdfBase64;

  MemberShipCard copyWith({
    String? pdfBase64,
  }) =>
      MemberShipCard(
        pdfBase64: pdfBase64 ?? this.pdfBase64,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pdf_base64'] = pdfBase64;
    return map;
  }
}
