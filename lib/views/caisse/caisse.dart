import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // Required for ScrollDirection
import 'package:gestion_stock/view_models/transaction_view_model.dart';
import 'package:gestion_stock/widgets/animatednumberscroll.dart';
import 'package:gestion_stock/widgets/caisse_filter.dart';
import 'package:gestion_stock/widgets/transaction_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Caisse extends StatefulWidget {
  const Caisse({super.key});

  @override
  State<StatefulWidget> createState() => CaissePage();
}

class CaissePage extends State<Caisse> with TickerProviderStateMixin {
  TransactionViewModel? _transactionViewModel;

  // Visibility state (still used as source of truth)
  bool _showSections = true;

  // ── Animation controllers ──────────────────────────────────────────────────
  late final AnimationController _headerCtrl;
  late final AnimationController _footerCtrl;

  // Shared curved animation drives both SizeTransition and FadeTransition
  late final Animation<double> _headerFade;
  late final Animation<double> _footerFade;
  // ──────────────────────────────────────────────────────────────────────────

  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _transactionViewModel = Provider.of<TransactionViewModel>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();

    // ── Header controller: 300ms easeOutCubic ─────────────────────────────
    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0, // starts fully visible
    );
    _headerFade = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOutCubic);

    // ── Footer controller: 280ms easeOutCubic ─────────────────────────────
    _footerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: 1.0, // starts fully visible
    );
    _footerFade = CurvedAnimation(parent: _footerCtrl, curve: Curves.easeOutCubic);
    // ──────────────────────────────────────────────────────────────────────

    // Attach scroll listener to detect direction
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<TransactionViewModel>(context, listen: false).getTransactions(context).then((_) {
          if (mounted) {
            Provider.of<TransactionViewModel>(context, listen: false).getComptes(context);
          }
        });
      }
    });
  }

  // Detect scroll direction and update visibility; trigger load-more near bottom
  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_showSections) {
        setState(() => _showSections = false);
        _headerCtrl.reverse();
        _footerCtrl.reverse();
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_showSections) {
        setState(() => _showSections = true);
        _headerCtrl.forward();
        _footerCtrl.forward();
      }
    }

    // Load more when within 200px of the bottom
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= maxScroll - 200) {
      final vm = Provider.of<TransactionViewModel>(context, listen: false);
      if (!vm.isLoadingMore && vm.hasMore) {
        vm.getTransactions(context, isLoadMore: true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _headerCtrl.dispose();
    _footerCtrl.dispose();
    _transactionViewModel?.selectedComptes = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    NumberFormat formatter = NumberFormat('#,##0.00', "fr");

    return RefreshIndicator(
      color: Theme.of(context).secondaryHeaderColor,
      onRefresh: () async {
        await Provider.of<TransactionViewModel>(context, listen: false).getTransactions(context);
        WidgetsBinding.instance.addPostFrameCallback((_) {});
      },
      child: WillPopScope(
        onWillPop: () async {
          final provider = Provider.of<TransactionViewModel>(context, listen: false);
          provider.restoerDefaults(context);
          Navigator.pop(context, true);
          return false;
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: SafeArea(
              child: Column(
            children: [
              // TOP SECTION ─── collapses height + fades (no leftover space)
              SizeTransition(
                sizeFactor: _headerFade,
                axisAlignment: -1.0, // anchor to top edge while collapsing
                child: FadeTransition(
                  opacity: _headerFade,
                  child: Column(
                    children: [
                      _buildHeaderSection(width, context),
                      SizedBox(height: width * 0.03),
                    ],
                  ),
                ),
              ),

              // MAIN LIST
              Expanded(
                child: _buildTransactionList(width, height, formatter),
              ),

              // BOTTOM SECTION ─── collapses height + fades (no leftover space)
              SizeTransition(
                sizeFactor: _footerFade,
                axisAlignment: 1.0, // anchor to bottom edge while collapsing
                child: FadeTransition(
                  opacity: _footerFade,
                  child: _buildSummarySection(width, formatter, context),
                ),
              ),
            ],
          )),
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
        borderRadius: BorderRadius.circular(20),
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
          SizedBox(height: width * 0.04),
          _buildColorLegend(width),
          SizedBox(height: width * 0.04),
          _buildTableHeader(width),
        ],
      ),
    );
  }

  Widget _buildDateSelectors(double width, BuildContext context) {
    return Consumer<TransactionViewModel>(
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
            _buildFilterButton(width, context),
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

  Widget _buildFilterButton(double width, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: width * 0.05),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 4,
        shadowColor: Colors.black26,
        child: InkWell(
          onTap: () => CaisseFilter.showCaisseFilter(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: width * 0.12,
            width: width * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.filter_alt_rounded,
              color: Theme.of(context).secondaryHeaderColor,
              size: width * 0.07,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorLegend(double width) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: width * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem('C', 'Client', const Color(0xFF4ECDC4), width),
          _buildLegendItem('F', 'Fournisseur', const Color(0xFFFF6B6B), width),
          _buildLegendItem('E', 'Employé', const Color(0xFFFFE66D), width),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String letter, String label, Color color, double width) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width * 0.065,
          height: width * 0.065,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.032,
              ),
            ),
          ),
        ),
        SizedBox(width: width * 0.02),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: width * 0.03,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(double width) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: width * 0.01,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Cpt',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.038,
              ),
            ),
          ),
          Container(
            width: 1,
            height: width * 0.05,
            color: Colors.white.withValues(alpha: 0.3),
            margin: EdgeInsets.symmetric(horizontal: width * 0.01),
          ),
          Expanded(
            flex: 8,
            child: Text(
              'Libelé',
              textAlign: TextAlign.center,
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
            margin: EdgeInsets.symmetric(horizontal: width * 0.01),
          ),
          Expanded(
            flex: 5,
            child: Text(
              'Débit/Crédit',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.035,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(double width, double height, NumberFormat formatter) {
    return Consumer<TransactionViewModel>(
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
                  Icons.receipt_long_outlined,
                  size: width * 0.2,
                  color: Colors.grey[400],
                ),
                SizedBox(height: height * 0.02),
                Text(
                  'Aucune transaction trouvée',
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
                  onPressed: () async {
                    await Provider.of<TransactionViewModel>(context, listen: false).getTransactions(context);
                    WidgetsBinding.instance.addPostFrameCallback((_) {});
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

        final txList = provider.filteredTransactions ?? [];
        final itemCount = txList.length + (provider.hasMore ? 1 : 0);

        return Container(
          margin: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: width * 0.02),
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              // Loading footer
              if (index == txList.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: width * 0.05),
                  child: Center(
                    child: SizedBox(
                      width: width * 0.08,
                      height: width * 0.08,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ),
                  ),
                );
              }
              return TransactionWidget(
                date: provider.startDate,
                transaction: txList[index],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSummarySection(double width, NumberFormat formatter, BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, provider, child) {
        if (provider.statusCode != 200) {
          return const SizedBox.shrink();
        }

        return Container(
          width: width,
          margin: EdgeInsets.all(width * 0.03),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).secondaryHeaderColor,
                Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.all(width * 0.02),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Totaux',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.038,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: _buildSummaryValue(
                          '+${formatter.format(provider.totalDebit)}',
                          width,
                          const Color(0xFF4CAF50),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: _buildSummaryValue(
                          '-${formatter.format(provider.totalCredit)}',
                          width,
                          const Color(0xFFFF5252),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.all(width * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.account_balance_rounded,
                              color: Colors.white,
                              size: width * 0.05,
                            ),
                            SizedBox(width: width * 0.02),
                            Text(
                              'Solde',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.045,
                              ),
                            ),
                          ],
                        ),
                        AnimatedNumberText(
                          value: provider.totalDebit - provider.totalCredit,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.05,
                            letterSpacing: 0.5,
                          ),
                          formatter: (value) => formatter.format(value),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryValue(String value, double width, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.02,
        vertical: width * 0.015,
      ),
      margin: EdgeInsets.symmetric(horizontal: width * 0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color,
          width: 1,
        ),
      ),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: width * 0.035,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime changedDate, int type) async {
    var provider = Provider.of<TransactionViewModel>(context, listen: false);
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
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      switch (type) {
        case 0:
          provider.setDates(picked, null);
          break;
        case 1:
          provider.setDates(null, picked);
          break;
      }
      await provider.getTransactions(context);
    }
  }
}
