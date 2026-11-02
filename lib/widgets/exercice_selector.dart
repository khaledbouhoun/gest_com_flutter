import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/client_view_model.dart';
import 'package:gestion_stock/view_models/fournisseur_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:provider/provider.dart';

import '../models/exercice.dart';

class ExerciceSelector extends StatelessWidget {
  final String? functionType;

  const ExerciceSelector({
    super.key,
    this.functionType,
  });

  void _onExerciceChanged(
    BuildContext context,
    AuthViewModel provider,
    Exercice? exercice,
  ) {
    provider.selectedExercice = exercice;
    provider.notifyListeners();

    switch (functionType) {
      case 'stock':
        final vm = Provider.of<StockViewModel>(context, listen: false);
        vm.resetPagination();
        vm.getStock(context, provider.selectedExercice, offset: 0);
        break;

      case 'client':
        final vm = Provider.of<ClientViewModel>(context, listen: false);
        vm.resetPagination();
        vm.getClients(context, provider.selectedExercice, offset: 0);
        break;

      case 'fournisseur':
        final vm = Provider.of<FournisseurViewModel>(context, listen: false);
        vm.resetPagination();
        vm.getFournisseurs(context, provider.selectedExercice, offset: 0);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Consumer<AuthViewModel>(
      builder: (context, provider, child) {
        return Container(
          height: 40,
          width: width * 0.3,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
          child: DropdownButton<Exercice>(
            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
            value: provider.selectedExercice,
            underline: Container(),
            isExpanded: true,
            dropdownColor: Theme.of(context).secondaryHeaderColor,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
            ),
            style: TextStyle(
              fontSize: width * 0.035,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (Exercice? exercice) {
              provider.selectedExercice = exercice;
              provider.notifyListeners();

              switch (functionType) {
                case 'stock':
                  final vm = Provider.of<StockViewModel>(context, listen: false);
                  vm.resetPagination();
                  vm.getStock(
                    context,
                    provider.selectedExercice,
                    offset: 0,
                  );
                  break;

                case 'client':
                  final vm = Provider.of<ClientViewModel>(context, listen: false);
                  vm.resetPagination();
                  vm.getClients(
                    context,
                    provider.selectedExercice,
                    offset: 0,
                  );
                  break;

                case 'fournisseur':
                  final vm = Provider.of<FournisseurViewModel>(context, listen: false);
                  vm.resetPagination();
                  vm.getFournisseurs(
                    context,
                    provider.selectedExercice,
                    offset: 0,
                  );
                  break;
              }
            },
            items: provider.exercices!
                .map<DropdownMenuItem<Exercice>>(
                  (exercice) => DropdownMenuItem<Exercice>(
                    value: exercice,
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: width * 0.045,
                          color: Colors.white,
                        ),
                        SizedBox(width: width * 0.02),
                        Text(
                          exercice.EXENO.toString(),
                          style: TextStyle(
                            fontSize: width * 0.035,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
