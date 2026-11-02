import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/fournisseur_view_model.dart';
import 'package:gestion_stock/widgets/add_receptions_Fournisseur_widget.dart';
import 'package:provider/provider.dart';

class AddReceptionsClients extends StatefulWidget {
  const AddReceptionsClients({super.key});

  @override
  State<StatefulWidget> createState() => AddReceptionsClientsPage();
}

class AddReceptionsClientsPage extends State<AddReceptionsClients> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterClients);
    Provider.of<FournisseurViewModel>(context, listen: false).getFournisseurs(
      context,
      Provider.of<AuthViewModel>(context, listen: false).initialExercice,
      isAchat: true,
      offset: 0,
      search: searchController.text,
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterClients() {
    String query = searchController.text.toLowerCase();
    Provider.of<FournisseurViewModel>(context, listen: false).getFournisseurs(
      context,
      Provider.of<AuthViewModel>(context, listen: false).initialExercice,
      search: query,
      offset: 0,
      isAchat: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return RefreshIndicator(
      color: Theme.of(context).secondaryHeaderColor,
      onRefresh: () async {
        Provider.of<FournisseurViewModel>(context, listen: false).getFournisseurs(
            context, Provider.of<AuthViewModel>(context, listen: false).initialExercice,
            isAchat: true, offset: 0);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F9FC),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeaderSection(width, context),
              SizedBox(height: width * 0.02),
              Expanded(
                child: _buildFournisseursList(width, context),
              ),
            ],
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
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
              Expanded(
                child: Text(
                  'Fournisseurs',
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
          hintText: 'Chercher un fournisseur...',
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

  Widget _buildFournisseursList(double width, BuildContext context) {
    return Consumer<FournisseurViewModel>(
      builder: (context, provider, child) {
        if (provider.statusCode == 0) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).secondaryHeaderColor),
            ),
          );
        }
        if (provider.statusCode == 404) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_off_rounded, size: width * 0.2, color: Colors.grey[300]),
                SizedBox(height: width * 0.02),
                Text('Aucun fournisseur trouvé', style: TextStyle(color: Colors.grey[400])),
              ],
            ),
          );
        }
        if (provider.statusCode == 500) {
          return _buildErrorState(width, context);
        }
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          itemCount: provider.filteredFournisseurs.length ?? 0,
          itemBuilder: (context, index) {
            return AddReceptionsFournisseurWidget(fournisseur: provider.filteredFournisseurs[index]);
          },
        );
      },
    );
  }

  Widget _buildErrorState(double width, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Impossible de se connecter au serveur'),
          SizedBox(height: width * 0.04),
          ElevatedButton(
            onPressed: () => _filterClients(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}
