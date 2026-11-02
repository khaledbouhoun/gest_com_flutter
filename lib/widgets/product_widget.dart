import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/product_view_model.dart';
import 'package:gestion_stock/views/product/product_details.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';

class ProductWidget extends StatelessWidget {
  Product? product;
  ProductWidget({super.key, this.product});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");
    final isLowStock = (product!.ARTQTE ?? 0) < 10;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          Provider.of<ProductViewModel>(context, listen: false).selectedProduct = product!;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => const ProductDetails()),
          );
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
            child: Row(
              children: [
                // Product Info Section
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(width * 0.02),
                        decoration: BoxDecoration(
                          color: product!.ARTTYPE == 0
                              ? Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.1)
                              : Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          product!.ARTTYPE == 0 ? Icons.inventory_2_rounded : Icons.work,
                          size: width * 0.05,
                          color: product!.ARTTYPE == 0 ? Theme.of(context).secondaryHeaderColor : Colors.red,
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              product!.ARTNOM!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: width * 0.01),
                            Row(
                              children: [
                                Icon(
                                  Icons.tag_rounded,
                                  size: width * 0.03,
                                  color: Colors.grey[600],
                                ),
                                SizedBox(width: width * 0.01),
                                Expanded(
                                  child: Text(
                                    '${product!.ARTNO!} / ${product!.ARTREF!}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: width * 0.02),

                // Price and Quantity Section
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.02,
                          vertical: width * 0.015,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${formatter.format(product!.ARTPRIX!)} DA',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ),
                      SizedBox(height: width * 0.01),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.02,
                          vertical: width * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: isLowStock ? const Color(0xFFFF5252).withValues(alpha: 0.1) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                          border: isLowStock
                              ? Border.all(
                                  color: const Color(0xFFFF5252).withValues(alpha: 0.3),
                                  width: 1,
                                )
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inventory_rounded,
                              size: width * 0.03,
                              color: isLowStock ? const Color(0xFFD32F2F) : Colors.black87,
                            ),
                            SizedBox(width: width * 0.01),
                            Text(
                              formatter.format(product!.ARTQTE!),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: isLowStock ? const Color(0xFFD32F2F) : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
