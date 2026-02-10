import 'package:g_json/g_json.dart';

class HealthInfoModel {
  final int? id;
  bool? isHealthy;
  bool? hasRegularMedication;
  final String? regularMedicationDetails;
  bool? hasAllergies;
  final String? allergyDetails;
  bool? hasDiabetes;
  bool? hasHypertension;
  bool? hasEpilepsy;
  bool? hasHeartDisease;
  final String? preferredServiceType;
  final String? signature;
  final String? medicalCertificate;
  final String? additionalNotes;
  final String? createdAt;
  final String? updatedAt;
  final List<NearestNursesModel> nearestNurses;

  HealthInfoModel.fromJson(JSON json)
      : id = json['id'].integerValue,
        isHealthy = json['is_healthy'].booleanValue,
        hasRegularMedication = json['has_regular_medication'].booleanValue,
        regularMedicationDetails =
            json['regular_medication_details'].stringValue,
        hasAllergies = json['has_allergies'].booleanValue,
        allergyDetails = json['allergy_details'].stringValue,
        hasDiabetes = json['has_diabetes'].booleanValue,
        hasHypertension = json['has_hypertension'].booleanValue,
        hasEpilepsy = json['has_epilepsy'].booleanValue,
        hasHeartDisease = json['has_heart_disease'].booleanValue,
        preferredServiceType = json['preferred_service_type'].stringValue,
        signature = json['signature'].stringValue,
        medicalCertificate = json['medical_certificate'].stringValue,
        additionalNotes = json['additional_notes'].stringValue,
        createdAt = json['created_at'].stringValue,
        updatedAt = json['updated_at'].stringValue,
        nearestNurses = json['nearest_nurses']
            .listValue
            .map((e) => NearestNursesModel.fromJson(e))
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'is_healthy': isHealthy,
      'has_regular_medication': hasRegularMedication,
      'regular_medication_details': regularMedicationDetails,
      'has_allergies': hasAllergies,
      'allergy_details': allergyDetails,
      'has_diabetes': hasDiabetes,
      'has_hypertension': hasHypertension,
      'has_epilepsy': hasEpilepsy,
      'has_heart_disease': hasHeartDisease,
      'preferred_service_type': preferredServiceType,
      'signature': signature,
      'medical_certificate': medicalCertificate,
      'additional_notes': additionalNotes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class NearestNursesModel {
  final int? id;
  final String? fullName;
  final String? experienceLevel;
  final int? workedYears;
  final String? hospital;
  final double? distanceKm;
  final String? profilePicture;
  final String? phone;
  double latitude;
  double longitude;
  bool? isVerified;
  final double? averageRating;
  final int? totalRatings;
  final String? ratingDisplay;

  NearestNursesModel.fromJson(JSON json)
      : id = json['id'].integerValue,
        fullName = json['full_name'].stringValue,
        experienceLevel = json['experience_level'].stringValue,
        workedYears = json['worked_years'].integerValue,
        hospital = json['hospital'].stringValue,
        distanceKm = json['distance_km'].ddoubleValue,
        profilePicture = json['profile_picture'].stringValue,
        phone = json['phone'].stringValue,
        latitude = json['latitude'].ddoubleValue,
        longitude = json['longitude'].ddoubleValue,
        isVerified = json['is_verified'].booleanValue,
        averageRating = json['rating']['average_rating'].ddoubleValue,
        totalRatings = json['rating']['total_ratings'].integerValue,
        ratingDisplay = json['rating']['rating_display'].stringValue;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'experience_level': experienceLevel,
      'worked_years': workedYears,
      'hospital': hospital,
      'distance_km': distanceKm,
      'latitude': latitude,
      'longitude': longitude,
      'is_verified': isVerified,
      'average_rating': averageRating,
      'total_ratings': totalRatings,
      'rating_display': ratingDisplay,
    };
  }
}
