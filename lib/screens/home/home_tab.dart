import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../services/geocoding_service.dart';
import '../../services/location_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/action_card.dart';
import '../../widgets/app_map.dart';
import '../../widgets/aster_mark.dart';
import '../chatbot/chatbot_screen.dart';
import '../contacts/contacts_screen.dart';
import '../fake_call/fake_call_screen.dart';
import '../nearby_help/nearby_help_screen.dart';
import '../report/report_screen.dart';
import '../safe_route/safe_route_screen.dart';
import '../sos/sos_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key, required this.onShareLocation});

  final VoidCallback onShareLocation;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  LatLng? _location;
  String? _address;
  StreamSubscription<Position>? _locationStream;
  DateTime? _lastGeocodeAt;

  @override
  void initState() {
    super.initState();
    LocationService.getCurrentLocation().then((loc) {
      if (mounted) setState(() => _location = loc);
      if (loc != null) _maybeReverseGeocode(loc);
    });
    _startLocationStream();
  }

  void _startLocationStream() {
    _locationStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 40,
          ),
        ).listen((pos) {
          final loc = LatLng(pos.latitude, pos.longitude);
          if (mounted) setState(() => _location = loc);
          _maybeReverseGeocode(loc);
        }, onError: (_) {});
  }

  void _maybeReverseGeocode(LatLng loc) {
    final now = DateTime.now();
    if (_lastGeocodeAt != null &&
        now.difference(_lastGeocodeAt!) < const Duration(seconds: 20)) {
      return;
    }
    _lastGeocodeAt = now;
    GeocodingService.reverse(loc).then((address) {
      if (mounted && address != null) setState(() => _address = address);
    });
  }

  @override
  void dispose() {
    _locationStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 112),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AsterMark(size: 44),
                  const SizedBox(width: 11),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ASTER',
                        style: AppTextStyles.calloutBold.copyWith(
                          fontSize: 16,
                          letterSpacing: 2.2,
                          color: AppColors.primaryGrey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'YOUR SAFETY COMPANION',
                        style: AppTextStyles.b5.copyWith(
                          color: AppColors.neutral900,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 27),
              Text(
                'A little more peace of mind.',
                style: AppTextStyles.b3.copyWith(color: AppColors.neutral900),
              ),
              const SizedBox(height: 5),
              Text(
                'Feel safer,\nwherever you go.',
                style: AppTextStyles.h5.copyWith(
                  fontSize: 31,
                  height: 1.12,
                  color: AppColors.primaryGrey,
                ),
              ),
              const SizedBox(height: 20),
              _SosCard(
                onTap: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const SosScreen())),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Your location',
                      style: AppTextStyles.calloutBold.copyWith(
                        fontSize: 18,
                        color: AppColors.primaryGrey,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.my_location_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'LIVE',
                    style: AppTextStyles.b5.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.9,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.neutral200),
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.r5),
                      child: AspectRatio(
                        aspectRatio: 1.78,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: _location == null
                              ? const Center(
                                  key: ValueKey('loading'),
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                )
                              : AppMap(
                                  key: const ValueKey('map'),
                                  center: _location!,
                                  zoom: 15,
                                  interactive: false,
                                  markers: [youAreHereMarker(_location!)],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _address ?? 'Finding your location…',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.b3.copyWith(
                              color: AppColors.primaryGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: widget.onShareLocation,
                          icon: const Icon(Icons.near_me_outlined, size: 17),
                          label: const Text('Share'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 27),
              Text(
                'Quick access',
                style: AppTextStyles.calloutBold.copyWith(
                  fontSize: 18,
                  color: AppColors.primaryGrey,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.18,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ActionCard(
                    icon: Icons.people_alt_outlined,
                    title: 'Trusted people',
                    subtitle: 'Your emergency contacts',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ContactsScreen()),
                    ),
                  ),
                  ActionCard(
                    icon: Icons.phone_in_talk_outlined,
                    title: 'Fake call',
                    subtitle: 'A reason to step away',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const FakeCallScreen()),
                    ),
                  ),
                  ActionCard(
                    icon: Icons.local_hospital_outlined,
                    title: 'Nearby help',
                    subtitle: 'Find help around you',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const NearbyHelpScreen(),
                      ),
                    ),
                  ),
                  ActionCard(
                    icon: Icons.alt_route_rounded,
                    title: 'Safer route',
                    subtitle: 'Plan a safer journey',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SafeRouteScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.r12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ReportScreen()),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Report an incident',
                                style: AppTextStyles.calloutBold.copyWith(
                                  color: AppColors.primaryGrey,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Document what happened securely',
                                style: AppTextStyles.b4.copyWith(
                                  color: AppColors.neutral900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 6,
          bottom: 104,
          child: _ChatFab(
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ChatbotScreen())),
          ),
        ),
      ],
    );
  }
}

class _SosCard extends StatelessWidget {
  const _SosCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryGrey,
      borderRadius: BorderRadius.circular(AppRadius.r12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Positioned(
              right: -34,
              top: -42,
              child: Container(
                width: 148,
                height: 148,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 22,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: AppColors.accent,
                        size: 18,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'HERE WHEN YOU NEED IT',
                        style: AppTextStyles.b5.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Get help,\nwithout the wait.',
                    style: AppTextStyles.h5.copyWith(
                      fontSize: 24,
                      height: 1.14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 17),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.danger,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.sos_rounded,
                          color: Colors.white,
                          size: 21,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Open emergency SOS',
                          style: AppTextStyles.b3.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 17,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    'Alerts your trusted people',
                    style: AppTextStyles.b4.copyWith(
                      color: Colors.white.withValues(alpha: 0.72),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatFab extends StatelessWidget {
  const _ChatFab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryGrey,
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(14),
          child: Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.accent,
            size: 22,
          ),
        ),
      ),
    );
  }
}
