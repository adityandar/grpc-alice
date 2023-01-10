class LogModel {
  int? id;
  String? stack;
  String? type;
  String? ref;
  DateTime? createdAt;

  LogModel({
    this.id,
    this.stack,
    this.createdAt,
    this.ref,
    this.type,
  });

  LogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stack = json['stack'];
    type = json['type'];
    ref = json['ref'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stack'] = stack;
    data['type'] = type;
    data['ref'] = ref;
    data['created_at'] = createdAt;

    return data;
  }

  LogModel copyWith({
    int? id,
    String? type,
    String? ref,
    String? stack,
    DateTime? createdAt,
  }) {
    return LogModel(
      id: id ?? this.id,
      stack: stack ?? this.stack,
      type: type ?? this.type,
      ref: ref ?? this.ref,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
