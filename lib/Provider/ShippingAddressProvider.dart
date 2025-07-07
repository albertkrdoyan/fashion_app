import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShippingAddress {
  final String firstName;
  final String lastName;
  final String country;
  final String stateOrRegion;
  final String city;
  final String zipCode;
  final String address;
  final String phoneNumber;

  ShippingAddress({
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.stateOrRegion,
    required this.city,
    required this.zipCode,
    required this.address,
    required this.phoneNumber,
  });
}

class ShippingAddressProvider extends Notifier<List<ShippingAddress>> {
  @override
  List<ShippingAddress> build() {
    return [
      ShippingAddress(
        firstName: "Albert",
        lastName: "Krdoyan",
        country: "Armenia",
        stateOrRegion: "Shirak",
        city: "Gyumri",
        zipCode: '3112',
        address: "Komitas str.",
        phoneNumber: "+374 (00) 00-00-00",
      ),
    ];
  }

  void add(ShippingAddress newAddress) {
    state = [...state, newAddress];
  }
}

final shippingAddressProvider =
    NotifierProvider<ShippingAddressProvider, List<ShippingAddress>>(
      () => ShippingAddressProvider(),
    );
