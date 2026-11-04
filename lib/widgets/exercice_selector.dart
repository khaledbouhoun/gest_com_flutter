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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Consumer4<AuthViewModel, StockViewModel, ClientViewModel, FournisseurViewModel>(
      builder: (context, auth, stk, client, fourn, child) {
        Exercice? selectedExercice;

        switch (functionType) {
          case 'stock':
            selectedExercice = stk.selectedExerciceStock;
            break;

          case 'client':
            selectedExercice = client.selectedExerciceClient;
            break;

          case 'fournisseur':
            selectedExercice = fourn.selectedExerciceFourniseur;
            break;
        }

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
            value: selectedExercice,
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
              if (exercice == null) return;

              switch (functionType) {
                case 'stock':
                  stk.selectedExerciceStock = exercice;
                  stk.notifyListeners();

                  stk.resetPagination();
                  stk.getStock(
                    context,
                    exercice,
                    offset: 0,
                  );
                  break;

                case 'client':
                  client.selectedExerciceClient = exercice;
                  client.notifyListeners();

                  client.resetPagination();
                  client.getClients(
                    context,
                    exercice,
                    offset: 0,
                  );
                  break;

                case 'fournisseur':
                  fourn.selectedExerciceFourniseur = exercice;
                  fourn.notifyListeners();

                  fourn.resetPagination();
                  fourn.getFournisseurs(
                    context,
                    exercice,
                    offset: 0,
                  );
                  break;
              }
            },
            items: (auth.exercices ?? [])
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
