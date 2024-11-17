import 'package:criptop/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

 @override
  Widget build(BuildContext context) {
     WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().fetchCurrentUser(context);
    });
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              final user = authProvider.currentUser;
              print("current user: $user");
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(user),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  _buildBalanceCard(),
                  _buildStakeCard(),
                  _buildReferIdCard(1),
                ],
                  ),
                  const SizedBox(height: 20),
                  _buildClaimSection(context),
                  const SizedBox(height: 20),
                  _buildActionButtons(),
                  const SizedBox(height: 20),
                  _buildSocialIcons(),
                  const SizedBox(height: 20),
                  _buildAirdropProjects(user),
                ],
              );
            },
          ),
        ),
      ),
    );
  }


Widget _buildHeader(Map<String, dynamic> user) {
    final email = user['email'] ?? 'Guest';
    final firstPart = email.split('@').first;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              firstPart,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        Icon(Icons.notifications, color: Colors.yellow[600]),
      ],
    );
  }
  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[900],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Column(
        children: [
          Text('Balance', style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          Text('\$0.00', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

Widget _buildStakeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[900],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Column(
        children: [
          Text('Stake', style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          Text('\$0.00', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

 Widget _buildReferIdCard(int id) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[900],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text('Refer ID', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text('$id', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

Widget _buildClaimSection(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text('24:00:00', style: TextStyle(fontSize: 24, color: Colors.yellow)),
      GestureDetector(
        onTap: () {
          context.read<AuthProvider>().claimReward(context);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.yellow),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text('Claim', style: TextStyle(color: Colors.yellow)),
        ),
      ),
    ],
  );
}

  Widget _buildActionButtons() {
    final actions = ['Withdraw', 'Deposit', 'Stake', 'Swap', 'Mates'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: actions.map((action) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.teal[700],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconForAction(action),
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(action, style: const TextStyle(fontSize: 12)),
        ],
      )).toList(),
    );
  }

  IconData _getIconForAction(String action) {
    switch (action) {
      case 'Withdraw': return Icons.account_balance_wallet;
      case 'Deposit': return Icons.add;
      case 'Stake': return Icons.pie_chart;
      case 'Swap': return Icons.swap_horiz;
      case 'Mates': return Icons.people;
      default: return Icons.help_outline;
    }
  }

  Widget _buildSocialIcons() {
    final socialIcons = [Icons.language, Icons.facebook, Icons.camera_alt, Icons.close, Icons.send, Icons.chat_bubble, Icons.play_arrow];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: socialIcons.map((icon) => Icon(icon, color: Colors.grey[400])).toList(),
    );
  }

Widget _buildAirdropProjects(Map<String, dynamic> user) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Airdrop Projects', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      _buildProjectRow('Criptop', user['criptop_balance']?.toString() ?? '0.00', '10% extra'),
      _buildProjectRow('CCUSD', user['ccusd_balance']?.toString() ?? '0.00', 'Not applicable'),
      _buildProjectRow('Happy Goat', 'Coming Soon', ''),
      _buildProjectRow('Crystal', 'Coming Soon', ''),
    ],
  );
}
Widget _buildProjectRow(String name, String balance, String bonus) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              color: Colors.grey[800],
              margin: const EdgeInsets.only(right: 12),
            ),
            Text(name),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(balance, style: TextStyle(fontWeight: FontWeight.bold)),
            if (bonus.isNotEmpty)
              Text(bonus, style: TextStyle(color: Colors.green[400], fontSize: 12)),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildBottomNavBar() {
    final navItems = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.assignment, 'label': 'Task'},
      {'icon': Icons.settings, 'label': 'Settings'},
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: navItems.map((item) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item['icon'] as IconData, color: Colors.grey[600]),
          Text(item['label'] as String, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      )).toList(),
    );
  }

}