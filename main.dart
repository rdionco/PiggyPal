import 'package:material_ui/material_ui.dart';
void main() {
  runApp(const PiggyPalApp());
}

// --- THEME COLORS ---
class AppColors {
  static const Color primaryBrown = Color(0xFF8A4700);
  static const Color backgroundCream = Color(0xFFFFFBF7);
  static const Color surfaceTan = Color(0xFFF2E4D7);
  static const Color peachLight = Color(0xFFFFE1C6);
  static const Color accentOrange = Color(0xFFF79000);
  static const Color textDark = Color(0xFF1F160E);
  static const Color textMuted = Color(0xFF7A6A5C);
  static const Color borderSubtle = Color(0xFFE4D5C7);
  static const Color dangerRed = Color(0xFFB3261E);
}

class PiggyPalApp extends StatelessWidget {
  const PiggyPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PiggyPal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundCream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBrown,
          primary: AppColors.primaryBrown,
          surface: AppColors.backgroundCream,
        ),
        fontFamily: 'sans-serif',
      ),
      home: const AuthFlowScreen(),
    );
  }
}

// ============================================================================
// 1. AUTHENTICATION FLOW (Login, Sign Up, Forgot Password)
// ============================================================================

enum AuthMode { login, signup, forgotPassword }

class AuthFlowScreen extends StatefulWidget {
  const AuthFlowScreen({super.key});

  @override
  State<AuthFlowScreen> createState() => _AuthFlowScreenState();
}

class _AuthFlowScreenState extends State<AuthFlowScreen> {
  AuthMode _mode = AuthMode.login;
  bool _obscurePassword = true;

  String _savedName = 'rein';
  String _savedEmail = 'rein.dionco@gmail.com';
  String _savedPassword = 'password123';
  String _savedPet = 'brownie';

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _petCtrl = TextEditingController();

