class Drawing {
  String? url;
  String? name;
  String? filename;
  String? extension;

  Drawing({
    this.url,
    this.name,
    this.filename,
    this.extension,
  });

  factory Drawing.fromJson(Map<String, dynamic> json) => Drawing(
        url: json["url"],
        name: json["name"],
        filename: json["filename"],
        extension: json["extension"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "name": name,
      };
}
