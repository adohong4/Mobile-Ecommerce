import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/advertise_model.dart';
import 'package:mobile_app/services/ApiService.dart';
import 'package:mobile_app/services/advertise_service.dart';

class BannerComponent extends StatefulWidget {
  const BannerComponent({super.key});

  @override
  _BannerComponentState createState() => _BannerComponentState();
}

class _BannerComponentState extends State<BannerComponent> {
  final PageController _bannerController = PageController(
    viewportFraction: 0.9,
  );
  int _bannerPage = 0;
  late Future<List<AdvertiseModel>> _bannersFuture;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _bannersFuture = AdvertiseService.fetchBanners();

    // Tự động cuộn banner
    _timer = Timer.periodic(Duration(seconds: 6), (timer) {
      if (_bannerController.hasClients) {
        _bannersFuture.then((banners) {
          if (banners.isNotEmpty) {
            int nextPage = (_bannerPage + 1) % banners.length;
            _bannerController.animateToPage(
              nextPage,
              duration: Duration(milliseconds: 1000),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.only(bottom: 10),
      child: FutureBuilder<List<AdvertiseModel>>(
        future: _bannersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No banners available'));
          }

          final banners = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _bannerController,
                  itemCount: banners.length,
                  onPageChanged: (index) {
                    setState(() {
                      _bannerPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(
                            '${ApiService.imageBaseUrl}${banners[index].imageAds}',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  banners.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _bannerPage == index ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