  void _navigateToDashboard() {
    final name = _nameCtrl.text.trim().isNotEmpty
        ? _nameCtrl.text.trim()
        : _savedName;
    final email = _emailCtrl.text.trim().isNotEmpty
        ? _emailCtrl.text.trim()
        : _savedEmail;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MainDashboardScreen(
          initialUserName: name,
          initialUserEmail: email,
          initialPassword: _savedPassword,
        ),
      ),
    );
  }

  void _handleAuthSubmit() {
    if (_mode == AuthMode.login) {
      _navigateToDashboard();
    } else if (_mode == AuthMode.signup) {
      if (_nameCtrl.text.isNotEmpty) _savedName = _nameCtrl.text.trim();
      if (_emailCtrl.text.isNotEmpty) _savedEmail = _emailCtrl.text.trim();
      if (_passCtrl.text.isNotEmpty) _savedPassword = _passCtrl.text;
      if (_petCtrl.text.isNotEmpty) {
        _savedPet = _petCtrl.text.trim().toLowerCase();
      }
      _navigateToDashboard();
    } else if (_mode == AuthMode.forgotPassword) {
      if (_petCtrl.text.trim().toLowerCase() == _savedPet ||
          _petCtrl.text.isNotEmpty) {
        if (_passCtrl.text.isNotEmpty) _savedPassword = _passCtrl.text;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated! Please log in.')),
        );
        setState(() => _mode = AuthMode.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLogin = _mode == AuthMode.login;
    final bool isSignup = _mode == AuthMode.signup;

    String subtitle = 'Know where your money goes.';
    if (isSignup) subtitle = 'Create your account';
    if (_mode == AuthMode.forgotPassword) subtitle = 'Reset your password';

    return Scaffold(
      backgroundColor: AppColors.primaryBrown,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isLogin ? 44 : 32,
                horizontal: 24,
              ),
              child: Column(
                children: [
                  if (isLogin) ...[
                    Container(
                      width: 68,
                      height: 68,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: AppColors.primaryBrown,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  const Text(
                    'PiggyPal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.backgroundCream,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLogin
                          ? 'Log in'
                          : isSignup
                              ? 'Sign up'
                              : 'Forgot password',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 22),
                    if (isSignup) ...[
                      _buildLabel('Name'),
                      _buildInputField(
                        controller: _nameCtrl,
                        hint: 'Your name',
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 16),
                    ],
                    _buildLabel('Email'),
                    _buildInputField(
                      controller: _emailCtrl,
                      hint: 'name@email.com',
                      icon: isLogin ? Icons.mail_outline_rounded : null,
                    ),
                    const SizedBox(height: 16),
                    if (_mode == AuthMode.forgotPassword) ...[
                      _buildLabel("What was your first pet's name?"),
                      _buildInputField(
                        controller: _petCtrl,
                        hint: 'Your recovery answer',
                      ),
                      const SizedBox(height: 16),
                    ],
                    _buildLabel(
                      _mode == AuthMode.forgotPassword
                          ? 'New password'
                          : 'Password',
                    ),
                    _buildInputField(
                      controller: _passCtrl,
                      hint: isLogin
                          ? 'Enter your password'
                          : 'At least 6 characters',
                      icon: _mode == AuthMode.forgotPassword
                          ? null
                          : Icons.lock_outline_rounded,
                      obscure: _obscurePassword,
                      suffixIcon: _mode == AuthMode.forgotPassword
                          ? null
                          : IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                    ),
                    if (isLogin) ...[
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => setState(
                            () => _mode = AuthMode.forgotPassword,
                          ),
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: AppColors.primaryBrown,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (isSignup) ...[
                      const SizedBox(height: 16),
                      _buildLabel('Confirm password'),
                      _buildInputField(
                        controller: _confirmPassCtrl,
                        hint: 'Re-enter your password',
                        icon: Icons.lock_outline_rounded,
                        obscure: true,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel(
                        "Recovery question: What was your first pet's name?",
                      ),
                      _buildInputField(
                        controller: _petCtrl,
                        hint: 'Used to reset your password',
                        icon: Icons.help_outline_rounded,
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _handleAuthSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBrown,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          isLogin
                              ? 'Log in'
                              : isSignup
                                  ? 'Create account'
                                  : 'Reset password',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: isLogin
                          ? GestureDetector(
                              onTap: () =>
                                  setState(() => _mode = AuthMode.signup),
                              child: RichText(
                                text: const TextSpan(
                                  text: 'New to PiggyPal? ',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 13,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Create an account',
                                      style: TextStyle(
                                        color: AppColors.primaryBrown,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : TextButton(
                              onPressed: () =>
                                  setState(() => _mode = AuthMode.login),
                              child: const Text(
                                'Back to log in',
                                style: TextStyle(
                                  color: AppColors.primaryBrown,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontSize: 14, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFA69280), fontSize: 14),
        filled: true,
        fillColor: AppColors.surfaceTan,
        prefixIcon: icon != null
            ? Icon(icon, color: AppColors.textMuted, size: 20)
            : null,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// ============================================================================
// 2. DATA MODELS
// ============================================================================

class WalletItem {
  String id;
  String name;
  double balance;

  WalletItem({required this.id, required this.name, required this.balance});
}

class TransactionItem {
  final String id;
  final String type;
  final double amount;
  final String wallet;
  final String category;
  final String note;
  final String date;

  TransactionItem({
    required this.id,
    required this.type,
    required this.amount,
    required this.wallet,
    required this.category,
    required this.note,
    required this.date,
  });
}

class BudgetCategory {
  String name;
  double limit;

  BudgetCategory({required this.name, this.limit = 0.0});
}

class BillItem {
  String id;
  String name;
  double amount;
  String wallet;
  String category;
  String repeats; // Monthly / Weekly
  String dueDate;

  BillItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.wallet,
    required this.category,
    required this.repeats,
    required this.dueDate,
  });
}

class UtangItem {
  String id;
  String type; // 'I lent' or 'I borrowed'
  String person;
  double amount;
  String wallet;
  String dueDate;
  bool settled;

  UtangItem({
    required this.id,
    required this.type,
    required this.person,
    required this.amount,
    required this.wallet,
    required this.dueDate,
    this.settled = false,
  });
}

class GoalItem {
  String id;
  String name;
  double targetAmount;
  double savedAmount;
  String targetDate;

  GoalItem({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.savedAmount = 0.0,
    required this.targetDate,
  });
}

// ============================================================================
// 3. MAIN DASHBOARD SHELL (Left Nav + Right Profile Drawer)
// ============================================================================

class MainDashboardScreen extends StatefulWidget {
  final String initialUserName;
  final String initialUserEmail;
  final String initialPassword;

  const MainDashboardScreen({
    super.key,
    this.initialUserName = 'rein',
    this.initialUserEmail = 'rein.dionco@gmail.com',
    this.initialPassword = 'password123',
  });

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // 0..5 = Sidebar Tabs, 6 = Account Page
  int _selectedIndex = 0;

  late String _userName;
  late String _userEmail;
  late String _userPassword;

  List<WalletItem> _wallets = [
    WalletItem(id: '1', name: 'Cash', balance: 0.00),
    WalletItem(id: '2', name: 'GCash', balance: 0.00),
  ];

  List<TransactionItem> _transactions = [];

  List<BudgetCategory> _categories = [
    BudgetCategory(name: 'Food', limit: 0.0),
    BudgetCategory(name: 'Bills', limit: 0.0),
    BudgetCategory(name: 'Transport', limit: 0.0),
    BudgetCategory(name: 'Personal', limit: 0.0),
    BudgetCategory(name: 'Gifts', limit: 0.0),
  ];

  List<BillItem> _bills = [];
  List<UtangItem> _utangs = [];
  List<GoalItem> _goals = [];

  String _cycleStart = '2026-11-16';
  String _cycleEnd = '2026-11-30';

  List<Map<String, dynamic>> get _navItems => [
    {
      'label': 'Wallets',
      'title': 'PiggyPal',
      'icon': Icons.account_balance_wallet_outlined,
    },
    {
      'label': 'Spend',
      'title': 'Transactions',
      'icon': Icons.swap_horiz_rounded,
    },
    {
      'label': 'Budget',
      'title': 'Budget',
      'icon': Icons.pie_chart_outline_rounded,
    },
    {
      'label': 'Bills',
      'title': 'Bills',
      'icon': Icons.receipt_long_outlined,
    },
    {
      'label': 'Utang',
      'title': 'Utang',
      'icon': Icons.people_outline_rounded,
    },
    {
      'label': 'Goals',
      'title': 'Savings goals',
      'icon': Icons.flag_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    _userName = widget.initialUserName;
    _userEmail = widget.initialUserEmail;
    _userPassword = widget.initialPassword;
  }

  double get _totalBalance =>
      _wallets.fold(0.0, (sum, w) => sum + w.balance);

  double get _totalDailySafeSpend {
    final totalLimit = _categories.fold<double>(
      0.0,
      (sum, c) => sum + c.limit,
    );
    if (totalLimit <= 0) return 0.0;
    return totalLimit / 15.0;
  }

  void _addTransaction(TransactionItem tx) {
    setState(() {
      _transactions.insert(0, tx);
      if (_wallets.isNotEmpty) {
        final wallet = _wallets.firstWhere(
          (w) => w.name == tx.wallet,
          orElse: () => _wallets.first,
        );
        if (tx.type == 'Expense' || tx.type == 'Split expense') {
          wallet.balance -= tx.amount;
        } else if (tx.type == 'Income') {
          wallet.balance += tx.amount;
        }
      }
    });
  }

  void _clearAllData() {
    setState(() {
      _wallets = [
        WalletItem(id: '1', name: 'Cash', balance: 0.00),
        WalletItem(id: '2', name: 'GCash', balance: 0.00),
      ];
      _transactions = [];
      _categories = [
        BudgetCategory(name: 'Food', limit: 0.0),
        BudgetCategory(name: 'Bills', limit: 0.0),
        BudgetCategory(name: 'Transport', limit: 0.0),
        BudgetCategory(name: 'Personal', limit: 0.0),
        BudgetCategory(name: 'Gifts', limit: 0.0),
      ];
      _bills = [];
      _utangs = [];
      _goals = [];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All PiggyPal data has been cleared.')),
    );
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 36),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 18),
              InkWell(
                onTap: () {
                  Navigator.pop(ctx);
                  _clearAllData();
                },
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.dangerRed,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Clear all my data',
                        style: TextStyle(
                          color: AppColors.dangerRed,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 460),
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About PiggyPal',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                const Text(
                  'PiggyPal helps you track wallets, daily safe-to-spend limits, pay-cycle budgets, recurring bills, utang, and savings goals in one place.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13.5),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBrown,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 760;
    final currentTitle = _selectedIndex == 6
        ? 'Account'
        : _navItems[_selectedIndex]['title'] as String;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isWide ? null : Drawer(child: _buildSidebar(isDrawer: true)),
      endDrawer: _buildRightProfileDrawer(),
      body: Row(
        children: [
          if (isWide) SizedBox(width: 240, child: _buildSidebar(isDrawer: false)),
          Expanded(
            child: Column(
              children: [
                // Top Brown Bar
                Container(
                  height: 64,
                  color: AppColors.primaryBrown,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      children: [
                        if (!isWide)
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () =>
                                _scaffoldKey.currentState?.openDrawer(),
                            tooltip: 'Navigation',
                          ),
                        Expanded(
                          child: Text(
                            currentTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.menu_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () =>
                              _scaffoldKey.currentState?.openEndDrawer(),
                          tooltip: 'Account & Settings',
                        ),
                      ],
                    ),
                  ),
                ),

                // Active Page
                Expanded(child: _buildCurrentTab()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar({required bool isDrawer}) {
    return Container(
      color: AppColors.primaryBrown,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                'PiggyPal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 18),
            ...List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final selected = _selectedIndex == index;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Material(
                  color: selected ? AppColors.peachLight : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      setState(() => _selectedIndex = index);
                      if (isDrawer) Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item['icon'] as IconData,
                            size: 20,
                            color: selected
                                ? AppColors.primaryBrown
                                : Colors.white,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            item['label'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: selected
                                  ? AppColors.primaryBrown
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRightProfileDrawer() {
    final initial =
        _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U';

    return Drawer(
      width: 280,
      backgroundColor: AppColors.backgroundCream,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brown Top Header Block
          Container(
            width: double.infinity,
            color: AppColors.primaryBrown,
            padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initial,
                      style: const TextStyle(
                        color: AppColors.primaryBrown,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _userEmail,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Options
          const SizedBox(height: 12),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            leading: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.primaryBrown,
              size: 22,
            ),
            title: const Text(
              'Account',
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
              setState(() => _selectedIndex = 6);
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            leading: const Icon(
              Icons.settings_outlined,
              color: AppColors.primaryBrown,
              size: 22,
            ),
            title: const Text(
              'Settings',
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
              _showSettingsSheet();
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            leading: const Icon(
              Icons.info_outline_rounded,
              color: AppColors.primaryBrown,
              size: 22,
            ),
            title: const Text(
              'About',
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.pop(context);
              _showAboutSheet();
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            leading: const Icon(
              Icons.logout_rounded,
              color: AppColors.dangerRed,
              size: 22,
            ),
            title: const Text(
              'Log out',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: AppColors.dangerRed,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const AuthFlowScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_selectedIndex) {
      case 0:
        return WalletsTab(
          wallets: _wallets,
          totalBalance: _totalBalance,
          dailySafeSpend: _totalDailySafeSpend,
          onAddWallet: (name, bal) {
            setState(() {
              _wallets.add(
                WalletItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  balance: bal,
                ),
              );
            });
          },
          onEditWallet: (wallet, name, bal) {
            setState(() {
              wallet.name = name;
              wallet.balance = bal;
            });
          },
          onDeleteWallet: (wallet) {
            setState(() => _wallets.remove(wallet));
          },
        );
      case 1:
        return SpendTab(
          wallets: _wallets,
          categories: _categories,
          transactions: _transactions,
          onAddTransaction: _addTransaction,
        );
      case 2:
        return BudgetTab(
          cycleStart: _cycleStart,
          cycleEnd: _cycleEnd,
          categories: _categories,
          transactions: _transactions,
          onUpdateCycle: (start, end) {
            setState(() {
              _cycleStart = start;
              _cycleEnd = end;
            });
          },
          onUpdateCategory: (cat, name, limit) {
            setState(() {
              cat.name = name;
              cat.limit = limit;
            });
          },
          onDeleteCategory: (cat) {
            setState(() => _categories.remove(cat));
          },
          onAddCategory: (name, limit) {
            setState(() {
              _categories.add(BudgetCategory(name: name, limit: limit));
            });
          },
        );
      case 3:
        return BillsTab(
          bills: _bills,
          wallets: _wallets,
          categories: _categories,
          onAddBill: (bill) => setState(() => _bills.add(bill)),
          onDeleteBill: (bill) => setState(() => _bills.remove(bill)),
          onPayBill: (bill) {
            _addTransaction(
              TransactionItem(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                type: 'Expense',
                amount: bill.amount,
                wallet: bill.wallet,
                category: bill.category,
                note: 'Bill: ${bill.name}',
                date: bill.dueDate,
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Paid ${bill.name} (₱${bill.amount.toStringAsFixed(2)}) from ${bill.wallet}',
                ),
              ),
            );
          },
        );
      case 4:
        return UtangTab(
          utangs: _utangs,
          wallets: _wallets,
          onAddUtang: (u) => setState(() => _utangs.add(u)),
          onToggleSettle: (u) => setState(() => u.settled = !u.settled),
          onDeleteUtang: (u) => setState(() => _utangs.remove(u)),
        );
      case 5:
        return GoalsTab(
          goals: _goals,
          onAddGoal: (g) => setState(() => _goals.add(g)),
          onAddFunds: (g, amt) => setState(() => g.savedAmount += amt),
          onDeleteGoal: (g) => setState(() => _goals.remove(g)),
        );
      case 6:
        return AccountTab(
          userName: _userName,
          userEmail: _userEmail,
          onUpdateName: (newName) => setState(() => _userName = newName),
          onUpdatePassword: (newPass) {
            setState(() => _userPassword = newPass);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password updated successfully.')),
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ============================================================================
// 4. WALLETS TAB & MODALS
// ============================================================================

class WalletsTab extends StatelessWidget {
  final List<WalletItem> wallets;
  final double totalBalance;
  final double dailySafeSpend;
  final Function(String name, double balance) onAddWallet;
  final Function(WalletItem wallet, String name, double balance) onEditWallet;
  final Function(WalletItem wallet) onDeleteWallet;

  const WalletsTab({
    super.key,
    required this.wallets,
    required this.totalBalance,
    required this.dailySafeSpend,
    required this.onAddWallet,
    required this.onEditWallet,
    required this.onDeleteWallet,
  });

  void _showWalletSheet(BuildContext context, {WalletItem? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final balCtrl = TextEditingController(
      text: existing != null ? existing.balance.toStringAsFixed(0) : '0',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  existing == null ? 'New wallet' : 'Edit ${existing.name}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Name',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    hintText: 'e.g. Bank 1',
                    filled: true,
                    fillColor: AppColors.surfaceTan,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.textDark,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  existing == null
                      ? 'Starting balance (₱)'
                      : 'Current balance (₱)',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: balCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surfaceTan,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.peachLight,
                            foregroundColor: AppColors.primaryBrown,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            final name = nameCtrl.text.trim();
                            final val = double.tryParse(balCtrl.text) ?? 0.0;
                            if (name.isNotEmpty) {
                              if (existing == null) {
                                onAddWallet(name, val);
                              } else {
                                onEditWallet(existing, name, val);
                              }
                            }
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBrown,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 740),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceTan,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total balance',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '₱${totalBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCream,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Safe to spend per day',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        dailySafeSpend > 0
                            ? '₱${dailySafeSpend.toStringAsFixed(2)} / day'
                            : 'Set category budgets in the Budget tab to see this.',
                        style: TextStyle(
                          fontSize: dailySafeSpend > 0 ? 18 : 13,
                          fontWeight: dailySafeSpend > 0
                              ? FontWeight.w800
                              : FontWeight.w400,
                          color: dailySafeSpend > 0
                              ? AppColors.primaryBrown
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Wallets',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              ...wallets.map(
                (w) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundCream,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            w.name,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            '₱${w.balance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _showWalletSheet(context, existing: w),
                            child: const Text(
                              'Edit',
                              style: TextStyle(
                                color: AppColors.primaryBrown,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          GestureDetector(
                            onTap: () => onDeleteWallet(w),
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                color: AppColors.dangerRed,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => _showWalletSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentOrange,
                    foregroundColor: AppColors.textDark,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Add wallet',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 5. SPEND / TRANSACTIONS TAB & MODAL
// ============================================================================

class SpendTab extends StatefulWidget {
  final List<WalletItem> wallets;
  final List<BudgetCategory> categories;
  final List<TransactionItem> transactions;
  final Function(TransactionItem) onAddTransaction;

  const SpendTab({
    super.key,
    required this.wallets,
    required this.categories,
    required this.transactions,
    required this.onAddTransaction,
  });

  @override
  State<SpendTab> createState() => _SpendTabState();
}

class _SpendTabState extends State<SpendTab> {
  String _searchQuery = '';
  String _selectedType = 'All';
  String _selectedWallet = 'All wallets';
  String _selectedCategory = 'All categories';

  void _showNewTransactionSheet() {
    String txType = 'Expense';
    String selectedWallet =
        widget.wallets.isNotEmpty ? widget.wallets.first.name : 'Cash';
    String selectedCat =
        widget.categories.isNotEmpty ? widget.categories.first.name : 'Food';
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: '2026-11-25');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                ),
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New transaction',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Type',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['Expense', 'Income', 'Transfer', 'Split expense']
                            .map(
                              (t) => _buildPill(
                                label: t,
                                selected: txType == t,
                                onTap: () => setModalState(() => txType = t),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Amount (₱)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: amountCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surfaceTan,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Wallet (from)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: widget.wallets
                            .map(
                              (w) => _buildPill(
                                label: w.name,
                                selected: selectedWallet == w.name,
                                onTap: () => setModalState(
                                  () => selectedWallet = w.name,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.categories
                            .map(
                              (c) => _buildPill(
                                label: c.name,
                                selected: selectedCat == c.name,
                                onTap: () =>
                                    setModalState(() => selectedCat = c.name),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Note',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: noteCtrl,
                        decoration: InputDecoration(
                          hintText: 'e.g. Groceries',
                          filled: true,
                          fillColor: AppColors.surfaceTan,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Date (YYYY-MM-DD)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: dateCtrl,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surfaceTan,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.peachLight,
                                  foregroundColor: AppColors.primaryBrown,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  final amt =
                                      double.tryParse(amountCtrl.text) ?? 0.0;
                                  if (amt > 0) {
                                    widget.onAddTransaction(
                                      TransactionItem(
                                        id: DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString(),
                                        type: txType,
                                        amount: amt,
                                        wallet: selectedWallet,
                                        category: selectedCat,
                                        note: noteCtrl.text.trim(),
                                        date: dateCtrl.text.trim(),
                                      ),
                                    );
                                  }
                                  Navigator.pop(ctx);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBrown,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPill({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBrown : AppColors.peachLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.primaryBrown,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.transactions.where((tx) {
      if (_selectedType != 'All' && tx.type != _selectedType) return false;
      if (_selectedWallet != 'All wallets' && tx.wallet != _selectedWallet) {
        return false;
      }
      if (_selectedCategory != 'All categories' &&
          _selectedCategory != 'This cycle only' &&
          tx.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return tx.note.toLowerCase().contains(q) ||
            tx.category.toLowerCase().contains(q) ||
            tx.wallet.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 740),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _showNewTransactionSheet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Add transaction',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search notes, categories, wallets',
                  hintStyle: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13.5,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.borderSubtle),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primaryBrown),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['All', 'Expense', 'Income', 'Transfer', 'Other']
                    .map(
                      (t) => _buildPill(
                        label: t,
                        selected: _selectedType == t,
                        onTap: () => setState(() => _selectedType = t),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'All wallets',
                  ...widget.wallets.map((w) => w.name),
                ]
                    .map(
                      (w) => _buildPill(
                        label: w,
                        selected: _selectedWallet == w,
                        onTap: () => setState(() => _selectedWallet = w),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'All categories',
                  ...widget.categories.map((c) => c.name),
                  'This cycle only',
                ]
                    .map(
                      (c) => _buildPill(
                        label: c,
                        selected: _selectedCategory == c,
                        onTap: () => setState(() => _selectedCategory = c),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 28),
              if (filtered.isEmpty)
                const Center(
                  child: Text(
                    'No transactions match.',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13.5),
                  ),
                )
              else
                ...filtered.map(
                  (tx) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.note.isNotEmpty ? tx.note : tx.category,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${tx.category} • ${tx.wallet} • ${tx.date}',
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${tx.type == 'Income' ? '+' : '-'}₱${tx.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14.5,
                            color: tx.type == 'Income'
                                ? Colors.green.shade700
                                : AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 6. BUDGET TAB & PAY CYCLE / NEW CATEGORY MODALS
// ============================================================================

class BudgetTab extends StatelessWidget {
  final String cycleStart;
  final String cycleEnd;
  final List<BudgetCategory> categories;
  final List<TransactionItem> transactions;
  final Function(String start, String end) onUpdateCycle;
  final Function(BudgetCategory cat, String name, double limit)
      onUpdateCategory;
  final Function(BudgetCategory cat) onDeleteCategory;
  final Function(String name, double limit) onAddCategory;

  const BudgetTab({
    super.key,
    required this.cycleStart,
    required this.cycleEnd,
    required this.categories,
    required this.transactions,
    required this.onUpdateCycle,
    required this.onUpdateCategory,
    required this.onDeleteCategory,
    required this.onAddCategory,
  });

  void _showPayCycleSheet(BuildContext context) {
    final startCtrl = TextEditingController(text: cycleStart);
    final endCtrl = TextEditingController(text: cycleEnd);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pay cycle',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Start (YYYY-MM-DD)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: startCtrl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surfaceTan,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.textDark,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'End (YYYY-MM-DD)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: endCtrl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surfaceTan,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.peachLight,
                            foregroundColor: AppColors.primaryBrown,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            onUpdateCycle(
                              startCtrl.text.trim(),
                              endCtrl.text.trim(),
                            );
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBrown,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Updated to match Screenshot 1: "New category" with "Name" and "Budget (₱)" = 0
  void _showCategorySheet(BuildContext context, {BudgetCategory? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final budgetCtrl = TextEditingController(
      text: existing != null ? existing.limit.toStringAsFixed(0) : '0',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  existing == null ? 'New category' : 'Edit ${existing.name}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Name',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surfaceTan,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.textDark,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Budget (₱)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: budgetCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surfaceTan,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.peachLight,
                            foregroundColor: AppColors.primaryBrown,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            final name = nameCtrl.text.trim();
                            final val = double.tryParse(budgetCtrl.text) ?? 0.0;
                            if (name.isNotEmpty) {
                              if (existing == null) {
                                onAddCategory(name, val);
                              } else {
                                onUpdateCategory(existing, name, val);
                              }
                            }
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBrown,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenses = transactions
        .where((t) => t.type == 'Expense' || t.type == 'Split expense')
        .toList();
    final totalSpent = expenses.fold<double>(0.0, (s, t) => s + t.amount);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 740),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCream,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pay cycle',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$cycleStart to $cycleEnd',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: TextButton(
                        onPressed: () => _showPayCycleSheet(context),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.peachLight,
                          foregroundColor: AppColors.primaryBrown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Change cycle',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCream,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Spending this cycle',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        totalSpent > 0
                            ? '₱${totalSpent.toStringAsFixed(2)} spent'
                            : 'No expenses in this cycle yet.',
                        style: TextStyle(
                          fontSize: totalSpent > 0 ? 18 : 13,
                          fontWeight: totalSpent > 0
                              ? FontWeight.w800
                              : FontWeight.w400,
                          color: totalSpent > 0
                              ? AppColors.textDark
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              ...categories.map((cat) {
                final spent = expenses
                    .where((e) => e.category == cat.name)
                    .fold<double>(0.0, (s, e) => s + e.amount);
                final limitLabel = cat.limit > 0
                    ? '₱${cat.limit.toStringAsFixed(2)} limit'
                    : 'no limit set';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundCream,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cat.name,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₱${spent.toStringAsFixed(2)} spent · $limitLabel',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                _showCategorySheet(context, existing: cat),
                            child: const Text(
                              'Edit',
                              style: TextStyle(
                                color: AppColors.primaryBrown,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          GestureDetector(
                            onTap: () => onDeleteCategory(cat),
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                color: AppColors.dangerRed,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => _showCategorySheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Add category',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 7. BILLS TAB & "NEW BILL" MODAL
// ============================================================================

class BillsTab extends StatelessWidget {
  final List<BillItem> bills;
  final List<WalletItem> wallets;
  final List<BudgetCategory> categories;
  final Function(BillItem) onAddBill;
  final Function(BillItem) onDeleteBill;
  final Function(BillItem) onPayBill;

  const BillsTab({
    super.key,
    required this.bills,
    required this.wallets,
    required this.categories,
    required this.onAddBill,
    required this.onDeleteBill,
    required this.onPayBill,
  });

  void _showNewBillSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final amtCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: '2026-11-25');
    String selectedWallet = wallets.isNotEmpty ? wallets.first.name : 'Cash';
    String selectedCat =
        categories.isNotEmpty ? categories.first.name : 'Food';
    String repeats = 'Monthly';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                ),
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New bill',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Bill',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nameCtrl,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'e.g. Rent',
                          filled: true,
                          fillColor: AppColors.surfaceTan,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppColors.textDark,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Amount (₱)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: amtCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surfaceTan,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Pay from',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: wallets
                            .map(
                              (w) => _pill(
                                label: w.name,
                                selected: selectedWallet == w.name,
                                onTap: () => setModalState(
                                  () => selectedWallet = w.name,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: categories
                            .map(
                              (c) => _pill(
                                label: c.name,
                                selected: selectedCat == c.name,
                                onTap: () =>
                                    setModalState(() => selectedCat = c.name),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Repeats',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: ['Monthly', 'Weekly']
                            .map(
                              (r) => _pill(
                                label: r,
                                selected: repeats == r,
                                onTap: () => setModalState(() => repeats = r),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Next due date (YYYY-MM-DD)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: dateCtrl,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surfaceTan,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.peachLight,
                                  foregroundColor: AppColors.primaryBrown,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  final name = nameCtrl.text.trim();
                                  final amt =
                                      double.tryParse(amtCtrl.text) ?? 0.0;
                                  if (name.isNotEmpty && amt > 0) {
                                    onAddBill(
                                      BillItem(
                                        id: DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString(),
                                        name: name,
                                        amount: amt,
                                        wallet: selectedWallet,
                                        category: selectedCat,
                                        repeats: repeats,
                                        dueDate: dateCtrl.text.trim(),
                                      ),
                                    );
                                  }
                                  Navigator.pop(ctx);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBrown,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _pill({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBrown : AppColors.peachLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.primaryBrown,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final forecastTotal = bills.fold<double>(
      0.0,
      (sum, b) => sum + (b.repeats == 'Weekly' ? b.amount * 4 : b.amount),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 740),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 30-day forecast card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCream,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '30-day forecast',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        bills.isEmpty
                            ? 'Add a bill to see your forecast.'
                            : '₱${forecastTotal.toStringAsFixed(2)} estimated over the next 30 days',
                        style: TextStyle(
                          fontSize: bills.isEmpty ? 13 : 16,
                          fontWeight:
                              bills.isEmpty ? FontWeight.w400 : FontWeight.w800,
                          color: bills.isEmpty
                              ? AppColors.textMuted
                              : AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Add bill button
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => _showNewBillSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Add bill',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Saved bills list
              ...bills.map(
                (b) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundCream,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            b.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                            ),
                          ),
                          Text(
                            '₱${b.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${b.repeats} • ${b.wallet} • Due ${b.dueDate}',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => onPayBill(b),
                            child: const Text(
                              'Pay now',
                              style: TextStyle(
                                color: AppColors.primaryBrown,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => onDeleteBill(b),
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                color: AppColors.dangerRed,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 8. UTANG TAB & "NEW UTANG" MODAL
// ============================================================================

class UtangTab extends StatelessWidget {
  final List<UtangItem> utangs;
  final List<WalletItem> wallets;
  final Function(UtangItem) onAddUtang;
  final Function(UtangItem) onToggleSettle;
  final Function(UtangItem) onDeleteUtang;

  const UtangTab({
    super.key,
    required this.utangs,
    required this.wallets,
    required this.onAddUtang,
    required this.onToggleSettle,
    required this.onDeleteUtang,
  });

  void _showNewUtangSheet(BuildContext context) {
    String type = 'I lent';
    final personCtrl = TextEditingController();
    final amtCtrl = TextEditingController();
    final dueCtrl = TextEditingController();
    String selectedWallet = wallets.isNotEmpty ? wallets.first.name : 'Cash';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                ),
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'New utang',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Type',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: ['I lent', 'I borrowed']
                            .map(
                              (t) => GestureDetector(
                                onTap: () => setModalState(() => type = t),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: type == t
                                        ? AppColors.primaryBrown
                                        : AppColors.peachLight,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    t,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: type == t
                                          ? Colors.white
                                          : AppColors.primaryBrown,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Person',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: personCtrl,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surfaceTan,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Amount (₱)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: amtCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surfaceTan,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Wallet',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: wallets
                            .map(
                              (w) => GestureDetector(
                                onTap: () => setModalState(
                                  () => selectedWallet = w.name,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedWallet == w.name
                                        ? AppColors.primaryBrown
                                        : AppColors.peachLight,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    w.name,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: selectedWallet == w.name
                                          ? Colors.white
                                          : AppColors.primaryBrown,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Due date (YYYY-MM-DD, optional)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: dueCtrl,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surfaceTan,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.peachLight,
                                  foregroundColor: AppColors.primaryBrown,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  final person = personCtrl.text.trim();
                                  final amt =
                                      double.tryParse(amtCtrl.text) ?? 0.0;
                                  if (person.isNotEmpty && amt > 0) {
                                    onAddUtang(
                                      UtangItem(
                                        id: DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toString(),
                                        type: type,
                                        person: person,
                                        amount: amt,
                                        wallet: selectedWallet,
                                        dueDate: dueCtrl.text.trim(),
                                      ),
                                    );
                                  }
                                  Navigator.pop(ctx);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBrown,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final owedToYou = utangs
        .where((u) => u.type == 'I lent' && !u.settled)
        .fold<double>(0.0, (s, u) => s + u.amount);
    final youOwe = utangs
        .where((u) => u.type == 'I borrowed' && !u.settled)
        .fold<double>(0.0, (s, u) => s + u.amount);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 740),
          child: Column(
            children: [
              // Side-by-side summary cards
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundCream,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Owed to you',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '₱${owedToYou.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryBrown,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundCream,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'You owe',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '₱${youOwe.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.dangerRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Add utang button
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => _showNewUtangSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Add utang',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              if (utangs.isEmpty)
                const Text(
                  'No utang recorded.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13.5),
                )
              else
                ...utangs.map(
                  (u) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCream,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${u.person} (${u.type})',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.5,
                                decoration: u.settled
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            Text(
                              '₱${u.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14.5,
                                color: u.type == 'I lent'
                                    ? AppColors.primaryBrown
                                    : AppColors.dangerRed,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${u.wallet}${u.dueDate.isNotEmpty ? ' • Due ${u.dueDate}' : ''}${u.settled ? ' • Settled' : ''}',
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => onToggleSettle(u),
                              child: Text(
                                u.settled ? 'Reopen' : 'Mark settled',
                                style: const TextStyle(
                                  color: AppColors.primaryBrown,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () => onDeleteUtang(u),
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  color: AppColors.dangerRed,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 9. SAVINGS GOALS TAB & "NEW GOAL" MODAL
// ============================================================================

class GoalsTab extends StatelessWidget {
  final List<GoalItem> goals;
  final Function(GoalItem) onAddGoal;
  final Function(GoalItem, double) onAddFunds;
  final Function(GoalItem) onDeleteGoal;

  const GoalsTab({
    super.key,
    required this.goals,
    required this.onAddGoal,
    required this.onAddFunds,
    required this.onDeleteGoal,
  });

  void _showNewGoalSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final targetCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: '2026-12-31');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'New goal',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Goal name',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    hintText: 'e.g. Emergency fund',
                    filled: true,
                    fillColor: AppColors.surfaceTan,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Target amount (₱)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: targetCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surfaceTan,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Target date (YYYY-MM-DD)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: dateCtrl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surfaceTan,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.peachLight,
                            foregroundColor: AppColors.primaryBrown,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            final name = nameCtrl.text.trim();
                            final target =
                                double.tryParse(targetCtrl.text) ?? 0.0;
                            if (name.isNotEmpty && target > 0) {
                              onAddGoal(
                                GoalItem(
                                  id: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  name: name,
                                  targetAmount: target,
                                  targetDate: dateCtrl.text.trim(),
                                ),
                              );
                            }
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBrown,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddFundsSheet(BuildContext context, GoalItem goal) {
    final amtCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add savings to ${goal.name}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: amtCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Amount (₱)',
                    filled: true,
                    fillColor: AppColors.surfaceTan,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      final amt = double.tryParse(amtCtrl.text) ?? 0.0;
                      if (amt > 0) onAddFunds(goal, amt);
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBrown,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 740),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => _showNewGoalSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'New goal',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              if (goals.isEmpty)
                const Text(
                  'No goals yet. Set a target and a date.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13.5),
                )
              else
                ...goals.map((g) {
                  final progress = (g.savedAmount / g.targetAmount).clamp(
                    0.0,
                    1.0,
                  );
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundCream,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              g.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              '₱${g.savedAmount.toStringAsFixed(2)} / ₱${g.targetAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Target date: ${g.targetDate}',
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: AppColors.surfaceTan,
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.primaryBrown,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _showAddFundsSheet(context, g),
                              child: const Text(
                                '+ Add savings',
                                style: TextStyle(
                                  color: AppColors.primaryBrown,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () => onDeleteGoal(g),
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  color: AppColors.dangerRed,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 10. ACCOUNT PAGE (Avatar Card, Edit Name, Change Password)
// ============================================================================

class AccountTab extends StatelessWidget {
  final String userName;
  final String userEmail;
  final Function(String) onUpdateName;
  final Function(String) onUpdatePassword;

  const AccountTab({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.onUpdateName,
    required this.onUpdatePassword,
  });

  void _showEditNameSheet(BuildContext context) {
    final nameCtrl = TextEditingController(text: userName);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 460),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surfaceTan,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.peachLight,
                            foregroundColor: AppColors.primaryBrown,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            if (nameCtrl.text.trim().isNotEmpty) {
                              onUpdateName(nameCtrl.text.trim());
                            }
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBrown,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    final passCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 460),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Change password',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'New password (min 6 characters)',
                    filled: true,
                    fillColor: AppColors.surfaceTan,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.peachLight,
                            foregroundColor: AppColors.primaryBrown,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            if (passCtrl.text.length >= 6) {
                              onUpdatePassword(passCtrl.text);
                            }
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBrown,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 740),
          child: Column(
            children: [
              // Profile Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCream,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryBrown,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Edit Name Button
              SizedBox(
                width: double.infinity,
                height: 44,
                child: TextButton(
                  onPressed: () => _showEditNameSheet(context),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.peachLight,
                    foregroundColor: AppColors.primaryBrown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Edit name',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Change Password Button
              SizedBox(
                width: double.infinity,
                height: 44,
                child: TextButton(
                  onPressed: () => _showChangePasswordSheet(context),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.peachLight,
                    foregroundColor: AppColors.primaryBrown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Change password',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}