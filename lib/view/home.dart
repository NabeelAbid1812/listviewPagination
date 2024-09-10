import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:paginatet_list/constants/colors.dart';
import 'package:paginatet_list/constants/loadingWidget.dart';
import 'package:paginatet_list/constants/textstyle.dart';
import 'package:paginatet_list/controller/homeController.dart';
import 'package:sizer/sizer.dart';

class HomeClass extends StatefulWidget {
  const HomeClass({super.key});

  @override
  State<HomeClass> createState() => _HomeClassState();
}

class _HomeClassState extends State<HomeClass> {
  TransactionController controller = Get.put(TransactionController());

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    print(controller.currentPage);
    print(controller.lastPage);

  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
   
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
    

      if (!controller.ispageLoading.value) {
       

        controller.getHistoryPage();
      }
    }
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ListView"),centerTitle: true,),
      body:  Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            
            controller.isLoadinghistory.value ? const LoadingWidget(height: 80,) :
            controller.history.isEmpty ?
            SizedBox(height: 80.h,width: 100.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Data Found"),
                  InkWell(
                    onTap: () {
                      controller.getHistory();
                    },
                    child: Icon(Icons.refresh))
                ],
              )) :
    
                Flexible(
                  child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: controller.history.length,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
    
                      itemBuilder: (BuildContext context, index) {
                       
                        final history = controller.history[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.0.w, vertical: 1.h),
                          child: Row(
                            children: [
                              SizedBox(width: 6.w,
                              child: Text(history.id.toString()),
                              ),
                              SizedBox(
                                width: 80.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    
                                    Text(
                                      history.title??"",
                                      style: AppTextStyles.inter18.copyWith(color: Colors.black)
                                         ,overflow: TextOverflow.ellipsis,),
                                    Text(
                                     history.body??"",
                                      style: AppTextStyles.inter12.copyWith(color: Colors.black),overflow: TextOverflow.ellipsis,
                                        
                                           
                                                                                      ),
                                    const Divider(),
                                  
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  ),
                ),
                if(controller.ispageLoading.value)
                  LoadingWidget(height: 5,),
                SizedBox(height: 2.h,)
            //   ],
            // )
    
    
          ],
        );
      }
      ),
    );
  }
}