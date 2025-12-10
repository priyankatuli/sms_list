
//enum value lowerCamelCase hoy
enum ProviderType{
  bKash,
  nagad,
  rocket,
  krishibank,
  upay
}
//extension use to display text name exactly
extension ProviderTypeExt on ProviderType{
  String get displayName{
    switch(this){
      case ProviderType.bKash:
        return "bKash";
      case ProviderType.nagad:
        return "Nagad";
      case ProviderType.rocket:
        return "Rocket";
      case ProviderType.krishibank:
        return "Krishi Bank";
      case ProviderType.upay:
        return "Upay";
    }
  }
}