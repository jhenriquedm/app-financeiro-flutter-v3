import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../viewmodels/dashboard_viewmodel.dart';

class AnalysisView extends StatelessWidget {
  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = DashboardViewModel();
    final data = vm.expensesByCategory;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
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
                    // 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Análise Financeira',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 
                    Column(
                      children: [
                        // SALDO
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const Text('Saldo Atual'),
                              const SizedBox(height: 5),
                              Text(
                                'R\$ ${vm.balance.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
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
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data.entries.map((entry) {
                          final percentage =
                              entry.value / vm.totalExpense;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${entry.key} (${(percentage * 100).toStringAsFixed(1)}%)',
                              ),
                              const SizedBox(height: 5),
                              LinearProgressIndicator(
                                value: percentage,
                                minHeight: 10,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              const SizedBox(height: 15),
                            ],
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 📋 LISTA
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: data.entries.map((entry) {
                          final percentage =
                              entry.value / vm.totalExpense;

                          return ListTile(
                            title: Text(entry.key),
                            subtitle: Text(
                              '${(percentage * 100).toStringAsFixed(1)}% do total',
                            ),
                            trailing: Text(
                              'R\$ ${entry.value.toStringAsFixed(2)}',
                            ),
                          );
                        }).toList(),
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

  // 🔧 CARD PADRONIZADO
  Widget _buildSummaryCard(String title, double value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // 
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
}