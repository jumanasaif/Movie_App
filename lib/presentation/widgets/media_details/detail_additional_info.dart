import 'package:flutter/material.dart';
import 'package:movie_app/data/models/media_details_model.dart';

class DetailAdditionalInfo extends StatelessWidget {
  final MovieDetails details;

  const DetailAdditionalInfo({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Info',
          style: TextStyle(
            color: Colors.white,
            fontSize: _getTitleSize(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: isLargeScreen ? 16 : 12),

        // Genres
        if (details.genres.isNotEmpty) ...[
          Wrap(
            spacing: _getSpacing(context),
            runSpacing: _getSpacing(context),
            children: details.genres.map((genre) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _getChipPadding(context),
                  vertical: _getChipPadding(context) / 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber),
                ),
                child: Text(
                  genre.name,
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: _getChipTextSize(context),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: isLargeScreen ? 20 : 16),
        ],

        // Additional Info
        Wrap(
          spacing: _getChipSpacing(context),
          runSpacing: _getChipSpacing(context) / 2,
          children: [
            if (details.status?.isNotEmpty == true)
              _buildInfoChip(context, Icons.info, 'Status', details.status!),
            if (details.budget != null && details.budget! > 0)
              _buildInfoChip(
                context,
                Icons.attach_money,
                'Budget',
                '\$${_formatNumber(details.budget!)}',
              ),
            if (details.revenue != null && details.revenue! > 0)
              _buildInfoChip(
                context,
                Icons.monetization_on,
                'Revenue',
                '\$${_formatNumber(details.revenue!)}',
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLargeScreen ? 16 : 12,
        vertical: isLargeScreen ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.amber, size: _getIconSize(context)),
          SizedBox(width: isLargeScreen ? 8 : 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: _getLabelSize(context),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: _getValueSize(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  double _getTitleSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 24;
    if (width > 800) return 22;
    if (width > 600) return 20;
    return 18;
  }

  double _getSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 12;
    return 8;
  }

  double _getChipPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 16;
    return 12;
  }

  double _getChipTextSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 14;
    return 12;
  }

  double _getChipSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 20;
    return 16;
  }

  double _getIconSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 18;
    return 16;
  }

  double _getLabelSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 13;
    return 12;
  }

  double _getValueSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 600) return 15;
    return 14;
  }
}
