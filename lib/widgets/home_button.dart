import 'package:flutter/material.dart';
import 'package:gestion_stock/models/user.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/transaction_view_model.dart';
import 'package:gestion_stock/widgets/toast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import '../models/access.dart';

class HomeButton extends StatelessWidget{
  String? imagePath;
  String? title;
  Widget? destination;
  User? user;
  List<Access>? accessList;
  int? count;
  String? trs;
  String? res;

  HomeButton({super.key, required this.title, required this.imagePath, required this.destination, required this.user, required this.accessList, required this.count, required this.trs, required this.res});
  final NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 2
  );

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    if(title == 'Caisse'){
      return Consumer<TransactionViewModel>(
        builder: (context, provider, child){
          return Expanded(
            child: TextButton(
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
                padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              ),
              onPressed: (){
                if(verifyAccess()){
                  authProvider.selectedExercice = authProvider.exercices!.firstWhere((element) => element == authProvider.initialExercice);
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => destination!));
                }else{
                  Toast(context: context, title: 'Aucun accés au $title', style: ToastificationStyle.minimal, type: ToastificationType.warning);
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: width * 0.02),
                padding: EdgeInsets.all(width * 0.045),
                //height: width * 0.45,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    //color: Colors.white
                    color: Colors.white
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(imagePath!, width: width * 0.18, height: width * 0.18,),
                        Text(title!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.05, color: Colors.black),)
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: width * 0.045, right: width * 0.045,),
                      decoration: const BoxDecoration(
                          border: Border(left: BorderSide(color: Colors.grey))
                      ),
                    ),
                    Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Aujourd'hui: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.045, color: Colors.black),),
                            Row(
                              children: [
                                const Icon(Icons.arrow_upward_sharp, color: Colors.green),
                                Text(' ${formatter.format(provider.totalDebitToday ?? 0)} DA', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: width * 0.04),)
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.arrow_downward_sharp, color: Colors.red),
                                Text(' ${formatter.format(provider.totalCreditToday ?? 0)} DA', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: width * 0.04),)
                              ],
                            ),
                            Text('Total: ${formatter.format(provider.totalDebitToday - provider.totalCreditToday)} DA', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).secondaryHeaderColor, fontSize: width * 0.04),),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          );
        },
      );
    }else{
      return TextButton(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        ),
        onPressed: (){
            if(verifyAccess()){
              authProvider.selectedExercice = authProvider.exercices!.firstWhere((element) => element == authProvider.initialExercice);
              Navigator.push(context, MaterialPageRoute(builder: (builder) => destination!));
            }else{
              Toast(context: context, title: 'Aucun accés au $title', style: ToastificationStyle.minimal, type: ToastificationType.warning);
            }
        },
        child: Container(
          margin: EdgeInsets.only(top: width * 0.02),
          padding: EdgeInsets.all(width * 0.045),
          width: width * 0.47,
          //height: width * 0.47,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(imagePath!, width: width * 0.18, height: width * 0.18,),
              Text(title!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.05, color: Colors.black),)
            ],
          ),
        ),
      );
    }
  }

  bool verifyAccess(){
    if(user!.USRTYPE == 0){
      if(accessList!.where((element) => element.URSTRS == trs && element.URSRES == res && element.URSDRO == '01').length == 1){
        return true;
      }else{
        return false;
      }
    }else if(user!.USRTYPE == 1){
      if(accessList!.where((element) => element.URSTRS == trs && element.URSRES == res && element.URSDRO == '01').isEmpty){
        return true;
      }else{
        return false;
      }
    }else{
      return true;
    }
  }

}
