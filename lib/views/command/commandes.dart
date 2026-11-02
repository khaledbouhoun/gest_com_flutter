import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/commande_entate_view_model.dart';
import 'package:gestion_stock/views/command/add_commande.dart';
import 'package:gestion_stock/views/home.dart';
import 'package:gestion_stock/widgets/commande_widget.dart';
import 'package:gestion_stock/widgets/toast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class Commandes extends StatefulWidget {
  const Commandes({super.key});

  @override
  State<StatefulWidget> createState() => CommandesPage();
}

class CommandesPage extends State<Commandes> {
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterCommandes);
    _scrollController.addListener(_onScroll);

    getData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<CommandeEntateViewModel>(context, listen: false);
      if (provider.isLoadingMore || !provider.hasMore) return;

      print("[commandes.dart] _onScroll triggering loadMoreCommandes");
      provider.loadMoreCommandes(context);
    }
  }

  Future<void> getData() async {
    final provider = Provider.of<CommandeEntateViewModel>(context, listen: false);
    provider.resetPagination();
    await provider.getCommandes(context, offset: 0);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterCommandes);
    _scrollController.removeListener(_onScroll);
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filterCommandes() {
    String query = searchController.text;
    final provider = Provider.of<CommandeEntateViewModel>(context, listen: false);

    // Switch to server-side search
    provider.getCommandes(context, search: query, offset: 0);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      color: Theme.of(context).secondaryHeaderColor,
      onRefresh: () async {
        final provider = Provider.of<CommandeEntateViewModel>(context, listen: false);
        provider.resetPagination();
        await provider.getCommandes(context, offset: 0, search: searchController.text);
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.push(context, MaterialPageRoute(builder: (builder) => const Home()));
          return false;
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F9FC),
          floatingActionButton: FutureBuilder<ApplicationType>(
              future: Provider.of<AuthViewModel>(context).typeApp,
              builder: (context, snapshot) {
                final appType = snapshot.data ?? ApplicationType.none;
                return appType == ApplicationType.general
                    ? FloatingActionButton(
                        onPressed: () async {
                          bool access =
                              Provider.of<AuthViewModel>(context, listen: false).verifyAccess('03', '03', '02');
                          if (access) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (builder) => const AddCommande()),
                            );
                          } else {
                            Toast(
                                context: context,
                                title: 'Pas de permission pour ajouter un nouveau commande',
                                style: ToastificationStyle.minimal,
                                type: ToastificationType.warning);
                          }
                        },
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 35,
                        ),
                      )
                    : SizedBox();
              }),
          appBar: AppBar(
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            leading: Icon(Icons.shopping_cart_rounded, color: Colors.white, size: width * 0.10),
            centerTitle: true,
            title: Text(
              'Les commandes',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.06,
                letterSpacing: 0.5,
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeaderSection(width, height, context),
                SizedBox(height: width * 0.03),
                Expanded(
                  child: _buildCommandesList(width, height, context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(double width, double height, BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: width * 0.01),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDateSelectors(width, context),
          SizedBox(height: width * 0.02),
          _buildSearchBar(width, context),
          SizedBox(height: width * 0.02),
          _buildTableHeader(width),
        ],
      ),
    );
  }

  Widget _buildDateSelectors(double width, BuildContext context) {
    return Consumer<CommandeEntateViewModel>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Expanded(
              child: _buildDateCard(
                width,
                context,
                'Date du',
                provider.startDate!,
                () => _selectDate(context, provider.startDate!, 0),
              ),
            ),
            SizedBox(width: width * 0.03),
            Expanded(
              child: _buildDateCard(
                width,
                context,
                'Au',
                provider.endDate!,
                () => _selectDate(context, provider.endDate!, 1),
              ),
            ),
            SizedBox(width: width * 0.03),
            _buildSyncButton(width, context, provider),
          ],
        );
      },
    );
  }

  Widget _buildDateCard(
    double width,
    BuildContext context,
    String label,
    DateTime date,
    VoidCallback onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: width * 0.02, bottom: width * 0.015),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
              fontSize: width * 0.035,
            ),
          ),
        ),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          elevation: 4,
          shadowColor: Colors.black26,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: width * 0.12,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: width * 0.04,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  SizedBox(width: width * 0.02),
                  Text(
                    DateFormat('dd/MM/yyyy').format(date),
                    style: TextStyle(
                      fontSize: width * 0.038,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSyncButton(double width, BuildContext context, CommandeEntateViewModel provider) {
    return Container(
      margin: EdgeInsets.only(top: width * 0.05),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 4,
        shadowColor: Colors.black26,
        child: InkWell(
          onTap: () {
            var authProvider = Provider.of<AuthViewModel>(context, listen: false);
            final period = authProvider.resolvePeriod();
            provider.startDate = period.start;
            provider.endDate = period.end;
            provider.resetPagination();
            provider.getCommandes(context, offset: 0);
            provider.notifyListeners();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: width * 0.12,
            width: width * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.sync_rounded,
              color: Theme.of(context).secondaryHeaderColor,
              size: width * 0.07,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(double width, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: width * 0.12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Code de commande / Nom de client',
                hintStyle: TextStyle(
                  fontSize: width * 0.035,
                  color: Colors.grey[400],
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: width * 0.03),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(double width) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: width * 0.02,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Text(
              'Raison sociale',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.04,
              ),
            ),
          ),
          Container(
            width: 1,
            height: width * 0.05,
            color: Colors.white.withValues(alpha: 0.3),
            margin: EdgeInsets.symmetric(horizontal: width * 0.02),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Net à Payer',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.04,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandesList(double width, double height, BuildContext context) {
    return Consumer<CommandeEntateViewModel>(
      builder: (context, provider, child) {
        if (provider.statusCode == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.15,
                  height: width * 0.15,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
                Text(
                  'Chargement...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        if (provider.statusCode == 404) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: width * 0.2,
                  color: Colors.grey[400],
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Aucune commande trouvée',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Text(
                  'Essayez de modifier les filtres',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: width * 0.035,
                  ),
                ),
              ],
            ),
          );
        }

        if (provider.statusCode == 500) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: width * 0.2,
                  color: Colors.grey[400],
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Impossible de se connecter',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Text(
                  'Vérifiez votre connexion',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: width * 0.035,
                  ),
                ),
                SizedBox(height: height * 0.03),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.08,
                      vertical: width * 0.04,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    provider.getCommandes(context, offset: 0);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh_rounded, size: width * 0.05),
                      SizedBox(width: width * 0.02),
                      Text(
                        'Réessayer',
                        style: TextStyle(
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: (provider.filteredCommandes?.length ?? 0) + (provider.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < (provider.filteredCommandes?.length ?? 0)) {
                return Padding(
                  padding: EdgeInsets.only(bottom: width * 0.02),
                  child: CommandeWidget(
                    commande: provider.filteredCommandes![index],
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime changedDate, int type) async {
    var provider = Provider.of<CommandeEntateViewModel>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: changedDate,
      firstDate: DateTime(0),
      lastDate: DateTime(3000),
    );
    if (picked != null) {
      switch (type) {
        case 0:
          provider.startDate = picked;
          break;
        case 1:
          provider.endDate = picked;
          break;
      }
      provider.resetPagination();
      provider.getCommandes(context, offset: 0);
    }
  }
}
