part of backendless_sdk;

class FileInfo {
  String? name;
  int? createdOn;
  String? publicUrl;
  String? url;
  int? size;

  FileInfo();

  FileInfo.fromJson(Map json)
      : name = json['name'],
        createdOn = json['createdOn'],
        publicUrl = json['publicUrl'],
        url = json['url'],
        size = json['size'];

  Map toJson() => {
        'name': name,
        'createdOn': createdOn,
        'publicUrl': publicUrl,
        'url': url,
        'size': size,
      };
}
