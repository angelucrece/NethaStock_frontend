import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Effet de scintillement (shimmer) pour le chargement
class LoadingShimmer extends StatelessWidget {
  final int itemCount;

  const LoadingShimmer({Key? key, this.itemCount = 6}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shimmer pour le header
            _buildHeaderShimmer(),
            SizedBox(height: 24),

            // Shimmer pour les stats
            _buildStatsShimmer(),
            SizedBox(height: 24),

            // Shimmer pour la grille
            _buildGridShimmer(),
            SizedBox(height: 24),

            // Shimmer pour les mouvements
            _buildMovementsShimmer(),
            SizedBox(height: 24),

            // Shimmer pour les alertes
            _buildAlertsShimmer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderShimmer() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 20,
                color: Colors.white,
              ),
              SizedBox(height: 8),
              Container(
                width: 150,
                height: 16,
                color: Colors.white,
              ),
            ],
          ),
        ),
        Container(
          width: 80,
          height: 30,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildStatsShimmer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) => _buildStatItemShimmer()),
      ),
    );
  }

  Widget _buildStatItemShimmer() {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 30,
          height: 16,
          color: Colors.white,
        ),
        SizedBox(height: 4),
        Container(
          width: 40,
          height: 12,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildGridShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              color: Colors.white,
            ),
            SizedBox(height: 12),
            Container(
              width: 40,
              height: 20,
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Container(
              width: 60,
              height: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovementsShimmer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 20,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Column(
            children: List.generate(3, (index) => _buildMovementItemShimmer()),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementItemShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.white,
                ),
                SizedBox(height: 4),
                Container(
                  width: 100,
                  height: 12,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 24,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsShimmer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 20,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Column(
            children: List.generate(2, (index) => _buildAlertItemShimmer()),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItemShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.white,
                ),
                SizedBox(height: 4),
                Container(
                  width: 80,
                  height: 12,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}