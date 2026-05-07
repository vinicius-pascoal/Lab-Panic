import 'package:flutter/material.dart';
import '../../config/enums.dart';
import 'bin_panel.dart';

class BottomBins extends StatelessWidget {
  const BottomBins({
    required this.boardWidth,
    required this.boardHeight,
    required this.binZoneHeight,
  });

  final double boardWidth;
  final double boardHeight;
  final double binZoneHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: binZoneHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: ShapeType.values
                .map(
                  (shape) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: BinPanel(shape: shape),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
