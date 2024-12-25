import '../../base/idto.dart';

class Claim implements IDto {
  final int id;
  final String? jsonExt;
  final DateTime validityFrom;
  final DateTime? validityTo;
  final String? legacyId;
  final String uuid;
  final String? category;
  final String code;
  final DateTime dateFrom;
  final DateTime dateTo;
  final int status;
  final String? adjustment;
  final String claimed;
  final String? approved;
  final String? reinsured;
  final String? valuated;
  final DateTime dateClaimed;
  final DateTime? dateProcessed;
  final bool feedbackAvailable;
  final String explanation;
  final int ? feedbackStatus;
  final int ? reviewStatus;
  final int? approvalStatus;
  final int? rejectionReason;
  final int? auditUserId;
  final DateTime? validityFromReview;
  final DateTime? validityToReview;
  final DateTime? submitStamp;
  final DateTime? processStamp;
  final String? remunerated;
  final String guaranteeId;
  final String visitType;
  final int? auditUserIdReview;
  final int? auditUserIdSubmit;
  final int? auditUserIdProcess;
  final String? careType;
  final String? dischargeReason;
  final String? serviceArea;
  final String? serviceType;
  final int? insuree;
  final String? restore;
  final String? adjuster;
  final int ? feedback;
  final String? batchRun;
  final int? healthFacility;
  final int? admin;
  final int? referFrom;
  final int? referTo;
  final int? icd;
  final int? icd1;
  final int? icd2;
  final int? icd3;
  final int? icd4;

  Claim({
    required this.id,
    this.jsonExt,
    required this.validityFrom,
    this.validityTo,
    this.legacyId,
    required this.uuid,
    this.category,
    required this.code,
    required this.dateFrom,
    required this.dateTo,
    required this.status,
    this.adjustment,
    required this.claimed,
    this.approved,
    this.reinsured,
    this.valuated,
    required this.dateClaimed,
    this.dateProcessed,
    required this.feedbackAvailable,
    required this.explanation,
    required this.feedbackStatus,
    required this.reviewStatus,
    required this.approvalStatus,
    required this.rejectionReason,
    required this.auditUserId,
    this.validityFromReview,
    this.validityToReview,
    this.submitStamp,
    this.processStamp,
    this.remunerated,
    required this.guaranteeId,
    required this.visitType,
    this.auditUserIdReview,
    this.auditUserIdSubmit,
    this.auditUserIdProcess,
    this.careType,
    this.dischargeReason,
    this.serviceArea,
    this.serviceType,
    required this.insuree,
    this.restore,
    this.adjuster,
    this.feedback,
    this.batchRun,
    required this.healthFacility,
    required this.admin,
    this.referFrom,
    this.referTo,
    required this.icd,
    required this.icd1,
    this.icd2,
    this.icd3,
    this.icd4,
  });

  // Factory method to create a Claim from JSON
  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
      id: json['id'],
      jsonExt: json['json_ext'],
      validityFrom: DateTime.parse(json['validity_from']),
      validityTo: json['validity_to'] != null ? DateTime.parse(json['validity_to']) : null,
      legacyId: json['legacy_id'].toString() ?? "",
      uuid: json['uuid'],
      category: json['category'],
      code: json['code'],
      dateFrom: DateTime.parse(json['date_from']),
      dateTo: DateTime.parse(json['date_to']),
      status: json['status'],
      adjustment: json['adjustment'],
      claimed: json['claimed'],
      approved: json['approved'],
      reinsured: json['reinsured'],
      valuated: json['valuated'],
      dateClaimed: DateTime.parse(json['date_claimed']),
      dateProcessed: json['date_processed'] != null ? DateTime.parse(json['date_processed']) : null,
      feedbackAvailable: json['feedback_available'],
      explanation: json['explanation'],
      feedbackStatus: json['feedback_status'],
      reviewStatus: json['review_status'],
      approvalStatus: json['approval_status'],
      rejectionReason: json['rejection_reason'],
      auditUserId: json['audit_user_id'],
      validityFromReview: json['validity_from_review'] != null ? DateTime.parse(json['validity_from_review']) : null,
      validityToReview: json['validity_to_review'] != null ? DateTime.parse(json['validity_to_review']) : null,
      submitStamp: json['submit_stamp'] != null ? DateTime.parse(json['submit_stamp']) : null,
      processStamp: json['process_stamp'] != null ? DateTime.parse(json['process_stamp']) : null,
      remunerated: json['remunerated'],
      guaranteeId: json['guarantee_id'],
      visitType: json['visit_type'],
      auditUserIdReview: json['audit_user_id_review'],
      auditUserIdSubmit: json['audit_user_id_submit'],
      auditUserIdProcess: json['audit_user_id_process'],
      careType: json['care_type'],
      dischargeReason: json['discharge_reason'],
      serviceArea: json['service_area'],
      serviceType: json['service_type'],
      insuree: json['insuree'],
      restore: json['restore'],
      adjuster: json['adjuster'],
      feedback: json['feedback'],
      batchRun: json['batch_run'].toString() ?? "",
      healthFacility: json['health_facility'],
      admin: json['admin'],
      referFrom: json['refer_from'],
      referTo: json['refer_to'],
      icd: json['icd'],
      icd1: json['icd_1'],
      icd2: json['icd_2'],
      icd3: json['icd_3'],
      icd4: json['icd_4'],
    );
  }

  // Method to convert a Claim instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'json_ext': jsonExt,
      'validity_from': validityFrom.toIso8601String(),
      'validity_to': validityTo?.toIso8601String(),
      'legacy_id': legacyId,
      'uuid': uuid,
      'category': category,
      'code': code,
      'date_from': dateFrom.toIso8601String(),
      'date_to': dateTo.toIso8601String(),
      'status': status,
      'adjustment': adjustment,
      'claimed': claimed,
      'approved': approved,
      'reinsured': reinsured,
      'valuated': valuated,
      'date_claimed': dateClaimed.toIso8601String(),
      'date_processed': dateProcessed?.toIso8601String(),
      'feedback_available': feedbackAvailable,
      'explanation': explanation,
      'feedback_status': feedbackStatus,
      'review_status': reviewStatus,
      'approval_status': approvalStatus,
      'rejection_reason': rejectionReason,
      'audit_user_id': auditUserId,
      'validity_from_review': validityFromReview?.toIso8601String(),
      'validity_to_review': validityToReview?.toIso8601String(),
      'submit_stamp': submitStamp?.toIso8601String(),
      'process_stamp': processStamp?.toIso8601String(),
      'remunerated': remunerated,
      'guarantee_id': guaranteeId,
      'visit_type': visitType,
      'audit_user_id_review': auditUserIdReview,
      'audit_user_id_submit': auditUserIdSubmit,
      'audit_user_id_process': auditUserIdProcess,
      'care_type': careType,
      'discharge_reason': dischargeReason,
      'service_area': serviceArea,
      'service_type': serviceType,
      'insuree': insuree,
      'restore': restore,
      'adjuster': adjuster,
      'feedback': feedback,
      'batch_run': batchRun,
      'health_facility': healthFacility,
      'admin': admin,
      'refer_from': referFrom,
      'refer_to': referTo,
      'icd': icd,
      'icd_1': icd1,
      'icd_2': icd2,
      'icd_3': icd3,
      'icd_4': icd4,
    };
  }
}
