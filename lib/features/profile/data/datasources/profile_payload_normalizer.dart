class ProfilePayloadNormalizer {
  static Map<String, dynamic> normalize(dynamic payload) {
    if (payload is! Map) {
      return <String, dynamic>{};
    }

    var map = Map<String, dynamic>.from(payload);

    if (map.containsKey('data') && map['data'] is Map) {
      map = Map<String, dynamic>.from(map['data'] as Map);
    }

    if (map.containsKey('employee') && map['employee'] is Map) {
      map = Map<String, dynamic>.from(map['employee'] as Map);
    } else if (map.containsKey('user') && map['user'] is Map) {
      map = Map<String, dynamic>.from(map['user'] as Map);
    }

    return map;
  }
}
