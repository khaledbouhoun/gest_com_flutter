import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestion_stock/view_models/transaction_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ✨ MODERN SCROLL-RESPONSIVE TRANSACTION SCREEN WITH PROFESSIONAL ANIMATIONS

class ModernTransactionScreen extends StatefulWidget {
  const ModernTransactionScreen({super.key});

  @override
  State<ModernTransactionScreen> createState() => _ModernTransactionScreenState();
}

class _ModernTransactionScreenState extends State<ModernTransactionScreen> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _headerFadeController;
  late AnimationController _fabScaleController;

  double _scrollOffset = 0;
  double _scrollVelocity = 0;
  bool _isHeaderVisible = true;
  bool _isFooterVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);

    // Header fade animation (smooth, 300ms)
    _headerFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // FAB scale animation (snappy, 250ms)
    _fabScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _fabScaleController.forward();
  }

  void _handleScroll() {
    final newOffset = _scrollController.offset;
    _scrollVelocity = newOffset - _scrollOffset;
    _scrollOffset = newOffset;

    // Header visibility logic (hide/show based on scroll)
    bool shouldShowHeader = _scrollVelocity <= 5;

    if (shouldShowHeader != _isHeaderVisible) {
      setState(() => _isHeaderVisible = shouldShowHeader);

      if (_isHeaderVisible) {
        _headerFadeController.forward();
      } else {
        _headerFadeController.reverse();
      }
    }

    // Footer visibility (show/hide footer when scrolling)
    bool shouldShowFooter =
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 || _scrollVelocity <= 5;

    if (shouldShowFooter != _isFooterVisible) {
      setState(() => _isFooterVisible = shouldShowFooter);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _headerFadeController.dispose();
    _fabScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final formatter = NumberFormat();

    return RefreshIndicator(
      color: Theme.of(context).secondaryHeaderColor,
      strokeWidth: 3.0,
      // ✨ Modern refresh indicator with custom trigger
      onRefresh: () async {
        await Provider.of<TransactionViewModel>(context, listen: false).getTransactions(context);
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
          // ✨ Modern floating action button with physics
          floatingActionButton: _buildModernFAB(context),
          body: SafeArea(
            child: Stack(
              children: [
                // Background gradient (subtle, modern)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withValues(alpha: 0.98),
                      ],
                    ),
                  ),
                ),

                // Main content
                Column(
                  children: [
                    // ✨ Scroll-responsive header with parallax
                    _buildModernHeader(width, context),

                    // Main transaction list with smooth scroll
                    Expanded(
                      child: _buildTransactionListWithAnimations(
                        width,
                        height,
                        formatter,
                      ),
                    ),

                    // ✨ Animated footer that responds to scroll
                    _buildAnimatedFooter(width, formatter, context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✨ MODERN HEADER WITH PARALLAX SCROLL EFFECT
  Widget _buildModernHeader(double width, BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _headerFadeController, curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.05)).animate(
          CurvedAnimation(parent: _headerFadeController, curve: Curves.easeOut),
        ),
        child: Transform.translate(
          offset: Offset(0, -_scrollOffset * 0.1), // Parallax effect
          child: Container(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: width * 0.04,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).secondaryHeaderColor,
                  Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.85),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white.withValues(alpha: 0.8),
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'Transactions',
                    style: TextStyle(
                      fontSize: width * 0.08,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                SizedBox(height: width * 0.02),
                Text(
                  'Your financial overview',
                  style: TextStyle(
                    fontSize: width * 0.035,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✨ MODERN FAB WITH INTERACTIVE SCALE ANIMATION
  Widget _buildModernFAB(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _fabScaleController, curve: Curves.elasticOut),
      ),
    );
  }

  // ✨ TRANSACTION LIST WITH STAGGERED ANIMATIONS
  Widget _buildTransactionListWithAnimations(
    double width,
    double height,
    NumberFormat formatter,
  ) {
    return Consumer<TransactionViewModel>(
      builder: (context, provider, child) {
        if (provider.statusCode != 200) {
          return _buildEmptyState(width, height);
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            // Trigger animations on scroll
            setState(() {});
            return false;
          },
          child: ListView.builder(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: width * 0.03,
            ),
            itemCount: provider.filteredTransactions.length,
            itemBuilder: (context, index) {
              return _buildTransactionItemWithAnimation(
                provider.filteredTransactions[index],
                width,
                formatter,
                index,
              );
            },
          ),
        );
      },
    );
  }

  // ✨ INDIVIDUAL TRANSACTION ITEM WITH MODERN ANIMATION
  Widget _buildTransactionItemWithAnimation(
    dynamic transaction,
    double width,
    NumberFormat formatter,
    int index,
  ) {
    // Calculate animation delay for stagger effect
    final delay = index * 30; // 30ms delay per item

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: width * 0.03),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.08),
              Colors.white.withValues(alpha: 0.04),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              // Haptic feedback
              HapticFeedback.lightImpact();
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(width * 0.04),
              child: Row(
                children: [
                  // ✨ Modern icon with gradient background
                  Container(
                    width: width * 0.12,
                    height: width * 0.12,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          transaction['isDebit']
                              ? const Color(0xFF4CAF50).withValues(alpha: 0.2)
                              : const Color(0xFFFF5252).withValues(alpha: 0.2),
                          transaction['isDebit']
                              ? const Color(0xFF45A049).withValues(alpha: 0.1)
                              : const Color(0xFFE53935).withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      transaction['isDebit'] ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                      color: transaction['isDebit'] ? const Color(0xFF4CAF50) : const Color(0xFFFF5252),
                      size: width * 0.06,
                    ),
                  ),
                  SizedBox(width: width * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction['title'] ?? 'Transaction',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.04,
                          ),
                        ),
                        SizedBox(height: width * 0.01),
                        Text(
                          transaction['date'] ?? 'N/A',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w400,
                            fontSize: width * 0.032,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${transaction['isDebit'] ? '+' : '-'}${formatter.format(transaction['amount'] ?? 0)}',
                    style: TextStyle(
                      color: transaction['isDebit'] ? const Color(0xFF4CAF50) : const Color(0xFFFF5252),
                      fontWeight: FontWeight.w700,
                      fontSize: width * 0.042,
                      letterSpacing: 0.5,
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

  // ✨ MODERN ANIMATED FOOTER/SUMMARY
  Widget _buildAnimatedFooter(
    double width,
    NumberFormat formatter,
    BuildContext context,
  ) {
    return Consumer<TransactionViewModel>(
      builder: (context, provider, child) {
        if (provider.statusCode != 200) {
          return const SizedBox.shrink();
        }

        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _headerFadeController,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _headerFadeController,
                curve: Curves.easeOut,
              ),
            ),
            child: Container(
              width: width,
              margin: EdgeInsets.all(width * 0.04),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).secondaryHeaderColor.withValues(
                          alpha: 0.15,
                        ),
                    Theme.of(context).secondaryHeaderColor.withValues(
                          alpha: 0.08,
                        ),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).secondaryHeaderColor.withValues(
                          alpha: 0.2,
                        ),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.04),
                  child: Column(
                    children: [
                      // Totals row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSummaryItem(
                            'Debit',
                            '+${formatter.format(provider.totalDebit)}',
                            const Color(0xFF4CAF50),
                            width,
                          ),
                          Container(
                            width: 1,
                            height: width * 0.08,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withValues(alpha: 0.0),
                                  Colors.white.withValues(alpha: 0.1),
                                  Colors.white.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                          _buildSummaryItem(
                            'Credit',
                            '-${formatter.format(provider.totalCredit)}',
                            const Color(0xFFFF5252),
                            width,
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.04),
                      // Balance display with animation
                      Container(
                        padding: EdgeInsets.all(width * 0.04),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.08),
                              Colors.white.withValues(alpha: 0.03),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
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
                                  color: Colors.white.withValues(alpha: 0.9),
                                  size: width * 0.06,
                                ),
                                SizedBox(width: width * 0.03),
                                Text(
                                  'Balance',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w600,
                                    fontSize: width * 0.04,
                                  ),
                                ),
                              ],
                            ),
                            TweenAnimationBuilder<double>(
                              tween: Tween(
                                begin: 0.0,
                                end: provider.totalDebit - provider.totalCredit,
                              ),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Text(
                                  formatter.format(value.toInt()),
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.95),
                                    fontWeight: FontWeight.w800,
                                    fontSize: width * 0.05,
                                    letterSpacing: 0.5,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ✨ SUMMARY ITEM BUILDER
  Widget _buildSummaryItem(
    String label,
    String value,
    Color color,
    double width,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: width * 0.032,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: width * 0.01),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: width * 0.04,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  // ✨ EMPTY STATE WITH ANIMATION
  Widget _buildEmptyState(double width, double height) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: width * 0.2,
            height: width * 0.2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.inbox_rounded,
              size: width * 0.1,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(height: width * 0.05),
          Text(
            'No Transactions',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: width * 0.045,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: width * 0.02),
          Text(
            'Your transactions will appear here',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: width * 0.035,
            ),
          ),
        ],
      ),
    );
  }
}
