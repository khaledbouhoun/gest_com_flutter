import 'package:flutter/material.dart';
import 'package:gestion_stock/models/client.dart';
import 'package:gestion_stock/view_models/commande_entate_view_model.dart';
import 'package:gestion_stock/views/command/add_commande.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddCommandeClientWidget extends StatelessWidget {
  final Client client;
  const AddCommandeClientWidget({super.key, required this.client});

  void _showBlockedClientDialog(BuildContext context) {
    final clientName = '${client.CLINOM} ${client.CLIPRENOM}'.trim();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.block_rounded,
                  color: Colors.red,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Client bloqué',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2d3436),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                clientName.isNotEmpty
                    ? 'Le client "$clientName" est actuellement bloqué.\nImpossible de créer une commande pour ce client.'
                    : 'Ce client est actuellement bloqué.\nImpossible de créer une commande pour ce client.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");
    return TextButton(
        style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero), overlayColor: WidgetStateProperty.all<Color>(Colors.transparent)),
        onPressed: () {
          if (client.CLICACHE == 1) {
            _showBlockedClientDialog(context);
            return;
          }
          var entateProvider = Provider.of<CommandeEntateViewModel>(context, listen: false);
          FocusScope.of(context).unfocus();
          entateProvider.addCommandeClient = client;
          // Set default or selected tarif if needed (optional, based on your business logic)
          entateProvider.notifyListeners();
          Navigator.push(context, MaterialPageRoute(builder: (builder) => const AddCommande()));
        },
        child: Container(
          width: width,
          height: height / 12.5,
          padding: EdgeInsets.all(width * 0.01),
          margin: EdgeInsets.only(top: width * 0.04),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(
            children: [
              Expanded(
                  flex: 6,
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${client.CLINOM} ${client.CLIPRENOM}',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.04,
                            color: client.CLICACHE == 1 ? Colors.grey[700] : Colors.black,
                          ),
                        ),
                      ),
                      if (client.CLICACHE == 1) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                          ),
                          child: const Text(
                            'Bloqué',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  )),
              Expanded(
                flex: 3,
                child: Text(
                  '${formatter.format(client.CLISOLDE)} DA',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: width * 0.035, color: client.CLISOLDE >= 0 ? Colors.black : Colors.red),
                ),
              )
            ],
          ),
        ));
  }
}
