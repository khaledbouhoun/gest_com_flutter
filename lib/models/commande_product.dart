import 'package:gestion_stock/models/product.dart';
import 'package:gestion_stock/models/tarif_detail.dart';

class CommandeProduct {
  final Product product;
  final List<TarifDetail> tarifs;
  int quantity;
  String? tarif;
  bool negative;

  CommandeProduct({
    required this.product,
    this.tarifs = const [],
    this.quantity = 1,
    this.tarif,
    this.negative = false,
  });
}
