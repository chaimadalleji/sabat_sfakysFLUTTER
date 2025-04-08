class Photo {
  final int id;
  final String name;
  final String url;

  Photo({required this.id, required this.name, required this.url});

  // Factory constructor to create a Photo object from JSON
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      name: json['name'],
      url: json['url'],
    );
  }

  // Method to convert a Photo object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
    };
  }
}
