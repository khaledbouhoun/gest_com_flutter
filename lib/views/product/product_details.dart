import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/product_view_model.dart';
import 'package:gestion_stock/views/product/bars_code.dart';
import 'package:gestion_stock/views/product/modify_product.dart';
import 'package:gestion_stock/widgets/detail_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../models/product.dart';
import '../../widgets/toast.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var provider = Provider.of<ProductViewModel>(context, listen: false);
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");
    List details = [
      {'Désignation': provider.selectedProduct!.ARTNOM},
      {'Désignation supplimentaire': provider.selectedProduct!.ARTNOMSUP ?? '/'},
      {'Referance': provider.selectedProduct!.ARTREF},
      {'Prix': '${formatter.format(provider.selectedProduct!.ARTPRIX)} DA'},
      {'Code-Barres': provider.selectedProduct!.ARTCAB},
      {'Famille': provider.families!.firstWhere((element) => element.FAMNO == provider.selectedProduct!.ARTFAM).FAMNOM},
      {
        'Sous famille': provider.subfamilies!
            .firstWhere((element) =>
                element.SOUFAM == provider.selectedProduct!.ARTFAM &&
                element.SOUNO == provider.selectedProduct!.ARTSFAM)
            .SOUNOM
      },
      {'Marque': provider.brands!.firstWhere((element) => element.MRQNO == provider.selectedProduct!.ARTMARQUE).MRQNOM},
      {'Unité': provider.units!.firstWhere((element) => element.UNINO == provider.selectedProduct!.ARTUNI).UNINOM},
      {
        'Colisage':
            provider.packages!.firstWhere((element) => element.COLNO == provider.selectedProduct!.ARTCOLIS).COLNOM
      },
      {'Unité par colis': provider.selectedProduct!.ARTUNTCOL.toString()},
      {'Longeur': '${provider.selectedProduct!.ARTLONG} m'},
      {'Largeur': '${provider.selectedProduct!.ARTLARG} m'},
      {'Poids': '${provider.selectedProduct!.ARTPOIDS} kg'},
      {'Volume': '${provider.selectedProduct!.ARTVOLUME} m\u00b3'},
      {
        'Quantité (par ${Provider.of<AuthViewModel>(context, listen: false).selectedExercice!.EXENO})':
            formatter.format(provider.selectedProduct!.ARTQTETHEOR!).toString()
      },
      // par depots
      ...provider.selectedProduct!.depots.map((depot) => {'Quantité (${depot.depot})': formatter.format(depot.qte)}),
      {'Quantité minimum': formatter.format(provider.selectedProduct!.ARTQTEMIN)},
      {'Quantité maximum': formatter.format(provider.selectedProduct!.ARTQTEMAX)},
      {"Stock d'alarte": formatter.format(provider.selectedProduct!.ARTALERTE)},
    ];

    return Consumer<ProductViewModel>(builder: (context, provider, child) {
      return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return false;
          },
          child: Scaffold(
            backgroundColor: const Color(0xFFF4F9FC),
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              scrolledUnderElevation: 0,
              elevation: 0,
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
              ),
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                  onPressed: () {
                    if (verifyAccess(context)) {
                      Map<String, dynamic> json = provider.selectedProduct!.toJson();
                      provider.modifiedProduct = Product.modified(json);
                      provider.notifyListeners();
                      Navigator.push(context, MaterialPageRoute(builder: (builder) => const ModifyProduct()));
                    } else {
                      Toast(
                          context: context,
                          title: 'Pas de permission pour Modifier un article',
                          style: ToastificationStyle.minimal,
                          type: ToastificationType.warning);
                    }
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                  ),
                ),
                // IconButton(
                //   onPressed: () {},
                //   icon: Container(
                //     padding: const EdgeInsets.all(8),
                //     decoration: BoxDecoration(
                //       color: Colors.white.withOpacity(0.2),
                //       shape: BoxShape.circle,
                //     ),
                //     child: const Icon(Icons.delete_rounded,
                //         color: Colors.white, size: 20),
                //   ),
                // ),
                const SizedBox(width: 8),
              ],
            ),
            body: SafeArea(
              top: false,
              child: Column(
                children: [
                  Container(
                    width: width,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 20,
                      bottom: 30,
                      left: 20,
                      right: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).secondaryHeaderColor,
                          Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          provider.selectedProduct!.ARTNOM!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.055,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'REF: ${provider.selectedProduct!.ARTREF}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      itemCount: details.length,
                      itemBuilder: (context, index) {
                        var key = details[index].keys.first;
                        if (key == 'Code-Barres') {
                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (builder) => const BarsCode()));
                            },
                            child: DetailCard(
                              title: key,
                              subtitle: details[index][key],
                            ),
                          );
                        }
                        return DetailCard(
                          title: key,
                          subtitle: details[index][key]?.toString() ?? '/',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ));
    });
  }

  bool verifyAccess(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    if (authProvider.selectedUser!.USRTYPE == 0) {
      return authProvider.accessList!
              .where((element) => element.URSTRS == '01' && element.URSRES == '01' && element.URSDRO == '03')
              .length ==
          1;
    } else if (authProvider.selectedUser!.USRTYPE == 1) {
      return authProvider.accessList!
          .where((element) => element.URSTRS == '01' && element.URSRES == '01' && element.URSDRO == '03')
          .isEmpty;
    } else {
      return true;
    }
  }
}
