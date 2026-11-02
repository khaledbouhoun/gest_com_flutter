import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/facture_entate_view_model.dart';
import 'package:gestion_stock/view_models/reception_entate_view_model.dart';
import 'package:provider/provider.dart';

class ResetFactureDialog extends StatelessWidget {
  const ResetFactureDialog({super.key});

  static showResetFactureDialoge(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ResetFactureDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    var entateProvider = Provider.of<FactureEntateViewModel>(context, listen: false);
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text(
        'Confirmer',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        "Êtes-vous sûr de réinitialiser le bon ?",
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
              entateProvider.addFactureClient = null;
              entateProvider.addFactureProducts = [];
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

class ResetReceptionsDialog extends StatelessWidget {
  const ResetReceptionsDialog({super.key});

  static showResetReceptionsDialoge(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ResetReceptionsDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    var entateProvider = Provider.of<ReceptionEntateViewModel>(context, listen: false);
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text(
        'Confirmer',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        "Êtes-vous sûr de réinitialiser le Commond ?",
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
              entateProvider.addReceptionFournisseur = null;
              entateProvider.addReceptionProducts = [];
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
