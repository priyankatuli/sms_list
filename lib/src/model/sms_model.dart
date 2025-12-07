class SmsModel{

  final String address;
  final String body;
  final DateTime date;

  SmsModel({required this.address, required this.body,required this.date});

  factory SmsModel.fromJson(Map<String,dynamic>json){
    return SmsModel(
      address: json["address"] ?? "",
      body: json["body"] ?? "",
      date: DateTime.fromMillisecondsSinceEpoch(
        int.parse(json["date"]),
    ),
    );
  }





}