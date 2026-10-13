import 'package:flutter/material.dart';
import 'package:neighbour_alert/features/auth/select_residency/widgets/residency_list.dart';

/// Catálogo de residenciales disponible mientras no exista un endpoint real.
const List<ResidencyItem> mockResidencies = [
  ResidencyItem(
    name: 'Colonia La Esperanza',
    location: 'Zona 10, Guatemala',
    residentCount: 234,
    icon: Icons.location_city,
  ),
  ResidencyItem(
    name: 'Residencial Los Álamos',
    location: 'Zona 16, Guatemala',
    residentCount: 180,
    icon: Icons.apartment,
  ),
  ResidencyItem(
    name: 'Condominio Vista Hermosa',
    location: 'Zona 15, Guatemala',
    residentCount: 312,
    icon: Icons.home_work,
  ),
  ResidencyItem(
    name: 'Residencial El Encinal',
    location: 'Carretera a El Salvador',
    residentCount: 156,
    icon: Icons.villa,
  ),
  ResidencyItem(
    name: 'Torres del Campo',
    location: 'Zona 14, Guatemala',
    residentCount: 420,
    icon: Icons.domain,
  ),
  ResidencyItem(
    name: 'Colonia San Cristóbal',
    location: 'Mixco, Guatemala',
    residentCount: 98,
    icon: Icons.holiday_village,
  ),
];
