import 'package:flutter/material.dart';

class RatingDialog extends StatefulWidget {
  final double? currentRating;
  final String mediaType;
  final Function(double) onSubmit;

  const RatingDialog({
    super.key,
    required this.currentRating,
    required this.mediaType,
    required this.onSubmit,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  late double _tempRating;

  @override
  void initState() {
    super.initState();
    _tempRating = widget.currentRating ?? 5.0;
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return AlertDialog(
      backgroundColor: Colors.grey[900],
      contentPadding: isLargeScreen
          ? const EdgeInsets.all(32)
          : const EdgeInsets.all(24),
      title: Text(
        'Rate this ${widget.mediaType == 'movie' ? 'Movie' : 'TV Show'}',
        style: TextStyle(
          color: Colors.white,
          fontSize: isLargeScreen ? 20 : 18,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_tempRating.toStringAsFixed(1)}/10',
            style: TextStyle(
              color: Colors.amber,
              fontSize: isLargeScreen ? 28 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isLargeScreen ? 20 : 16),
          Slider(
            value: _tempRating,
            min: 0.5,
            max: 10.0,
            divisions: 19,
            label: _tempRating.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                _tempRating = value;
              });
            },
            activeColor: Colors.amber,
            inactiveColor: Colors.grey[600],
          ),
          SizedBox(height: isLargeScreen ? 12 : 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0.5',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isLargeScreen ? 14 : 12,
                ),
              ),
              Text(
                '10',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isLargeScreen ? 14 : 12,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.white70,
              fontSize: isLargeScreen ? 16 : 14,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onSubmit(_tempRating);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
          child: Text(
            'Submit',
            style: TextStyle(
              color: Colors.black,
              fontSize: isLargeScreen ? 16 : 14,
            ),
          ),
        ),
      ],
    );
  }
}
