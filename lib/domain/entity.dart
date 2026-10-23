// status enum

enum Status {
  open,
  done,
  archived,
  unknown;


  static Status fromApi(String? value) => switch (value) {
    'open' => Status.open,
    'done' => Status.done,
    'archived' => Status.archived,
    _ => Status.unknown,
  };

  String get apiValue => name;
}