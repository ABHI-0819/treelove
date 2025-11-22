enum InquiryType {
  plantation,
  maintenance,
  monitoring,
  mixed,
}

extension InquiryTypeExtension on InquiryType {
  String get value => name;
}