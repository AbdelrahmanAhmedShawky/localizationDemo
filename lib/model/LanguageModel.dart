class LanguageModel {
  int id;
  String desc;
  bool isSelected;

  LanguageModel({this.id = 0, this.desc = '', this.isSelected = false});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    desc = json['desc'];
  }

  static List<LanguageModel> langList = <LanguageModel>[
    LanguageModel(id: 0, desc: 'English'),
    LanguageModel(id: 1, desc: 'Arabic'),
    LanguageModel(id: 2, desc: 'HINDI'),
  ];
}
