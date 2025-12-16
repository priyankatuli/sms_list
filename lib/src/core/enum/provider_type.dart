//enum value - lowerCamelCase
enum ProviderType{
  bKash,
  nagad,
  rocket,
  krishibank,
  upay,
  primebank,
  onebank,
  bracbank
}
//use extension to display text name exactly
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
      case ProviderType.primebank:
        return "Prime Bank";
      case ProviderType.onebank:
         return "One Bank";
      case ProviderType.bracbank:
        return "Brac Bank";
    }
  }
}