import 'dart:typed_data';

class Picture {
  int? id;
  Uint8List? picture;

  Picture(this.id, this.picture);

  Picture.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    picture = map['picture'];
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "picture": picture,
      };
}
