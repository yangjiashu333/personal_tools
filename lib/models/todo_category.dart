enum TodoCategory {
  flexMuscles('Flex muscles', '展示肌肉'),
  displayVulnerability('Display vulnerability', '展示脆弱性');

  const TodoCategory(this.englishName, this.chineseName);
  
  final String englishName;
  final String chineseName;
  
  String get displayName => chineseName;
}