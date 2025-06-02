import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/advertise_model.dart';
import 'package:mobile_app/services/ApiService.dart';
import 'package:mobile_app/services/advertise_service.dart';

class AdvertiseComponent extends StatelessWidget {
  const AdvertiseComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AdvertiseModel>>(
      future: AdvertiseService.fetchAdvertisements(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const SizedBox.shrink();
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final ad = snapshot.data![Random().nextInt(snapshot.data!.length)];
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            children: [
              ad.imageAds.isNotEmpty
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      '${ApiService.imageBaseUrl}${ad.imageAds}',
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Icon(Icons.error, size: 150),
                    ),
                  )
                  : Icon(Icons.image_not_supported, size: 150),

              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.all(8),
                  constraints: BoxConstraints(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
