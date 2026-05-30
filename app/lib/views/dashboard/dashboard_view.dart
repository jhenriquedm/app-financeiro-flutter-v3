import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/transaction_model.dart';
import '../../providers/app_providers.dart';
import '../../utils/app_colors.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../viewmodels/news_viewmodel.dart';
import '../../widgets/app_screen_container.dart';
import '../analysis/analysis_view.dart';
import '../auth/login_view.dart';

String _formatCurrencyBr(double value) {
  return NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  ).format(value);
}

class _BrazilianCurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    final value = (int.tryParse(digitsOnly) ?? 0) / 100;
    final newText = _formatter.format(value);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  bool _showTransactionForm = false;
  TransactionModel? _editingTransaction;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(dashboardProvider).loadTransactions();
      await ref.read(newsProvider).loadNews();
    });
  }

  Future<void> _logout() async {
    await ref.read(authProvider).logout();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginView(),
      ),
    );
  }

  void _openTransactionForm({TransactionModel? transaction}) {
    setState(() {
      _editingTransaction = transaction;
      _showTransactionForm = true;
    });
  }

  void _closeTransactionForm() {
    setState(() {
      _editingTransaction = null;
      _showTransactionForm = false;
    });
  }

  Future<void> _confirmDelete(TransactionModel transaction) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir transação'),
          content: Text(
            'Deseja realmente excluir "${transaction.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Excluir',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true && transaction.id != null) {
      await ref.read(dashboardProvider).deleteTransaction(transaction.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVm = ref.watch(authProvider);
    final dashboardVm = ref.watch(dashboardProvider);
    final newsVm = ref.watch(newsProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.backgroundGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: AppScreenContainer(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 18,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Olá, ${authVm.currentUser?.name ?? 'usuário'}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Sair',
                                  onPressed: _logout,
                                  icon: const Icon(Icons.logout),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Gerenciamento de transações',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 14),
                            _buildBalanceCard(dashboardVm),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSummaryCard(
                                    'Receitas',
                                    dashboardVm.totalIncome,
                                    Colors.green,
                                    Icons.arrow_upward,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildSummaryCard(
                                    'Despesas',
                                    dashboardVm.totalExpense,
                                    Colors.red,
                                    Icons.arrow_downward,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            _buildChart(dashboardVm),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Transações recentes',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Adicionar',
                                  onPressed: () {
                                    _openTransactionForm();
                                  },
                                  icon: const Icon(
                                    Icons.add_circle,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 230,
                              child: dashboardVm.isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : _buildTransactionList(dashboardVm),
                            ),
                            const SizedBox(height: 14),
                            _buildNewsSection(newsVm),
                            const SizedBox(height: 14),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AnalysisView(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.analytics,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Ver Análise',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_showTransactionForm)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.35),
                    padding: const EdgeInsets.all(18),
                    child: Center(
                      child: _TransactionFormCard(
                        transaction: _editingTransaction,
                        onClose: _closeTransactionForm,
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

    Widget _buildBalanceCard(DashboardViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Saldo Atual',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            _formatCurrencyBr(vm.balance),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: vm.balance >= 0 ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    double value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            _formatCurrencyBr(value),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(DashboardViewModel vm) {
    final data = vm.expensesByCategory;

    if (data.isEmpty || vm.totalExpense <= 0) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Text(
          'Nenhuma despesa cadastrada para análise.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      );
    }

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxHeight: 220,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.entries.map((entry) {
            final percentage = entry.value / vm.totalExpense;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${entry.key} (${(percentage * 100).toStringAsFixed(1)}%)',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: percentage,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNewsSection(NewsViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Dicas Financeiras',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Atualizar',
                onPressed: () {
                  ref.read(newsProvider).loadNews();
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (vm.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: CircularProgressIndicator(),
              ),
            )
          else if (vm.news.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(18),
                child: Text(
                  'Nenhuma notícia disponível.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            SizedBox(
              height: 220,
              child: ListView.separated(
                itemCount: vm.news.length > 5 ? 5 : vm.news.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final news = vm.news[index];

                  return ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.trending_up,
                      color: Colors.green,
                    ),
                    title: Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      news.source.isEmpty ? 'Fonte não informada' : news.source,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(DashboardViewModel vm) {
    if (vm.transactions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Center(
          child: Text(
            'Nenhuma transação cadastrada.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 6),
        itemCount: vm.transactions.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final transaction = vm.transactions[index];
          final isIncome = transaction.type == TransactionType.income;

          return ListTile(
            dense: true,
            leading: CircleAvatar(
              radius: 17,
              backgroundColor: isIncome ? Colors.green[50] : Colors.red[50],
              child: Icon(
                isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                color: isIncome ? Colors.green : Colors.red,
                size: 18,
              ),
            ),
            title: Text(
              transaction.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              transaction.category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _openTransactionForm(transaction: transaction);
                }

                if (value == 'delete') {
                  _confirmDelete(transaction);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Text('Editar'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Excluir'),
                ),
              ],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isIncome ? '+' : '-'} ${_formatCurrencyBr(transaction.amount)}',
                    style: TextStyle(
                      color: isIncome ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const Icon(
                    Icons.more_vert,
                    size: 18,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TransactionFormCard extends ConsumerStatefulWidget {
  const _TransactionFormCard({
    required this.transaction,
    required this.onClose,
  });

  final TransactionModel? transaction;
  final VoidCallback onClose;

  @override
  ConsumerState<_TransactionFormCard> createState() =>
      _TransactionFormCardState();
}

class _TransactionFormCardState extends ConsumerState<_TransactionFormCard> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _amountController;

  late String _category;
  late TransactionType _selectedType;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.transaction?.title ?? '',
    );

    _amountController = TextEditingController(
      text: widget.transaction != null
          ? _formatCurrencyBr(widget.transaction!.amount)
          : '',
    );

    _category = widget.transaction?.category ?? 'Alimentação';
    _selectedType = widget.transaction?.type ?? TransactionType.expense;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  double _parseCurrencyValue(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.isEmpty) {
      return 0;
    }

    return (int.tryParse(digitsOnly) ?? 0) / 100;
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = _parseCurrencyValue(_amountController.text);

    final newTransaction = TransactionModel(
      id: widget.transaction?.id,
      title: _titleController.text.trim(),
      amount: amount,
      date: widget.transaction?.date ?? DateTime.now(),
      type: _selectedType,
      category: _category,
    );

    final dashboardVm = ref.read(dashboardProvider);

    if (widget.transaction == null) {
      await dashboardVm.addTransaction(newTransaction);
    } else {
      await dashboardVm.updateTransaction(newTransaction);
    }

    if (!mounted) return;

    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          maxHeight: 560,
        ),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 40),
                    Expanded(
                      child: Text(
                        widget.transaction == null
                            ? 'Adicionar Transação'
                            : 'Editar Transação',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Fechar',
                      onPressed: widget.onClose,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    _BrazilianCurrencyInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Valor',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o valor';
                    }

                    final parsedValue = _parseCurrencyValue(value);

                    if (parsedValue <= 0) {
                      return 'Informe um valor numérico válido';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<TransactionType>(
                  value: _selectedType,
                  decoration: InputDecoration(
                    labelText: 'Tipo',
                    prefixIcon: const Icon(Icons.swap_vert),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: TransactionType.income,
                      child: Text('Receita'),
                    ),
                    DropdownMenuItem(
                      value: TransactionType.expense,
                      child: Text('Despesa'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Alimentação',
                      child: Text('Alimentação'),
                    ),
                    DropdownMenuItem(
                      value: 'Transporte',
                      child: Text('Transporte'),
                    ),
                    DropdownMenuItem(
                      value: 'Moradia',
                      child: Text('Moradia'),
                    ),
                    DropdownMenuItem(
                      value: 'Lazer',
                      child: Text('Lazer'),
                    ),
                    DropdownMenuItem(
                      value: 'Salário',
                      child: Text('Salário'),
                    ),
                    DropdownMenuItem(
                      value: 'Outros',
                      child: Text('Outros'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _category = value;
                    });
                  },
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _saveTransaction,
                    child: Text(
                      widget.transaction == null ? 'Adicionar' : 'Salvar',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}