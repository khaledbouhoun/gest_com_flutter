import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/client_view_model.dart';
import 'package:gestion_stock/widgets/add_facture_client_widget.dart';
import 'package:provider/provider.dart';

class AddFactureClients extends StatefulWidget {
  const AddFactureClients({super.key});

  @override
  State<StatefulWidget> createState() => AddFactureClientsPage();
}

class AddFactureClientsPage extends State<AddFactureClients> {
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final clientVM = Provider.of<ClientViewModel>(context, listen: false);
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      clientVM.getClients(context, authVM.initialExercice, offset: 0, isVente: true, search: searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    _scrollController.removeListener(_onScroll);
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final clientVM = Provider.of<ClientViewModel>(context, listen: false);
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    clientVM.getClients(context, authVM.initialExercice, search: searchController.text, offset: 0, isVente: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final clientVM = Provider.of<ClientViewModel>(context, listen: false);
      if (clientVM.isLoadingMore || !clientVM.hasMore) return;

      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      clientVM.loadMoreClients(context, authVM.initialExercice);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return RefreshIndicator(
      color: Theme.of(context).secondaryHeaderColor,
      onRefresh: () async {
        final clientVM = Provider.of<ClientViewModel>(context, listen: false);
        final authVM = Provider.of<AuthViewModel>(context, listen: false);
        clientVM.resetPagination();
        await clientVM.getClients(context, authVM.initialExercice,
            isVente: true, offset: 0, search: searchController.text);
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F9FC),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeaderSection(width, context),
                SizedBox(height: width * 0.02),
                Expanded(child: _buildClientsList(width, context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(double width, BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.symmetric(horizontal: width * 0.03),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).secondaryHeaderColor,
            Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
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
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
              Expanded(
                child: Text(
                  'Sélectionner un client',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.05,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: width * 0.04),
          _buildSearchBar(width),
          SizedBox(height: width * 0.03),
          _buildTableHeader(width),
        ],
      ),
    );
  }

  Widget _buildSearchBar(double width) {
    return Container(
      height: width * 0.11,
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
          hintText: 'Nom ou prenom de client...',
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
          contentPadding: EdgeInsets.symmetric(vertical: width * 0.02),
        ),
      ),
    );
  }

  Widget _buildTableHeader(double width) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Text(
              'Raison sociale',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.bold,
                fontSize: width * 0.04,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Solde',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.bold,
                fontSize: width * 0.04,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientsList(double width, BuildContext context) {
    return Consumer<ClientViewModel>(
      builder: (context, provider, child) {
        if (provider.statusCode == 0) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).secondaryHeaderColor,
              ),
            ),
          );
        }
        if (provider.statusCode == 404) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_off_rounded,
                  size: width * 0.2,
                  color: Colors.grey[300],
                ),
                SizedBox(height: width * 0.02),
                Text(
                  'Aucun client trouvé',
                  style: TextStyle(color: Colors.grey[400]),
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
                const Text('Impossible de se connecter au serveur'),
                SizedBox(height: width * 0.04),
                ElevatedButton(
                  onPressed: () => _onSearchChanged(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          itemCount: (provider.clients?.length ?? 0) + (provider.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < (provider.clients?.length ?? 0)) {
              return AddFactureClientWidget(
                client: provider.clients![index],
              );
            } else {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(width * 0.04),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
