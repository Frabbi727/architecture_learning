import 'package:architecture_learning/features/home_page/controllers/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shops'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: controller.fetchShops,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.shops.isEmpty) {
          return const Center(
            child: Text('No shops found'),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchShops,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.shops.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final shop = controller.shops[index];

              return Card(
                child: ListTile(
                  title: Text(shop.shopName ?? 'Unnamed shop'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if ((shop.marketName ?? '').isNotEmpty)
                        Text('Market: ${shop.marketName}'),
                      if ((shop.shopCode ?? '').isNotEmpty)
                        Text('Code: ${shop.shopCode}'),
                      if ((shop.ownerName ?? '').isNotEmpty)
                        Text('Owner: ${shop.ownerName}'),
                      if (shop.shopSqft != null)
                        Text('Size: ${shop.shopSqft} sqft'),
                    ],
                  ),
                  trailing: Text(shop.status ?? ''),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
