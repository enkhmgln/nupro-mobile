class TreatmentHistoyDetailModel {
  Call? call;
  Customer? customer;
  Nurse? nurse;
  Payment? payment;
  HealthInfo? healthInfo;
  NurseLocation? nurseLocation;
  String? userType;

  TreatmentHistoyDetailModel(
      {this.call,
      this.customer,
      this.nurse,
      this.payment,
      this.healthInfo,
      this.nurseLocation,
      this.userType});

  TreatmentHistoyDetailModel.fromJson(Map<String, dynamic> json) {
    call = json['call'] != null ? Call.fromJson(json['call']) : null;
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    nurse = json['nurse'] != null ? Nurse.fromJson(json['nurse']) : null;
    payment =
        json['payment'] != null ? Payment.fromJson(json['payment']) : null;
    healthInfo = json['health_info'] != null
        ? HealthInfo.fromJson(json['health_info'])
        : null;
    nurseLocation = json['nurse_location'] != null
        ? NurseLocation.fromJson(json['nurse_location'])
        : null;
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (call != null) {
      data['call'] = call!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (nurse != null) {
      data['nurse'] = nurse!.toJson();
    }
    if (payment != null) {
      data['payment'] = payment!.toJson();
    }
    if (healthInfo != null) {
      data['health_info'] = healthInfo!.toJson();
    }
    if (nurseLocation != null) {
      data['nurse_location'] = nurseLocation!.toJson();
    }
    data['user_type'] = userType;
    return data;
  }
}

class Call {
  int? id;
  String? status;
  String? statusDisplay;
  String? createdAt;
  String? acceptedAt;
  String? completedAt;
  String? paymentTransferredAt;
  String? customerLatitude;
  String? customerLongitude;
  String? nurseNotes;
  String? completionCode;
  String? completionCodeExpiresAt;

  Call(
      {this.id,
      this.status,
      this.statusDisplay,
      this.createdAt,
      this.acceptedAt,
      this.completedAt,
      this.paymentTransferredAt,
      this.customerLatitude,
      this.customerLongitude,
      this.nurseNotes,
      this.completionCode,
      this.completionCodeExpiresAt});

  Call.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    statusDisplay = json['status_display'];
    createdAt = json['created_at'];
    acceptedAt = json['accepted_at'];
    completedAt = json['completed_at'];
    paymentTransferredAt = json['payment_transferred_at'];
    customerLatitude = json['customer_latitude'];
    customerLongitude = json['customer_longitude'];
    nurseNotes = json['nurse_notes'];
    completionCode = json['completion_code'];
    completionCodeExpiresAt = json['completion_code_expires_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['status_display'] = statusDisplay;
    data['created_at'] = createdAt;
    data['accepted_at'] = acceptedAt;
    data['completed_at'] = completedAt;
    data['payment_transferred_at'] = paymentTransferredAt;
    data['customer_latitude'] = customerLatitude;
    data['customer_longitude'] = customerLongitude;
    data['nurse_notes'] = nurseNotes;
    data['completion_code'] = completionCode;
    data['completion_code_expires_at'] = completionCodeExpiresAt;
    return data;
  }
}

class Customer {
  int? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? sex;
  String? sexDisplay;
  String? dateOfBirth;
  String? profilePicture;
  String? fullLocation;
  String? subDistrict;
  String? district;
  String? city;

  Customer(
      {this.id,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.sex,
      this.sexDisplay,
      this.dateOfBirth,
      this.profilePicture,
      this.fullLocation,
      this.subDistrict,
      this.district,
      this.city});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneNumber = json['phone_number'];
    sex = json['sex'];
    sexDisplay = json['sex_display'];
    dateOfBirth = json['date_of_birth'];
    profilePicture = json['profile_picture'];
    fullLocation = json['full_location'];
    subDistrict = json['sub_district'];
    district = json['district'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone_number'] = phoneNumber;
    data['sex'] = sex;
    data['sex_display'] = sexDisplay;
    data['date_of_birth'] = dateOfBirth;
    data['profile_picture'] = profilePicture;
    data['full_location'] = fullLocation;
    data['sub_district'] = subDistrict;
    data['district'] = district;
    data['city'] = city;
    return data;
  }
}

class Nurse {
  int? id;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? profilePicture;
  int? workedYears;
  String? experienceLevel;
  bool? isVerified;
  Hospital? hospital;
  List<Specializations>? specializations;
  AverageRating? averageRating;

  Nurse(
      {this.id,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.profilePicture,
      this.workedYears,
      this.experienceLevel,
      this.isVerified,
      this.hospital,
      this.specializations,
      this.averageRating});

  Nurse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneNumber = json['phone_number'];
    profilePicture = json['profile_picture'];
    workedYears = json['worked_years'];
    experienceLevel = json['experience_level'];
    isVerified = json['is_verified'];
    hospital =
        json['hospital'] != null ? Hospital.fromJson(json['hospital']) : null;
    if (json['specializations'] != null) {
      specializations = <Specializations>[];
      json['specializations'].forEach((v) {
        specializations!.add(Specializations.fromJson(v));
      });
    }
    averageRating = json['average_rating'] != null
        ? AverageRating.fromJson(json['average_rating'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone_number'] = phoneNumber;
    data['profile_picture'] = profilePicture;
    data['worked_years'] = workedYears;
    data['experience_level'] = experienceLevel;
    data['is_verified'] = isVerified;
    if (hospital != null) {
      data['hospital'] = hospital!.toJson();
    }
    if (specializations != null) {
      data['specializations'] =
          specializations!.map((v) => v.toJson()).toList();
    }
    if (averageRating != null) {
      data['average_rating'] = averageRating!.toJson();
    }
    return data;
  }
}

class Hospital {
  int? id;
  String? name;
  String? address;
  String? phoneNumber;

  Hospital({this.id, this.name, this.address, this.phoneNumber});

  Hospital.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['phone_number'] = phoneNumber;
    return data;
  }
}

class Specializations {
  int? id;
  String? name;

  Specializations({this.id, this.name});

  Specializations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class AverageRating {
  int? averageRating;
  int? totalRatings;

  AverageRating({this.averageRating, this.totalRatings});

  AverageRating.fromJson(Map<String, dynamic> json) {
    averageRating = json['average_rating'];
    totalRatings = json['total_ratings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['average_rating'] = averageRating;
    data['total_ratings'] = totalRatings;
    return data;
  }
}

class Payment {
  String? paidAt;
  String? paymentStatus;
  String? paymentStatusDisplay;
  String? amount;

  Payment(
      {this.paidAt,
      this.paymentStatus,
      this.paymentStatusDisplay,
      this.amount});

  Payment.fromJson(Map<String, dynamic> json) {
    paidAt = json['paid_at'];
    paymentStatus = json['payment_status'];
    paymentStatusDisplay = json['payment_status_display'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paid_at'] = paidAt;
    data['payment_status'] = paymentStatus;
    data['payment_status_display'] = paymentStatusDisplay;
    data['amount'] = amount;
    return data;
  }
}

class HealthInfo {
  bool? isHealthy;
  bool? hasRegularMedication;
  String? regularMedicationDetails;
  bool? hasAllergies;
  String? allergyDetails;
  bool? hasDiabetes;
  bool? hasHypertension;
  bool? hasEpilepsy;
  bool? hasHeartDisease;
  String? medicalConditionsSummary;
  Specializations? preferredServiceType;
  String? additionalNotes;
  String? signature;
  String? medicalCertificate;

  HealthInfo(
      {this.isHealthy,
      this.hasRegularMedication,
      this.regularMedicationDetails,
      this.hasAllergies,
      this.allergyDetails,
      this.hasDiabetes,
      this.hasHypertension,
      this.hasEpilepsy,
      this.hasHeartDisease,
      this.medicalConditionsSummary,
      this.preferredServiceType,
      this.additionalNotes,
      this.signature,
      this.medicalCertificate});

  HealthInfo.fromJson(Map<String, dynamic> json) {
    isHealthy = json['is_healthy'];
    hasRegularMedication = json['has_regular_medication'];
    regularMedicationDetails = json['regular_medication_details'];
    hasAllergies = json['has_allergies'];
    allergyDetails = json['allergy_details'];
    hasDiabetes = json['has_diabetes'];
    hasHypertension = json['has_hypertension'];
    hasEpilepsy = json['has_epilepsy'];
    hasHeartDisease = json['has_heart_disease'];
    medicalConditionsSummary = json['medical_conditions_summary'];
    preferredServiceType = json['preferred_service_type'] != null
        ? Specializations.fromJson(json['preferred_service_type'])
        : null;
    additionalNotes = json['additional_notes'];
    signature = json['signature'];
    medicalCertificate = json['medical_certificate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_healthy'] = isHealthy;
    data['has_regular_medication'] = hasRegularMedication;
    data['regular_medication_details'] = regularMedicationDetails;
    data['has_allergies'] = hasAllergies;
    data['allergy_details'] = allergyDetails;
    data['has_diabetes'] = hasDiabetes;
    data['has_hypertension'] = hasHypertension;
    data['has_epilepsy'] = hasEpilepsy;
    data['has_heart_disease'] = hasHeartDisease;
    data['medical_conditions_summary'] = medicalConditionsSummary;
    if (preferredServiceType != null) {
      data['preferred_service_type'] = preferredServiceType!.toJson();
    }
    data['additional_notes'] = additionalNotes;
    data['signature'] = signature;
    data['medical_certificate'] = medicalCertificate;
    return data;
  }
}

class NurseLocation {
  double? latitude;
  double? longitude;
  String? updatedAt;

  NurseLocation({this.latitude, this.longitude, this.updatedAt});

  NurseLocation.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['updated_at'] = updatedAt;
    return data;
  }
}
