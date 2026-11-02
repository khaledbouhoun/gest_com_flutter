import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/commande_detail_view_model.dart';
import 'package:gestion_stock/widgets/commande_product_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CommandeDetails extends StatefulWidget {
  const CommandeDetails({super.key});

  @override
  State<StatefulWidget> createState() => _CommandeDetailsPage();
}

class _CommandeDetailsPage extends State<CommandeDetails> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    Provider.of<CommandeDetailViewModel>(context, listen: false).getCommandeProducts();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    var provider = Provider.of<CommandeDetailViewModel>(context);
    bool isRSV = provider.selectedCommande?.cDERSVCOURS == 1;
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F9FC),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeaderSection(width, context, provider, isRSV),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDetailsTab(width, provider, formatter, isRSV),
                    _buildProductsTab(width, height, context, provider),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(double width, BuildContext context, CommandeDetailViewModel provider, bool isRSV) {
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(horizontal: width * 0.03),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isRSV ? Colors.redAccent : Theme.of(context).secondaryHeaderColor,
            isRSV
                ? Colors.redAccent.withValues(alpha: 0.85)
                : Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: isRSV
                ? Colors.redAccent.withValues(alpha: 0.3)
                : Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Détails du bon',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.05,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          SizedBox(height: width * 0.03),
          Container(
            padding: EdgeInsets.all(width * 0.01),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: isRSV ? Colors.redAccent : Theme.of(context).secondaryHeaderColor,
              unselectedLabelColor: Colors.white,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Infos'),
                Tab(text: 'Articles'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab(double width, CommandeDetailViewModel provider, NumberFormat formatter, bool isRSV) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(width * 0.04),
      child: Column(
        children: [
          _buildInfoCard(
            width,
            'Information Client',
            Icons.person_rounded,
            [
              _buildInfoRow('Nom',
                  '${provider.selectedCommande?.cLINOM ?? ''} ${provider.selectedCommande?.cLIPRENOM ?? ''}', width),
              _buildInfoRow(
                'Téléphone',
                provider.selectedCommande?.cLITEL1 ?? '-',
                width,
                onTap: () {
                  if (provider.selectedCommande?.cLITEL1 != null && provider.selectedCommande!.cLITEL1!.isNotEmpty) {
                    launchUrlString('tel:${provider.selectedCommande!.cLITEL1!.replaceAll(RegExp(r'\D'), '')}');
                  }
                },
                isPhone: true,
              ),
            ],
            isRSV,
          ),
          SizedBox(height: width * 0.04),
          _buildInfoCard(
            width,
            'Détails du Bon',
            Icons.receipt_long_rounded,
            [
              _buildInfoRow('Code', (provider.selectedCommande?.cDENO ?? '').toString(), width),
              _buildInfoRow(
                  'Date',
                  provider.selectedCommande?.cDEDATE != null
                      ? DateFormat('dd/MM/yyyy').format(provider.selectedCommande!.cDEDATE!)
                      : '-',
                  width),
              _buildInfoRow('Net à Payer', '${formatter.format(provider.selectedCommande?.cDENAP ?? 0)} DA', width,
                  isBold: true),
            ],
            isRSV,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(double width, String title, IconData icon, List<Widget> children, bool isRSV) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Row(
              children: [
                Icon(icon,
                    color: isRSV ? Colors.redAccent : Theme.of(context).secondaryHeaderColor, size: width * 0.06),
                SizedBox(width: width * 0.02),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.045,
                    color: const Color(0xFF2d3436),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, double width,
      {bool isBold = false, bool isPhone = false, VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: width * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: width * 0.035,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                    fontSize: width * 0.038,
                    color: isPhone ? Colors.blue : const Color(0xFF2d3436),
                  ),
                ),
                if (isPhone && value != '-') ...[
                  SizedBox(width: width * 0.01),
                  const Icon(Icons.call, size: 16, color: Colors.blue),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab(double width, double height, BuildContext context, CommandeDetailViewModel provider) {
    return RefreshIndicator(
      color: Theme.of(context).secondaryHeaderColor,
      onRefresh: () async {
        provider.getCommandeProducts();
      },
      child: Consumer<CommandeDetailViewModel>(
        builder: (context, provider, child) {
          if (provider.statusCode == 0) {
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).secondaryHeaderColor),
            ));
          }
          if (provider.statusCode == 404) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: width * 0.2, color: Colors.grey[300]),
                  SizedBox(height: width * 0.02),
                  const Text('Aucun Article trouvé'),
                ],
              ),
            );
          }
          if (provider.statusCode == 500) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Impossible de se connecter au serveur'),
                  SizedBox(height: width * 0.04),
                  ElevatedButton(
                    onPressed: () => provider.getCommandeProducts(),
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).secondaryHeaderColor),
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(width * 0.03),
            itemCount: provider.products?.length ?? 0,
            itemBuilder: (context, index) {
              return CommandeProductWidget(product: provider.products![index]);
            },
          );
        },
      ),
    );
  }
}
