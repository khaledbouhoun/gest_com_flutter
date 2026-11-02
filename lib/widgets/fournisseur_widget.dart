import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/views/fournisseur/fournisseur_detail.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../models/fournisseur.dart';
import '../models/territoire.dart';
import 'package:gestion_stock/view_models/fournisseur_view_model.dart';
import 'package:gestion_stock/view_models/location_view_model.dart';

class FournisseurWidget extends StatelessWidget {
  final Fournisseur? fournisseur;

  const FournisseurWidget({super.key, this.fournisseur});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");
    final isNegative = (fournisseur?.FOUSOLDE ?? 0) < 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          if (fournisseur != null) {
            Provider.of<FournisseurViewModel>(context, listen: false).setSelectedFournisseur(fournisseur!);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (builder) => const FournisseurDetail()),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: width,
          margin: EdgeInsets.symmetric(vertical: width * 0.01),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: width * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Balance Row
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(width * 0.02),
                            decoration: BoxDecoration(
                              color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.business_rounded,
                              size: width * 0.05,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                          SizedBox(width: width * 0.02),
                          Expanded(
                            child: Text(
                              '${fournisseur?.FOUNOM ?? ""} ${fournisseur?.FOUPRENOM ?? ""}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    Visibility(
                      visible: Provider.of<FournisseurViewModel>(context, listen: false).isSoldAllowed(),
                      child: Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02,
                            vertical: width * 0.015,
                          ),
                          decoration: BoxDecoration(
                            color: isNegative
                                ? const Color(0xFFFF5252).withValues(alpha: 0.1)
                                : const Color(0xFF4CAF50).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isNegative
                                  ? const Color(0xFFFF5252).withValues(alpha: 0.3)
                                  : const Color(0xFF4CAF50).withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            '${formatter.format(fournisseur?.FOUSOLDE ?? 0)} DA',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: isNegative ? const Color(0xFFD32F2F) : const Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: width * 0.02),
                // Location and Phone Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: width * 0.04,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: width * 0.01),
                          Expanded(
                            child: Consumer<LocationViewModel>(
                              builder: (context, location, child) {
                                final territory = location.filtredTerritoires?.firstWhere(
                                  (element) => element.TERNO == fournisseur?.FOUTERR && element.TERPAYS == fournisseur?.FOUPAYS,
                                  orElse: () => Territoire(TERNOM: '', TERNO: '', TERPAYS: ''),
                                );
                                return Text(
                                  territory?.TERNOM ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (fournisseur?.FOUTEL1 != null && fournisseur!.FOUTEL1 != '')
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            launchUrlString('tel:${fournisseur!.FOUTEL1.replaceAll(RegExp(r'\D'), '')}');
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: width * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  fournisseur!.FOUTEL1.trim(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                SizedBox(width: width * 0.01),
                                const Icon(
                                  Icons.call_rounded,
                                  color: Colors.blueGrey,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
