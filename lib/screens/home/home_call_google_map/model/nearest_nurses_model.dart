class NearestNursesModel {
  final int id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String phoneNumber;
  final String? profilePicture;
  final int workedYears;
  final String experienceLevel;
  final bool isVerified;
  final double latitude;
  final double longitude;
  final String hospitalName;
  final String specializationName;
  final double averageRating;
  final int totalRatings;

  NearestNursesModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.phoneNumber,
    required this.profilePicture,
    required this.workedYears,
    required this.experienceLevel,
    required this.isVerified,
    required this.latitude,
    required this.longitude,
    required this.hospitalName,
    required this.specializationName,
    required this.averageRating,
    required this.totalRatings,
  });

  factory NearestNursesModel.fromJson(dynamic json) {
    return NearestNursesModel(
      id: json['id'].integerValue,
      firstName: json['first_name'].stringValue,
      lastName: json['last_name'].stringValue,
      fullName: json['full_name'].stringValue,
      phoneNumber: json['phone_number'].stringValue,
      profilePicture: json['profile_picture'].stringValue,
      workedYears: json['worked_years'].integerValue,
      experienceLevel: json['experience_level'].stringValue,
      isVerified: json['is_verified'].boolValue,
      latitude: json['latitude']?.doubleValue ?? 0.0,
      longitude: json['longitude']?.doubleValue ?? 0.0,
      hospitalName: json['hospital']?['name']?.stringValue ?? '',
      specializationName:
          (json['specializations']?.listValue?.isNotEmpty ?? false)
              ? json['specializations'][0]['name'].stringValue
              : '',
      averageRating:
          json['average_rating']?['average_rating']?.doubleValue ?? 0.0,
      totalRatings: json['average_rating']?['total_ratings']?.integerValue ?? 0,
    );
  }
}
