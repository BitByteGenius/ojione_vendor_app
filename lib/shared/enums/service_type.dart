import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum ServiceType {
  stay,
  trips,
  shop,
  rental,
  localExperiences;

  String get id {
    switch (this) {
      case ServiceType.stay:
        return 'stay';
      case ServiceType.trips:
        return 'trips';
      case ServiceType.shop:
        return 'shop';
      case ServiceType.rental:
        return 'rental';
      case ServiceType.localExperiences:
        return 'local_experiences';
    }
  }

  String get displayName {
    switch (this) {
      case ServiceType.stay:
        return 'Stay';
      case ServiceType.trips:
        return 'Tours & Trips';
      case ServiceType.shop:
        return 'Shop';
      case ServiceType.rental:
        return 'Vehicle Rental';
      case ServiceType.localExperiences:
        return 'Local Experiences';
    }
  }

  String get description {
    switch (this) {
      case ServiceType.stay:
        return 'Hotels, homestays, resorts, and rooms';
      case ServiceType.trips:
        return 'Tour packages, itineraries, and sightseeing';
      case ServiceType.shop:
        return 'Handicrafts, state-wise native specialty goods';
      case ServiceType.rental:
        return 'Cars, bikes, self-drive, and chauffeur services';
      case ServiceType.localExperiences:
        return 'Workshops, village tours, cooking & cultural walks';
    }
  }

  IconData get icon {
    switch (this) {
      case ServiceType.stay:
        return Icons.hotel_rounded;
      case ServiceType.trips:
        return Icons.hiking_rounded;
      case ServiceType.shop:
        return Icons.storefront_rounded;
      case ServiceType.rental:
        return Icons.directions_car_rounded;
      case ServiceType.localExperiences:
        return Icons.local_activity_rounded;
    }
  }

  Color get color {
    switch (this) {
      case ServiceType.stay:
        return AppColors.stayService;
      case ServiceType.trips:
        return AppColors.tripsService;
      case ServiceType.shop:
        return AppColors.shopService;
      case ServiceType.rental:
        return AppColors.rentalService;
      case ServiceType.localExperiences:
        return AppColors.localExpService;
    }
  }

  Color get bgColor {
    switch (this) {
      case ServiceType.stay:
        return AppColors.stayServiceBg;
      case ServiceType.trips:
        return AppColors.tripsServiceBg;
      case ServiceType.shop:
        return AppColors.shopServiceBg;
      case ServiceType.rental:
        return AppColors.rentalServiceBg;
      case ServiceType.localExperiences:
        return AppColors.localExpServiceBg;
    }
  }

  String get routePath {
    switch (this) {
      case ServiceType.stay:
        return '/stay';
      case ServiceType.trips:
        return '/trips';
      case ServiceType.shop:
        return '/shop';
      case ServiceType.rental:
        return '/rental';
      case ServiceType.localExperiences:
        return '/experiences';
    }
  }

  static ServiceType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'stay':
        return ServiceType.stay;
      case 'trips':
      case 'tours_and_trips':
        return ServiceType.trips;
      case 'shop':
        return ServiceType.shop;
      case 'rental':
      case 'vehicle_rental':
        return ServiceType.rental;
      case 'local_experiences':
      case 'experiences':
        return ServiceType.localExperiences;
      default:
        return ServiceType.stay;
    }
  }
}
