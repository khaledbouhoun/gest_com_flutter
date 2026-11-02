import 'package:flutter/material.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/reception_entate_view_model.dart';
import 'package:gestion_stock/views/home.dart';
import 'package:gestion_stock/widgets/reception_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Receptions extends StatefulWidget {
  const Receptions({super.key});

  @override
  State<StatefulWidget> createState() => ReceptionsPage();
}

class ReceptionsPage extends State<Receptions> {
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filtereReceptions);
    _scrollController.addListener(_onScroll);
    getData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<ReceptionEntateViewModel>(context, listen: false);
      if (provider.isLoadingMore || !provider.hasMore) return;

      print("[receptions.dart] _onScroll triggering loadMoreReceptions");
      provider.loadMoreReceptions(context);
    }
  }

  Future<void> getData() async {
    final provider = Provider.of<ReceptionEntateViewModel>(context, listen: false);
    provider.resetPagination();
    await provider.getReceptions(context, offset: 0);
  }

  @override
  void dispose() {
    searchController.removeListener(_filtereReceptions);
    _scrollController.removeListener(_onScroll);
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filtereReceptions() {
    String query = searchController.text;
    final provider = Provider.of<ReceptionEntateViewModel>(context, listen: false);

    // Switch to server-side search
    provider.getReceptions(context, search: query, offset: 0);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      color: Theme.of(context).secondaryHeaderColor,
      onRefresh: () async {
        final provider = Provider.of<ReceptionEntateViewModel>(context, listen: false);
        provider.resetPagination();
        await provider.getReceptions(context, offset: 0, search: searchController.text);
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.push(context, MaterialPageRoute(builder: (builder) => const Home()));
          return false;
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F9FC),
          // floatingActionButton: FutureBuilder<ApplicationType>(
          //     future: Provider.of<AuthViewModel>(context).typeApp,
          //     builder: (context, snapshot) {
          //       final appType = snapshot.data ?? ApplicationType.none;
          //       return appType == ApplicationType.general
          //           ? FloatingActionButton(
          //               onPressed: () {
          //                 bool access =
          //                     Provider.of<AuthViewModel>(context, listen: false).verifyAccess('02', '03', '02');
          //                 if (access) {
          //                   Navigator.push(
          //                     context,
          //                     MaterialPageRoute(builder: (builder) => const AddReceptions()),
          //                   );
          //                 } else {
          //                   Toast(
          //                       context: context,
          //                       title: 'Pas de permission pour ajouter un nouveau réception',
          //                       style: ToastificationStyle.minimal,
          //                       type: ToastificationType.warning);
          //                 }
          //               },
          //               backgroundColor: Theme.of(context).secondaryHeaderColor,
          //               elevation: 8,
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(20),
          //               ),
          //               child: const Icon(
          //                 Icons.add_rounded,
          //                 color: Colors.white,
          //                 size: 35,
          //               ),
          //             )
          //           : SizedBox();
          //     }),
          appBar: AppBar(
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            leading: Icon(Icons.inventory_2_rounded, color: Colors.white, size: width * 0.10),
            title: Container(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Réceptions',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.06,
                      letterSpacing: 0.5,
                    ),
                  ),
                  _buildTypeSelector(width, context),
                ],
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeaderSection(width, context),
                SizedBox(height: width * 0.02),
                Expanded(
                  child: _buildReceptionsList(width, height, context),
                ),
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

  Widget _buildTypeSelector(double width, BuildContext context) {
    return Consumer<ReceptionEntateViewModel>(
      builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          height: width * 0.09,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: DropdownButton<Map<double, String>>(
            value: provider.selectedType,
            underline: Container(),
            dropdownColor: Theme.of(context).secondaryHeaderColor,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
            onChanged: (type) {
              if (type != null) {
                provider.selectedType = type;
                provider.resetPagination();
                provider.getReceptions(context, offset: 0);
                provider.notifyListeners();
              }
            },
            items: provider.types.map<DropdownMenuItem<Map<double, String>>>((type) {
              return DropdownMenuItem<Map<double, String>>(
                value: type,
                child: Text(
                  type[type.keys.first]!,
                  style: TextStyle(
                    fontSize: width * 0.035,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildDateSelectors(double width, BuildContext context) {
    return Consumer<ReceptionEntateViewModel>(
      builder: (context, provider, child) {
        return Row(
          children: [
            Expanded(
              child: _buildDateCard(
                width,
                context,
                'Date du',
                DateFormat('dd/MM/yyyy').format(provider.startDate!),
                () => _selectDate(context, provider.startDate!, 0),
              ),
            ),
            SizedBox(width: width * 0.03),
            Expanded(
              child: _buildDateCard(
                width,
                context,
                'Au',
                DateFormat('dd/MM/yyyy').format(provider.endDate!),
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

  Widget _buildDateCard(double width, BuildContext context, String label, String date, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: width * 0.03,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: width * 0.01),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          elevation: 4,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.03,
                vertical: width * 0.02,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: width * 0.04,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  SizedBox(width: width * 0.02),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2d3436),
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

  Widget _buildSyncButton(double width, BuildContext context, ReceptionEntateViewModel provider) {
    return Column(
      children: [
        const SizedBox(height: 18),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          elevation: 4,
          child: InkWell(
            onTap: () {
              var authProvider = Provider.of<AuthViewModel>(context, listen: false);
              provider.startDate = DateTime(authProvider.selectedExercice!.EXENO!, 1, 1);
              provider.endDate = DateTime(authProvider.selectedExercice!.EXENO!, 12, 31);
              provider.resetPagination();
              provider.getReceptions(context, offset: 0);
              provider.notifyListeners();
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(width * 0.025),
              child: Icon(
                Icons.sync_rounded,
                color: Theme.of(context).secondaryHeaderColor,
                size: width * 0.06,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(double width, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
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
                hintText: 'Code réception / Nom fournisseur',
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

  Widget _buildReceptionsList(double width, double height, BuildContext context) {
    return Consumer<ReceptionEntateViewModel>(
      builder: (context, provider, child) {
        if (provider.statusCode == 0) {
          return _buildLoadingState(width, height, context);
        }
        if (provider.statusCode == 404) {
          return _buildEmptyState(width, height);
        }
        if (provider.statusCode == 500) {
          return _buildErrorState(width, height, context);
        }
        return ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          itemCount: (provider.filterdReceptions?.length ?? 0) + (provider.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < (provider.filterdReceptions?.length ?? 0)) {
              return ReceptionWidget(reception: provider.filterdReceptions![index]);
            } else {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildLoadingState(double width, double height, BuildContext context) {
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

  Widget _buildEmptyState(double width, double height) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: width * 0.2,
            color: Colors.grey[400],
          ),
          SizedBox(height: height * 0.02),
          Text(
            'Aucune réception trouvée',
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

  Widget _buildErrorState(double width, double height, BuildContext context) {
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
              Provider.of<ReceptionEntateViewModel>(context, listen: false).getReceptions(context, offset: 0);
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

  Future<void> _selectDate(BuildContext context, DateTime changedDate, int type) async {
    var provider = Provider.of<ReceptionEntateViewModel>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: changedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).secondaryHeaderColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (type == 0) {
        provider.startDate = picked;
      } else {
        provider.endDate = picked;
      }
      provider.resetPagination();
      provider.getReceptions(context, offset: 0);
      provider.notifyListeners();
    }
  }
}
