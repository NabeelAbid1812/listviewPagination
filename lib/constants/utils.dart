import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginatet_list/constants/colors.dart';

class Utils{
   static showSnackBar(
      {required String title, required String message, required bool error}) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Icons.info,color:Colors.black,),
      colorText:Colors.black,
      backgroundColor: error ? Colors.grey[300]:AppColors.AmatureColor,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

}