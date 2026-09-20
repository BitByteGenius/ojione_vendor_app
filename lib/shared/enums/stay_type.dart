import 'package:flutter/material.dart';

enum StayType {
  room,
  flat,
  pg,
  hostel,
  homestay;

  String get id => name;

  String get displayName {
    switch (this) {
      case StayType.room:
        return 'Private Room';
      case StayType.flat:
        return 'Apartment / Flat';
      case StayType.pg:
        return 'Paying Guest (PG)';
      case StayType.hostel:
        return 'Hostel / Dorm';
      case StayType.homestay:
        return 'Homestay & Villa';
    }
  }

  String get shortLabel {
    switch (this) {
      case StayType.room:
        return 'Room';
      case StayType.flat:
        return 'Flat / Apt';
      case StayType.pg:
        return 'PG';
      case StayType.hostel:
        return 'Hostel';
      case StayType.homestay:
        return 'Homestay';
    }
  }

  IconData get icon {
    switch (this) {
      case StayType.room:
        return Icons.bedroom_parent_outlined;
      case StayType.flat:
        return Icons.apartment_rounded;
      case StayType.pg:
        return Icons.people_outline_rounded;
      case StayType.hostel:
        return Icons.single_bed_rounded;
      case StayType.homestay:
        return Icons.villa_outlined;
    }
  }

  String get description {
    switch (this) {
      case StayType.room:
        return 'Individual private room in a house or building';
      case StayType.flat:
        return 'Self-contained 1BHK, 2BHK, 3BHK flat or apartment';
      case StayType.pg:
        return 'Co-living or managed accommodation with meals & rules';
      case StayType.hostel:
        return 'Shared dormitory or private bunk beds for travelers';
      case StayType.homestay:
        return 'Cozy regional homestay or holiday villa with local host';
    }
  }

  static StayType fromString(String value) {
    final clean = value.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    for (final type in StayType.values) {
      if (clean.contains(type.name)) {
        return type;
      }
    }
    return StayType.homestay;
  }
}
