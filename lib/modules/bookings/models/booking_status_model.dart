enum BookingStatus {
  confirmed('Confirmed'),
  pending('Pending'),
  checkedIn('Checked In / In Progress'),
  completed('Completed'),
  cancelled('Cancelled');

  final String label;
  const BookingStatus(this.label);

  static BookingStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'pending':
        return BookingStatus.pending;
      case 'checkedin':
      case 'in_progress':
      case 'ongoing':
        return BookingStatus.checkedIn;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
      default:
        return BookingStatus.cancelled;
    }
  }
}
