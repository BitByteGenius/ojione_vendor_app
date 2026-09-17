import '../../../shared/enums/service_type.dart';
import '../../../shared/enums/vendor_status.dart';

class MockVendorProfile {
  final String id;
  final String businessName;
  final String ownerName;
  final String email;
  final String phone;
  final String aadhaarNumber;
  final String city;
  final String state;
  final String pincode;
  final String address;
  final List<ServiceType> services;
  final ServiceType activeService;
  final VendorVerificationStatus verificationStatus;
  final VendorStatus accountStatus;
  final String label;

  const MockVendorProfile({
    required this.id,
    required this.businessName,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.aadhaarNumber,
    required this.city,
    required this.state,
    required this.pincode,
    required this.address,
    required this.services,
    required this.activeService,
    this.verificationStatus = VendorVerificationStatus.verified,
    this.accountStatus = VendorStatus.approved,
    required this.label,
  });
}

class MockVendorProfiles {
  MockVendorProfiles._();

  static const MockVendorProfile vendorA = MockVendorProfile(
    id: 'VEN-DEMO-A',
    businessName: 'Kaziranga Eco-Stay & Car Rentals',
    ownerName: 'Gunajit Sharma',
    email: 'gunajit@kazirangastay.in',
    phone: '+91 98765 43210',
    aadhaarNumber: '7890 1234 5678',
    city: 'Kaziranga',
    state: 'Assam',
    pincode: '785609',
    address: 'Kohora Range, NH-37, Kaziranga',
    services: [ServiceType.stay, ServiceType.rental],
    activeService: ServiceType.stay,
    label: 'Vendor A: Stay + Vehicle Rental',
  );

  static const MockVendorProfile vendorB = MockVendorProfile(
    id: 'VEN-DEMO-B',
    businessName: 'Pragjyotish Assam Silk & Craft Store',
    ownerName: 'Ananya Goswami',
    email: 'ananya@pragjyotishcrafts.com',
    phone: '+91 94350 11223',
    aadhaarNumber: '4521 8890 2341',
    city: 'Guwahati',
    state: 'Assam',
    pincode: '781003',
    address: 'Shop 14, Panbazar Market Complex, Guwahati',
    services: [ServiceType.shop],
    activeService: ServiceType.shop,
    label: 'Vendor B: Shop Only (Indigenous Crafts)',
  );

  static const MockVendorProfile vendorC = MockVendorProfile(
    id: 'VEN-DEMO-C',
    businessName: 'Brahmaputra Expeditions & Cultural Walks',
    ownerName: 'Bikramjit Saikia',
    email: 'bikram@brahmaputraexpeditions.in',
    phone: '+91 91270 55667',
    aadhaarNumber: '3344 7788 9900',
    city: 'Jorhat',
    state: 'Assam',
    pincode: '785001',
    address: 'Gar-Ali Heritage Lane, Jorhat',
    services: [ServiceType.trips, ServiceType.localExperiences],
    activeService: ServiceType.trips,
    label: 'Vendor C: Tours & Trips + Local Experiences',
  );

  static const MockVendorProfile vendorD = MockVendorProfile(
    id: 'VEN-DEMO-D',
    businessName: 'Kaziranga Cultural Eco-Resort & Craft Village',
    ownerName: 'Priyanka Borah',
    email: 'priyanka@kazirangaecoresort.com',
    phone: '+91 94351 99887',
    aadhaarNumber: '8899 4433 2211',
    city: 'Kaziranga',
    state: 'Assam',
    pincode: '785609',
    address: 'Central Range, Kohora, Kaziranga',
    services: [ServiceType.stay, ServiceType.shop, ServiceType.localExperiences],
    activeService: ServiceType.stay,
    label: 'Vendor D: Stay + Shop + Local Experiences',
  );

  static const List<MockVendorProfile> allProfiles = [
    vendorA,
    vendorB,
    vendorC,
    vendorD,
  ];
}
