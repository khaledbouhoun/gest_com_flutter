import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/commande_entate_view_model.dart';
import 'package:provider/provider.dart';

class ResetCommandeDialog extends StatelessWidget {
  const ResetCommandeDialog({super.key});

  static showResetCommandeDialoge(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ResetCommandeDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    var entateProvider = Provider.of<CommandeEntateViewModel>(context, listen: false);
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text(
        'Confirmer',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        "Êtes-vous sûr de réinitialiser la commande ?",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
            style: ButtonStyle(padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero)),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Non',
              style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.bold),
            )),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Theme.of(context).secondaryHeaderColor),
                padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero)),
            onPressed: () {
              entateProvider.addCommandeClient = null;
              entateProvider.addCommandeProducts = [];
              entateProvider.notifyListeners();
              Navigator.pop(context);
            },
            child: const Text(
              'Oui',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
      ],
    );
  }
}
