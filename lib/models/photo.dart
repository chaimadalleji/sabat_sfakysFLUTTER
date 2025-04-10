// File: models/photo.dart

class Photo {
  int? id;
  String name;
  String? url;
  // Add any other properties your Photo class has
  
  Photo({
    this.id,
    required this.name,
    this.url,
  });
  
  // Add fromJson factory constructor for deserialization
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      name: json['name'] ?? '',
      url: json['url'],
    );
  }
  
  // Add the missing toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
    };
  }
}