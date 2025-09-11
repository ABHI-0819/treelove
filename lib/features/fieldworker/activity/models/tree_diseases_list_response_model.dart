import 'dart:convert';

TreeDiseaseListResponse treeDiseaseListResponseFromJson(String str) =>
    TreeDiseaseListResponse.fromJson(json.decode(str));

String treeDiseaseListResponseToJson(TreeDiseaseListResponse data) =>
    json.encode(data.toJson());

class TreeDiseaseListResponse {
  final String status;
  final String message;
  final List<TreeDisease> data;

  TreeDiseaseListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TreeDiseaseListResponse.fromJson(Map<String, dynamic> json) =>
      TreeDiseaseListResponse(
        status: json["status"],
        message: json["message"],
        data: List<TreeDisease>.from(
            json["data"].map((x) => TreeDisease.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class TreeDisease {
  final String id;
  final String diseaseName;
  final String scientificName;
  final String symptoms;
  final String cause;
  final String treatment;
  final String prevention;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;

  TreeDisease({
    required this.id,
    required this.diseaseName,
    required this.scientificName,
    required this.symptoms,
    required this.cause,
    required this.treatment,
    required this.prevention,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TreeDisease.fromJson(Map<String, dynamic> json) => TreeDisease(
    id: json["id"],
    diseaseName: json["disease_name"] ??"",
    scientificName: json["scientific_name"],
    symptoms: json["symptoms"]??"",
    cause: json["cause"]??'',
    treatment: json["treatment"],
    prevention: json["prevention"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "disease_name": diseaseName,
    "scientific_name": scientificName,
    "symptoms": symptoms,
    "cause": cause,
    "treatment": treatment,
    "prevention": prevention,
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
