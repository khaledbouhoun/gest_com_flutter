import 'package:flutter/material.dart';
import 'package:gestion_stock/models/comptes.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/transaction_view_model.dart';
import 'package:provider/provider.dart';

class CaisseFilter extends StatefulWidget {
  const CaisseFilter({super.key});

  static void showCaisseFilter(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CaisseFilter();
      },
      barrierColor: Colors.black.withValues(alpha: 0.4),
      barrierDismissible: true,
    );
  }

  @override
  State<CaisseFilter> createState() => _CaisseFilterState();
}

class _CaisseFilterState extends State<CaisseFilter> with TickerProviderStateMixin {
  late TextEditingController _selectionController;
  FocusScopeNode? _focusScope;
  late AnimationController _dialogAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _selectionController = TextEditingController();

    _dialogAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _dialogAnimationController, curve: Curves.easeOutCubic),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dialogAnimationController, curve: Curves.easeOut),
    );

    _dialogAnimationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusScope = FocusScope.of(context);
  }

  @override
  void dispose() {
    _selectionController.dispose();
    _dialogAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isMobile = width < 600;

    return Consumer2<TransactionViewModel, AuthViewModel>(
      builder: (context, provider, authProvider, child) {
        _selectionController.text = provider.selection ?? '';

        return ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: EdgeInsets.all(isMobile ? 16 : 48),
              child: Container(
                width: isMobile ? double.infinity : width * 0.55,
                constraints: BoxConstraints(maxHeight: height * 0.9),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFFAFBFC),
                      const Color(0xFFF5F7FA),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 20 : 28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with title and reset button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Filtre de transactions',
                                  style: TextStyle(
                                    fontSize: isMobile ? 20 : 26,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A2332),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                SizedBox(height: isMobile ? 4 : 6),
                                Text(
                                  'Affinez votre recherche',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF7A8BA8),
                                  ),
                                ),
                              ],
                            ),
                            _buildResetButton(provider, authProvider),
                          ],
                        ),

                        SizedBox(height: isMobile ? 24 : 32),

                        // Sens Filter Section
                        _buildSectionTitle('Type de transaction', isMobile),
                        SizedBox(height: isMobile ? 12 : 16),
                        _buildSensFilter(provider, width, isMobile),

                        SizedBox(height: isMobile ? 24 : 32),

                        _buildSectionTitle('Comptes', isMobile),
                        SizedBox(height: isMobile ? 12 : 16),
                        // Comptes Section
                        provider.comptes.isEmpty ? _buildWarningBox() : _buildComptesSection(provider, width, isMobile),

                        SizedBox(height: isMobile ? 24 : 32),

                        // Category Filters Section
                        _buildSectionTitle('Opérations', isMobile),
                        SizedBox(height: isMobile ? 12 : 16),
                        _buildCategoryFilters(provider, isMobile),

                        SizedBox(height: isMobile ? 28 : 36),

                        // Apply Button
                        _buildApplyButton(provider, context, isMobile),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResetButton(TransactionViewModel provider, AuthViewModel authProvider) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await provider.restoerDefaults(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Tooltip(
            message: 'Réinitialiser les filtres',
            child: Icon(
              Icons.refresh_rounded,
              color: const Color(0xFF4A5F7F),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isMobile) {
    return Text(
      title,
      style: TextStyle(
        fontSize: isMobile ? 14 : 15,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1A2332),
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildSensFilter(
    TransactionViewModel provider,
    double width,
    bool isMobile,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        child: DropdownButton<int>(
          isExpanded: true,
          value: provider.selectedSens,
          underline: const SizedBox.shrink(),
          style: TextStyle(
            fontSize: isMobile ? 14 : 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A2332),
          ),
          iconEnabledColor: const Color(0xFF4A5F7F),
          iconDisabledColor: const Color(0xFFBCC7D9),
          onChanged: (int? sens) {
            if (sens != null) {
              provider.selectedSens = sens;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                provider.notifyListeners();
              });
            }
          },
          items: provider.sensList.map<DropdownMenuItem<int>>((sense) {
            int key = sense.keys.first;
            String value = sense.values.first;
            return DropdownMenuItem<int>(
              value: key,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(value),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildWarningBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E1),
        border: Border.all(
          color: const Color(0xFFFFD966),
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_rounded,
            color: const Color(0xFFF59E0B),
            size: 20,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Comptes non autorisés',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF92400E),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComptesSection(
    TransactionViewModel provider,
    double width,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              ...provider.comptes.map((compte) {
                final isSelected = provider.selectedComptesList.contains(compte);
                return _buildCompteCheckbox(compte, isSelected, provider, isMobile);
              }),
              Divider(
                height: 1,
                color: const Color(0xFFE2E8F0),
              ),
              _buildSelectAllCheckbox(provider, isMobile),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompteCheckbox(
    Comptes compte,
    bool isSelected,
    TransactionViewModel provider,
    bool isMobile,
  ) {
    return InkWell(
      onTap: () {
        if (isSelected) {
          provider.selectedComptesList.remove(compte);
        } else {
          provider.selectedComptesList.add(compte);
        }
        provider.notifyListeners();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            _buildCustomCheckbox(isSelected),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                compte.cptAbv,
                style: TextStyle(
                  fontSize: isMobile ? 13 : 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A2332),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectAllCheckbox(TransactionViewModel provider, bool isMobile) {
    final isAllSelected = provider.selectedComptesList.length == provider.comptes.length;

    return InkWell(
      onTap: () {
        if (isAllSelected) {
          provider.selectedComptesList.clear();
        } else {
          provider.selectedComptesList = List.from(provider.comptes);
        }
        provider.notifyListeners();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Theme.of(context).secondaryHeaderColor)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            _buildCustomCheckbox(isAllSelected),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Tous les comptes',
                style: TextStyle(
                  fontSize: isMobile ? 13 : 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomCheckbox(bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).secondaryHeaderColor : Colors.white,
        border: Border.all(
          color: isSelected ? Theme.of(context).secondaryHeaderColor : const Color(0xFFBCC7D9),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: isSelected
          ? const Icon(
              Icons.check_rounded,
              size: 12,
              color: Colors.white,
            )
          : null,
    );
  }

  Widget _buildCategoryFilters(TransactionViewModel provider, bool isMobile) {
    final auth = provider.authProvider;
    final user = auth.selectedUser!;
    final access = auth.accessList ?? [];

    bool hasAccess(String trs, String res) {
      final match = access.any((r) => r.URSTRS == trs && r.URSRES == res && r.URSDRO == '01');

      return user.USRTYPE == 2 || (user.USRTYPE == 1 && !match) || (user.USRTYPE == 0 && match);
    }

    final categories = <(String, bool, void Function(bool?))>[
      if (hasAccess('07', '01'))
        (
          'Clients',
          provider.clients,
          (v) => _update(provider, () => provider.clients = v!),
        ),
      if (hasAccess('07', '02'))
        (
          'Fournisseurs',
          provider.fournisseurs,
          (v) => _update(provider, () => provider.fournisseurs = v!),
        ),
      if (hasAccess('06', '02'))
        (
          'Employés',
          provider.employees,
          (v) => _update(provider, () => provider.employees = v!),
        ),
      if (hasAccess('07', '03'))
        (
          'Sans tiers',
          provider.sansTiers,
          (v) => _update(provider, () => provider.sansTiers = v!),
        ),
      (
        'Total Opérations Précédents',
        provider.totaloperations,
        (v) => _update(provider, () => provider.totaloperations = v!),
      ),
    ];

    return Wrap(
      spacing: isMobile ? 8 : 12,
      runSpacing: isMobile ? 8 : 12,
      children: categories.map((c) => _buildCategoryChip(c.$1, c.$2, c.$3, isMobile)).toList(),
    );
  }

  void _update(TransactionViewModel provider, VoidCallback action) {
    action();
    provider.notifyListeners();
  }

  Widget _buildCategoryChip(
    String label,
    bool isSelected,
    Function(bool?) onChanged,
    bool isMobile,
  ) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 14,
          vertical: isMobile ? 8 : 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).secondaryHeaderColor : Colors.white,
          border: Border.all(
            color: isSelected ? Theme.of(context).secondaryHeaderColor : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            Text(
              label,
              style: TextStyle(
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF4A5F7F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyButton(
    TransactionViewModel provider,
    BuildContext context,
    bool isMobile,
  ) {
    return SizedBox(
      width: double.infinity,
      height: isMobile ? 48 : 52,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            _focusScope?.unfocus();
            await provider.getTransactions(context);
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Appliquer les filtres',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: isMobile ? 14 : 15,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(width: isMobile ? 8 : 10),
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
