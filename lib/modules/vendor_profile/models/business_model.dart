class BusinessModel {
  final String registrationNumber;
  final String gstin;
  final String panNumber;
  final String businessType;
  final String registeredAddress;
  final String city;
  final String state;
  final String pincode;
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String accountHolderName;

  BusinessModel({
    required this.registrationNumber,
    required this.gstin,
    required this.panNumber,
    required this.businessType,
    required this.registeredAddress,
    required this.city,
    required this.state,
    required this.pincode,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.accountHolderName,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      registrationNumber: json['registration_number'] ?? '',
      gstin: json['gstin'] ?? '',
      panNumber: json['pan_number'] ?? '',
      businessType: json['business_type'] ?? 'Private Limited',
      registeredAddress: json['registered_address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      bankName: json['bank_name'] ?? '',
      accountNumber: json['account_number'] ?? '',
      ifscCode: json['ifsc_code'] ?? '',
      accountHolderName: json['account_holder_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'registration_number': registrationNumber,
      'gstin': gstin,
      'pan_number': panNumber,
      'business_type': businessType,
      'registered_address': registeredAddress,
      'city': city,
      'state': state,
      'pincode': pincode,
      'bank_name': bankName,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'account_holder_name': accountHolderName,
    };
  }
}
