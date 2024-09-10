import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LoadingWidget extends StatelessWidget {
  final int? height ;
  const LoadingWidget({
    super.key,this.height=80,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height:height?.h, child: const Center(child: CircularProgressIndicator()),);
  }
}