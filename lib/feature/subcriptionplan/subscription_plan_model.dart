class CurrentSubscriptionResponse {
  String? responseCode;
  String? message;
  Map<String, dynamic>? content;

  CurrentSubscriptionResponse({this.responseCode, this.message, this.content});

  CurrentSubscriptionResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    content = json['content'];
  }
}

class SubscriptionPlanResponse {
  String? responseCode;
  String? message;
  SubscriptionContent? content;

  SubscriptionPlanResponse({this.responseCode, this.message, this.content});

  SubscriptionPlanResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    content = json['content'] != null
        ? SubscriptionContent.fromJson(json['content'])
        : null;
  }
}

class SubscriptionContent {
  List<SubscriptionPlan>? plans;

  SubscriptionContent({this.plans});

  SubscriptionContent.fromJson(Map<String, dynamic> json) {
    if (json['plans'] != null) {
      plans = <SubscriptionPlan>[];
      json['plans'].forEach((v) {
        plans!.add(SubscriptionPlan.fromJson(v));
      });
    }
  }
}

class SubscriptionPlan {
  String? id;
  String? slug;
  String? name;
  String? tierLabel;
  int? price;
  int? billingIntervalMonths;
  String? shortDescription;
  String? description;
  List<String>? benefits;
  int? sortOrder;
  int? exteriorWashesPerMonth;
  int? washesPerWeek;
  int? freeVacuumPerWeek;
  bool? tirePolishingIncluded;
  bool? includesInterior;

  SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    slug = json['slug']?.toString();
    name = json['name']?.toString();
    tierLabel = json['tier_label']?.toString();
    price = json['price'] != null
        ? double.tryParse(json['price'].toString())?.toInt()
        : null;
    billingIntervalMonths = json['billing_interval_months'] != null
        ? int.tryParse(json['billing_interval_months'].toString())
        : null;
    shortDescription = json['short_description']?.toString();
    description = json['description']?.toString();
    benefits = json['benefits'] != null && json['benefits'] is List
        ? (json['benefits'] as List).map((e) => e.toString()).toList()
        : [];
    sortOrder = json['sort_order'] != null
        ? int.tryParse(json['sort_order'].toString())
        : null;
    exteriorWashesPerMonth = json['exterior_washes_per_month'] != null
        ? int.tryParse(json['exterior_washes_per_month'].toString())
        : null;
    washesPerWeek = json['washes_per_week'] != null
        ? int.tryParse(json['washes_per_week'].toString())
        : null;
    freeVacuumPerWeek = json['free_vacuum_per_week'] != null
        ? int.tryParse(json['free_vacuum_per_week'].toString())
        : null;
    tirePolishingIncluded =
        json['tire_polishing_included'] == true ||
        json['tire_polishing_included'] == 'true';
    includesInterior =
        json['includes_interior'] == true ||
        json['includes_interior'] == 'true';
  }
}
