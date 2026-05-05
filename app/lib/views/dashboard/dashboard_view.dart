import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../models/transaction_model.dart';
import '../auth/login_view.dart';
import '../analysis/analysis_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool showMessage = false;

  @override
  Widget build(BuildContext context) {
    final vm = DashboardViewModel();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.backgroundGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 🔝 TOPO
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Olá, usuário 👋',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginView(),
                              ),
                            );
                          },
                        )
                      ],
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Gerenciamento de transações\nDashboard',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 💰 BLOCO ORGANIZADO
                    Column(
                      children: [
                        // SALDO CENTRAL
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const Text('Saldo'),
                              const SizedBox(height: 5),
                              Text(
                                'R\$ ${vm.balance.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // RECEITAS + DESPESAS
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                'Receitas',
                                vm.totalIncome,
                                Colors.green,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildSummaryCard(
                                'Despesas',
                                vm.totalExpense,
                                Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 📊 GRÁFICO
                    _buildChart(vm),

                    const SizedBox(height: 20),

                    // 📋 LISTA
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: vm.transactions.map((t) {
                          return ListTile(
                            leading: Icon(
                              t.type == TransactionType.income
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: t.type == TransactionType.income
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            title: Text(t.title),
                            subtitle: Text(t.category),
                            trailing: Text(
                              '${t.type == TransactionType.income ? '+' : '-'} R\$ ${t.amount}',
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ⚠️ MENSAGEM INTERNA
                    if (showMessage)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.info, color: Colors.orange),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text('Funcionalidade em desenvolvimento'),
                            ),
                          ],
                        ),
                      ),

                    // ➕ BOTÃO ADICIONAR TRANSAÇÃO
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            showMessage = true;
                          });

                          Future.delayed(const Duration(seconds: 3), () {
                            if (mounted) {
                              setState(() {
                                showMessage = false;
                              });
                            }
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar Transação'),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 🔘 BOTÃO VER ANÁLISE
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AnalysisView(),
                            ),
                          );
                        },
                        child: const Text('Ver Análise'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, double value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // 👈 corrigido
        children: [
          Text(title),
          const SizedBox(height: 5),
          Text(
            'R\$ ${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(DashboardViewModel vm) {
    final data = vm.expensesByCategory;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.entries.map((entry) {
          final percentage = entry.value / vm.totalExpense;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.key),
              const SizedBox(height: 5),
              LinearProgressIndicator(value: percentage),
              const SizedBox(height: 10),
            ],
          );
        }).toList(),
      ),
    );
  }
}