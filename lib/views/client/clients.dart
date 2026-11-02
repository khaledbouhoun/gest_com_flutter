import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/client_view_model.dart';
import 'package:gestion_stock/views/client/add_new_client_identity.dart';
import 'package:gestion_stock/views/home.dart';
import 'package:gestion_stock/widgets/client_widget.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../models/client.dart';
import '../../widgets/exercice_selector.dart';
import '../../widgets/toast.dart';

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<StatefulWidget> createState() => ClientsPage();
}

class ClientsPage extends State<Clients> {
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print("[clients.dart] clients initState");
    searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("[clients.dart] clients initState postframe");
      final clientVM = Provider.of<ClientViewModel>(context, listen: false);
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      clientVM.resetPagination();
      clientVM.getClients(context, authVM.selectedExercice, offset: 0);
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
    // Implement debouncing if necessary
    final clientVM = Provider.of<ClientViewModel>(context, listen: false);
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    clientVM.getClients(context, authVM.selectedExercice, search: searchController.text, offset: 0);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final clientVM = Provider.of<ClientViewModel>(context, listen: false);
      if (clientVM.isLoadingMore || !clientVM.hasMore) return;

      print("[clients.dart] _onScroll triggering loadMoreClients");
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      clientVM.loadMoreClients(context, authVM.selectedExercice);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return RefreshIndicator(
      onRefresh: () async {
        final clientVM = Provider.of<ClientViewModel>(context, listen: false);
        final authVM = Provider.of<AuthViewModel>(context, listen: false);
        clientVM.resetPagination();
        await clientVM.getClients(context, authVM.selectedExercice, offset: 0, search: searchController.text);
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.push(context, MaterialPageRoute(builder: (builder) => const Home()));
          return false;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            leading: Icon(Icons.person_rounded, color: Colors.white, size: width * 0.07),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Clients',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width * 0.06)),
                ExerciceSelector(functionType: 'client')
              ],
            ),
          ),
          body: SafeArea(
            child: SizedBox(
              width: width,
              height: height,
              child: Column(
                children: [
                  Container(
                    width: width,
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).secondaryHeaderColor,
                          blurRadius: 30.0,
                          offset: const Offset(0.0, 0.75),
                        ),
                      ],
                    ),
                    child: Column(
                      spacing: 10,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: height * 0.06,
                                child: TextField(
                                  controller: searchController,
                                  decoration: const InputDecoration(
                                    hintText: 'Entrer nom ou prénom',
                                    prefixIcon: Icon(Icons.search),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(Radius.circular(10))),
                                  ),
                                ),
                              ),
                            ),
                            // FutureBuilder<ApplicationType>(
                            //     future: Provider.of<AuthViewModel>(context).typeApp,
                            //     builder: (context, snapshot) {
                            //       final appType = snapshot.data ?? ApplicationType.none;
                            //       return appType == ApplicationType.general
                            //           ? IconButton(
                            //               onPressed: () {
                            //                 if (verifyAccess(context)) {
                            //                   Provider.of<ClientViewModel>(context, listen: false).newClient = Client();
                            //                   Navigator.push(
                            //                       context,
                            //                       MaterialPageRoute(
                            //                           builder: (builder) => const AddNewClientIdentity()));
                            //                 } else {
                            //                   Toast(
                            //                       context: context,
                            //                       title: 'Pas de permission pour ajouter un nouveau dossier de client',
                            //                       style: ToastificationStyle.minimal,
                            //                       type: ToastificationType.warning);
                            //                 }
                            //               },
                            //               icon: Icon(
                            //                 Icons.add_circle,
                            //                 color: Colors.white,
                            //                 size: width * 0.09,
                            //               ))
                            //           : SizedBox();
                            //     }),
                          ],
                        ),
                        _buildTableHeader(width),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Consumer<ClientViewModel>(
                      builder: (context, clientViewModel, child) {
                        print("build Client Pgae");

                        if (clientViewModel.statusCode == 0) {
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
                        if (clientViewModel.statusCode == 404) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.people_outline_rounded,
                                  size: width * 0.2,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: height * 0.02),
                                Text(
                                  'Aucun client trouvé',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: height * 0.01),
                                Text(
                                  'Essayez de modifier la recherche',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: width * 0.035,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        if (clientViewModel.statusCode == 500) {
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
                                    _onSearchChanged();
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
                            itemCount: (clientViewModel.clients?.length ?? 0) + (clientViewModel.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < (clientViewModel.clients?.length ?? 0)) {
                                return ClientWidget(client: clientViewModel.clients![index]);
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
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
              'Nom complet',
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
              'Solde',
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

  bool verifyAccess(BuildContext context) {
    var authProvider = Provider.of<AuthViewModel>(context, listen: false);
    if (authProvider.selectedUser!.USRTYPE == 0) {
      return authProvider.accessList!
              .where((element) => element.URSTRS == '03' && element.URSRES == '01' && element.URSDRO == '02')
              .length ==
          1;
    } else if (authProvider.selectedUser!.USRTYPE == 1) {
      return authProvider.accessList!
          .where((element) => element.URSTRS == '03' && element.URSRES == '01' && element.URSDRO == '02')
          .isEmpty;
    } else {
      return true;
    }
  }
}
