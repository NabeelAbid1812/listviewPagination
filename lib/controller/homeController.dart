import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:paginatet_list/constants/utils.dart';
import 'package:paginatet_list/model/historyModel.dart';

import '../managers/api_provider.dart';

class TransactionController extends GetxController {
 int currentPage = 1;
  bool isFetching = false;
  int lastPage = 0;
  RxBool ispageLoading = false.obs;
    RxBool isLoadinghistory = false.obs;
  List<historyModel> history = [];

 
  @override
  void onInit() async {
    super.onInit();

   getHistory();
  }

   Future<void> getHistoryPage() async {
    if (isFetching) {
      return; // Don't fetch if already fetching
    }

    ispageLoading.value = true;
    update();
    // history.clear();


   
    var resp;

    try {
      isFetching = true;
      resp =
      await APIProvider().get("https://jsonplaceholder.typicode.com/posts?_page=$currentPage&_limit=10", false, Get.context);
      isFetching = false;
    }catch (e) {
      isFetching = false;
      print("Error during API call: $e");
    }

      ispageLoading.value = false;
      update();
      try {
        final List<dynamic>? historyList = resp;

        if (historyList != null) {
          history.addAll(historyList.map<historyModel>((e) => historyModel.fromJson(e)));
        }

       
        print(lastPage);
        currentPage++;
      }catch(e){
        // Handle other cases if needed
        print("Unexpected response: $resp");
      }
    }
     Future<void> getHistory() async {
    isLoadinghistory.value = true;
    history.clear();
    update();
  
    try {
      final resp =
      await APIProvider().get("https://jsonplaceholder.typicode.com/posts?_page=$currentPage&_limit=10", false, Get.context);
      print("idr aya");
      print(resp.toString());
      try{
      

        history.addAll(resp
            .map<historyModel>((e) => historyModel.fromJson(e)));
      
      }  catch(e){
        Utils.showSnackBar( title: "Info",message: "try-again".tr,error: true, );
      }
    } catch (e) {
      // Get.log('[TransactionController.historyList] called $e');
    } finally {
      isLoadinghistory.value = false;
      update();
    }
  }
}