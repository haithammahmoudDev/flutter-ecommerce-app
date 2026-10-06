import 'package:fit_store/features/home/presentation/screens/product_reviews/widgets/rating_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverallProductRating extends StatelessWidget {
  const OverallProductRating({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Expanded(flex: 3, child: Text('4.8', style: Theme.of(context).textTheme.displayLarge)),
        Expanded(
          flex: 7,
          child: Column(
            children: [
              RatingProgressIndicator(text: '5',value: .5),
              RatingProgressIndicator(text: '4',value: .5),
              RatingProgressIndicator(text: '3',value: .5),
              RatingProgressIndicator(text: '2',value: .5),
              RatingProgressIndicator(text: '1',value: .5),
            ],
          ),
        ),
      ],
    );
  }
}
