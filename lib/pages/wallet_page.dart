import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itspass_user/core/constants/app_dimensions.dart';
import 'package:itspass_user/core/theme/app_theme.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  // Mock wallet data
  final double currentBalance = 125.50;
  final List<Map<String, dynamic>> recentTransactions = [
    {
      'id': '1',
      'type': 'ride',
      'description': 'Trip to Downtown',
      'amount': -15.75,
      'date': '2024-01-15',
      'time': '14:30',
      'icon': Icons.directions_car,
    },
    {
      'id': '2',
      'type': 'topup',
      'description': 'Wallet Top-up',
      'amount': 50.00,
      'date': '2024-01-14',
      'time': '09:15',
      'icon': Icons.add_circle,
    },
    {
      'id': '3',
      'type': 'ride',
      'description': 'Trip to Airport',
      'amount': -28.25,
      'date': '2024-01-13',
      'time': '16:45',
      'icon': Icons.directions_car,
    },
    {
      'id': '4',
      'type': 'refund',
      'description': 'Trip Refund',
      'amount': 12.50,
      'date': '2024-01-12',
      'time': '11:20',
      'icon': Icons.refresh,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: AppDimensions.elevationM,
        centerTitle: true,
        title: Text(
          "My Wallet",
          style: AppTheme.titleStyle.copyWith(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppDimensions.paddingL),
              
              // Balance Card
              _buildBalanceCard(),
              
              SizedBox(height: AppDimensions.paddingXL),
              
              // Action Buttons
              _buildActionButtons(),
              
              SizedBox(height: AppDimensions.paddingXL),
              
              // Recent Transactions Section
              Text(
                "Recent Transactions",
                style: AppTheme.titleStyle.copyWith(
                  fontSize: AppDimensions.fontSizeXL,
                ),
              ),
              
              SizedBox(height: AppDimensions.paddingM),
              
              // Transactions List
              _buildTransactionsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: AppDimensions.elevationL,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
            size: AppDimensions.iconSizeXXL,
          ),
          SizedBox(height: AppDimensions.paddingM),
          Text(
            "Current Balance",
            style: AppTheme.bodyStyle.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: AppDimensions.fontSizeL,
            ),
          ),
          SizedBox(height: AppDimensions.paddingS),
          Text(
            "\$${currentBalance.toStringAsFixed(2)}",
            style: AppTheme.headingStyle.copyWith(
              color: Colors.white,
              fontSize: AppDimensions.fontSizeHeading + 4.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.add,
            label: "Add Money",
            color: AppTheme.successColor,
            onTap: () {
              // TODO: Implement add money functionality
              _showComingSoonDialog("Add Money");
            },
          ),
        ),
        SizedBox(width: AppDimensions.paddingM),
        Expanded(
          child: _buildActionButton(
            icon: Icons.send,
            label: "Send Money",
            color: AppTheme.infoColor,
            onTap: () {
              // TODO: Implement send money functionality
              _showComingSoonDialog("Send Money");
            },
          ),
        ),
        SizedBox(width: AppDimensions.paddingM),
        Expanded(
          child: _buildActionButton(
            icon: Icons.history,
            label: "History",
            color: AppTheme.warningColor,
            onTap: () {
              // TODO: Implement full history functionality
              _showComingSoonDialog("Full History");
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppDimensions.paddingL,
          horizontal: AppDimensions.paddingM,
        ),
        decoration: AppTheme.cardDecoration.copyWith(
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: AppDimensions.iconSizeL,
              ),
            ),
            SizedBox(height: AppDimensions.paddingS),
            Text(
              label,
              style: AppTheme.captionStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentTransactions.length,
      separatorBuilder: (context, index) => SizedBox(height: AppDimensions.paddingM),
      itemBuilder: (context, index) {
        final transaction = recentTransactions[index];
        return _buildTransactionItem(transaction);
      },
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final bool isPositive = transaction['amount'] > 0;
    final Color amountColor = isPositive ? AppTheme.successColor : AppTheme.errorColor;
    final String amountText = "${isPositive ? '+' : ''}\$${transaction['amount'].abs().toStringAsFixed(2)}";

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          // Transaction Icon
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: _getTransactionColor(transaction['type']).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              transaction['icon'],
              color: _getTransactionColor(transaction['type']),
              size: AppDimensions.iconSizeL,
            ),
          ),
          
          SizedBox(width: AppDimensions.paddingM),
          
          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['description'],
                  style: AppTheme.bodyStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppDimensions.paddingXS),
                Text(
                  "${transaction['date']} • ${transaction['time']}",
                  style: AppTheme.captionStyle,
                ),
              ],
            ),
          ),
          
          // Transaction Amount
          Text(
            amountText,
            style: AppTheme.bodyStyle.copyWith(
              color: amountColor,
              fontWeight: FontWeight.bold,
              fontSize: AppDimensions.fontSizeL,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTransactionColor(String type) {
    switch (type) {
      case 'ride':
        return AppTheme.primaryColor;
      case 'topup':
        return AppTheme.successColor;
      case 'refund':
        return AppTheme.infoColor;
      default:
        return AppTheme.textSecondaryColor;
    }
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          title: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppTheme.infoColor,
                size: AppDimensions.iconSizeL,
              ),
              SizedBox(width: AppDimensions.paddingS),
              Text(
                "Coming Soon",
                style: AppTheme.titleStyle,
              ),
            ],
          ),
          content: Text(
            "$feature functionality will be available in a future update.",
            style: AppTheme.bodyStyle,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "OK",
                style: AppTheme.bodyStyle.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
