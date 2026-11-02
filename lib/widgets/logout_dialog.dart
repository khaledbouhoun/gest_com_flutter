import 'package:flutter/material.dart';
import 'package:gestion_stock/ask_first.dart';
import 'package:gestion_stock/login.dart';
import 'package:gestion_stock/view_models/client_view_model.dart';
import 'package:gestion_stock/view_models/fournisseur_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:provider/provider.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({super.key});

  static show(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const LogOutDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text(
        'Confirmer',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      content: const Text(
        "Voulez-vous vraiment quitter l'application ?",
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
              Provider.of<FournisseurViewModel>(context, listen: false).filteredFournisseurs = [];
              Provider.of<FournisseurViewModel>(context, listen: false).fournisseurs = [];
              Provider.of<FournisseurViewModel>(context, listen: false).notifyListeners();

              Provider.of<ClientViewModel>(context, listen: false).clients = [];
              Provider.of<ClientViewModel>(context, listen: false).clients = [];
              Provider.of<ClientViewModel>(context, listen: false).notifyListeners();

              Provider.of<StockViewModel>(context, listen: false).filteredProducts = [];
              Provider.of<StockViewModel>(context, listen: false).products = [];
              Provider.of<StockViewModel>(context, listen: false).notifyListeners();

              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => const AskFirst()), (route) => false);
            },
            child: const Text(
              'Oui',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
      ],
    );
  }
}
