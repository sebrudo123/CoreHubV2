import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../domain/entities/streaming_service.dart';
import 'streaming_card.dart';

class StreamingPage extends StatelessWidget {
  const StreamingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 10),
          child: SectionHeader(
            title: 'Streaming & Cloud',
            subtitle: 'Xbox Cloud, GeForce NOW, Moonlight y más',
            accent: AppColors.neonPink,
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(28, 8, 28, 64),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 340,
              childAspectRatio: 1.7,
              crossAxisSpacing: 18,
              mainAxisSpacing: 18,
            ),
            itemCount: StreamingService.all.length,
            itemBuilder: (BuildContext context, int index) {
              return StreamingCard(
                service: StreamingService.all[index],
                autofocus: index == 0,
              );
            },
          ),
        ),
      ],
    );
  }
}
