import '../../base/idto.dart';

class InsureeClaimResponse implements IDto {
  List<ClaimedItem> claimedItems;
  List<ClaimedService> claimedServices;

  InsureeClaimResponse({
    required this.claimedItems,
    required this.claimedServices,
  });

  // Factory constructor to create an instance from JSON
  factory InsureeClaimResponse.fromJson(Map<String, dynamic> json) {
    return InsureeClaimResponse(
      claimedItems: (json['claimed_items'] as List)
          .map((item) => ClaimedItem.fromJson(item))
          .toList(),
      claimedServices: (json['claimed_services'] as List)
          .map((service) => ClaimedService.fromJson(service))
          .toList(),
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'claimed_items': claimedItems.map((item) => item.toJson()).toList(),
      'claimed_services': claimedServices.map((service) => service.toJson()).toList(),
    };
  }
}

class ClaimedItem implements IDto {
  String itemName;
  double qtyProvided;
  double priceAsked;
  double? priceApproved; // Nullable
  int status;

  ClaimedItem({
    required this.itemName,
    required this.qtyProvided,
    required this.priceAsked,
    this.priceApproved,
    required this.status,
  });

  // Factory constructor to create an instance from JSON
  factory ClaimedItem.fromJson(Map<String, dynamic> json) {
    return ClaimedItem(
      itemName: json['item_name'],
      qtyProvided: json['qty_provided'].toDouble(),
      priceAsked: json['price_asked'].toDouble(),
      priceApproved: json['price_approved'] != null
          ? json['price_approved'].toDouble()
          : null,
      status: json['status'],
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'qty_provided': qtyProvided,
      'price_asked': priceAsked,
      'price_approved': priceApproved,
      'status': status,
    };
  }
}

class ClaimedService {
  String serviceName;
  double qtyProvided;
  double priceAsked;
  double? priceApproved; // Nullable
  int status;

  ClaimedService({
    required this.serviceName,
    required this.qtyProvided,
    required this.priceAsked,
    this.priceApproved,
    required this.status,
  });

  // Factory constructor to create an instance from JSON
  factory ClaimedService.fromJson(Map<String, dynamic> json) {
    return ClaimedService(
      serviceName: json['service_name'],
      qtyProvided: json['qty_provided'].toDouble(),
      priceAsked: json['price_asked'].toDouble(),
      priceApproved: json['price_approved'] != null
          ? json['price_approved'].toDouble()
          : null,
      status: json['status'],
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'service_name': serviceName,
      'qty_provided': qtyProvided,
      'price_asked': priceAsked,
      'price_approved': priceApproved,
      'status': status,
    };
  }
}
