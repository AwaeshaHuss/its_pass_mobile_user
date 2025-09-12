import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itspass_user/core/constants/app_dimensions.dart';
import 'package:itspass_user/core/theme/app_theme.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double _currentBalance = 89.25;

  // Mock transaction data
  final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      type: TransactionType.ride,
      amount: -11.20,
      description: 'Trip to Downtown',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      status: TransactionStatus.completed,
    ),
    Transaction(
      id: '2',
      type: TransactionType.addMoney,
      amount: 35.50,
      description: 'Added via Credit Card',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: TransactionStatus.completed,
    ),
    Transaction(
      id: '3',
      type: TransactionType.ride,
      amount: -5.85,
      description: 'Trip to Airport',
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: TransactionStatus.completed,
    ),
    Transaction(
      id: '4',
      type: TransactionType.refund,
      amount: 8.90,
      description: 'Cancelled Trip Refund',
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: TransactionStatus.completed,
    ),
    Transaction(
      id: '5',
      type: TransactionType.ride,
      amount: -22.00,
      description: 'Trip to Mall',
      date: DateTime.now().subtract(const Duration(days: 4)),
      status: TransactionStatus.completed,
    ),
  ];

  Future<void> _refreshTransactions() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Refresh the UI
    setState(() {});
  }

  void _showAddMoneyDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddMoneyBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Wallet',
          style: AppTheme.headingStyle.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppTheme.textPrimaryColor,
            size: 20.sp,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTransactions,
        color: AppTheme.primaryColor,
        child: CustomScrollView(
          slivers: [
            // Balance Card Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingL),
                child: _buildBalanceCard(),
              ),
            ),

            // Add Money Button
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
                child: _buildAddMoneyButton(),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(height: AppDimensions.paddingL),
            ),

            // Transaction History Header
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: AppTheme.headingStyle.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all transactions
                      },
                      child: Text(
                        'View All',
                        style: AppTheme.bodyStyle.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Transaction List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= _transactions.length) return null;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingL,
                      vertical: AppDimensions.paddingXS,
                    ),
                    child: _buildTransactionItem(_transactions[index]),
                  );
                },
                childCount: _transactions.length,
              ),
            ),

            // Bottom spacing
            SliverToBoxAdapter(
              child: SizedBox(height: AppDimensions.paddingXL),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: AppDimensions.elevationL,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Balance',
                style: AppTheme.bodyStyle.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14.sp,
                ),
              ),
              Icon(
                Icons.account_balance_wallet,
                color: Colors.white.withOpacity(0.9),
                size: 24.sp,
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingS),
          Text(
            '${_currentBalance.toStringAsFixed(2)} JOD',
            style: AppTheme.headingStyle.copyWith(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.paddingXS),
          Text(
            'Available for rides',
            style: AppTheme.bodyStyle.copyWith(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoneyButton() {
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeightL,
      child: ElevatedButton.icon(
        onPressed: _showAddMoneyDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.successColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppTheme.successColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
        ),
        icon: Icon(
          Icons.add_circle_outline,
          size: 20.sp,
        ),
        label: Text(
          'Add Money',
          style: AppTheme.buttonTextStyle.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingS),
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Transaction Icon
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: _getTransactionIconColor(transaction.type).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getTransactionIcon(transaction.type),
              color: _getTransactionIconColor(transaction.type),
              size: 20.sp,
            ),
          ),
          SizedBox(width: AppDimensions.paddingM),

          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: AppTheme.bodyStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: AppDimensions.paddingXS / 2),
                Text(
                  _formatDate(transaction.date),
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.amount >= 0 ? '+' : ''}${transaction.amount.abs().toStringAsFixed(2)} JOD',
                style: AppTheme.bodyStyle.copyWith(
                  color: transaction.amount >= 0 
                      ? AppTheme.successColor 
                      : AppTheme.errorColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: AppDimensions.paddingXS / 2),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingS,
                  vertical: AppDimensions.paddingXS / 2,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(transaction.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Text(
                  _getStatusText(transaction.status),
                  style: AppTheme.bodyStyle.copyWith(
                    color: _getStatusColor(transaction.status),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.ride:
        return Icons.directions_car;
      case TransactionType.addMoney:
        return Icons.add_circle;
      case TransactionType.refund:
        return Icons.refresh;
    }
  }

  Color _getTransactionIconColor(TransactionType type) {
    switch (type) {
      case TransactionType.ride:
        return AppTheme.primaryColor;
      case TransactionType.addMoney:
        return AppTheme.successColor;
      case TransactionType.refund:
        return AppTheme.warningColor;
    }
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return AppTheme.successColor;
      case TransactionStatus.pending:
        return AppTheme.warningColor;
      case TransactionStatus.failed:
        return AppTheme.errorColor;
    }
  }

  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// Add Money Bottom Sheet
class AddMoneyBottomSheet extends StatefulWidget {
  const AddMoneyBottomSheet({super.key});

  @override
  State<AddMoneyBottomSheet> createState() => _AddMoneyBottomSheetState();
}

class _AddMoneyBottomSheetState extends State<AddMoneyBottomSheet> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedPaymentMethod = 'Credit Card';
  final List<String> _paymentMethods = ['Credit Card', 'Debit Card', 'PayPal', 'Bank Transfer'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXL),
          topRight: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: AppDimensions.paddingL),

            // Title
            Text(
              'Add Money to Wallet',
              style: AppTheme.headingStyle.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppDimensions.paddingL),

            // Amount Input
            Text(
              'Amount',
              style: AppTheme.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: AppDimensions.paddingS),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter amount',
                suffixText: ' JOD',
                prefixStyle: AppTheme.bodyStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  borderSide: BorderSide(color: AppTheme.primaryColor),
                ),
              ),
            ),
            SizedBox(height: AppDimensions.paddingL),

            // Payment Method
            Text(
              'Payment Method',
              style: AppTheme.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: AppDimensions.paddingS),
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedPaymentMethod,
                  isExpanded: true,
                  items: _paymentMethods.map((method) {
                    return DropdownMenuItem(
                      value: method,
                      child: Text(method),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: AppDimensions.paddingXL),

            // Add Money Button
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeightL,
              child: ElevatedButton(
                onPressed: () {
                  // Handle add money logic
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Money added successfully!'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                },
                style: AppTheme.primaryButtonStyle,
                child: Text(
                  'Add Money',
                  style: AppTheme.buttonTextStyle,
                ),
              ),
            ),
            SizedBox(height: AppDimensions.paddingL),
          ],
        ),
      ),
    );
  }
}

// Transaction Model
class Transaction {
  final String id;
  final TransactionType type;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionStatus status;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
    required this.status,
  });
}

enum TransactionType {
  ride,
  addMoney,
  refund,
}

enum TransactionStatus {
  completed,
  pending,
  failed,
}
