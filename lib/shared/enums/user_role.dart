enum UserRole {
  vendor('Vendor', 'Full ownership of vendor account and assigned services'),
  vendorManager('Vendor Manager', 'Can manage listings, inventory, and bookings'),
  vendorStaff('Vendor Staff', 'Can view bookings and update check-in/execution statuses');

  final String label;
  final String description;

  const UserRole(this.label, this.description);

  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'vendormanager':
      case 'vendor_manager':
      case 'manager':
        return UserRole.vendorManager;
      case 'vendorstaff':
      case 'vendor_staff':
      case 'staff':
        return UserRole.vendorStaff;
      case 'vendor':
      case 'owner':
      default:
        return UserRole.vendor;
    }
  }
}
