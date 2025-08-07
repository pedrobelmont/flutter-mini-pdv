
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mini_pdv/models/product.dart';
import 'package:mini_pdv/models/sale.dart';
import 'package:mini_pdv/providers/product_provider.dart';
import 'package:mini_pdv/providers/sales_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final salesProvider = Provider.of<SalesProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricCards(context, salesProvider.sales, productProvider.products),
            SizedBox(height: 24),
            _buildMostSoldProductsChart(context, salesProvider.sales),
            SizedBox(height: 24),
            _buildSalesHistoryChart(context, salesProvider.sales),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCards(BuildContext context, List<Sale> sales, List<Product> products) {
    final totalSalesToday = sales
        .where((sale) => DateUtils.isSameDay(sale.date, DateTime.now()))
        .fold<double>(0, (sum, sale) => sum + sale.total);

    final totalStock = products.fold<int>(0, (sum, product) => sum + product.stock);
    final totalCategories = products.map((p) => p.category).toSet().length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMetricCard(context, 'Vendas de Hoje', 'R\$ ${totalSalesToday.toStringAsFixed(2)}', Icons.monetization_on),
        _buildMetricCard(context, 'Estoque Total', totalStock.toString(), Icons.inventory),
        _buildMetricCard(context, 'Categorias', totalCategories.toString(), Icons.category),
      ],
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildMostSoldProductsChart(BuildContext context, List<Sale> sales) {
    final productSales = <String, int>{};
    for (final sale in sales) {
      for (final item in sale.items) {
        productSales[item.product.name] = (productSales[item.product.name] ?? 0) + item.quantity;
      }
    }

    final sortedProducts = productSales.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final top5Products = sortedProducts.take(5).toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Produtos Mais Vendidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (top5Products.isNotEmpty ? top5Products.first.value : 0) * 1.2,
                  barGroups: top5Products.asMap().entries.map((entry) {
                    final index = entry.key;
                    final productSale = entry.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: productSale.value.toDouble(),
                          color: Theme.of(context).primaryColor,
                          width: 22,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < top5Products.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(top5Products[index].key, style: TextStyle(fontSize: 10)),
                            );
                          }
                          return Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesHistoryChart(BuildContext context, List<Sale> sales) {
    final salesByDay = <DateTime, double>{};
    for (final sale in sales) {
      final day = DateUtils.dateOnly(sale.date);
      salesByDay[day] = (salesByDay[day] ?? 0) + sale.total;
    }

    final sortedDays = salesByDay.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    
    final last7DaysSales = sortedDays.take(7).toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Histórico de Vendas (Últimos 7 Dias)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                     bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < last7DaysSales.length) {
                            final date = last7DaysSales[index].key;
                            return Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text('${date.day}/${date.month}', style: TextStyle(fontSize: 10)),
                            );
                          }
                          return Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: last7DaysSales.asMap().entries.map((entry) {
                        final index = entry.key;
                        final saleData = entry.value;
                        return FlSpot(index.toDouble(), saleData.value);
                      }).toList(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: true, color: Theme.of(context).primaryColor.withOpacity(0.3)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
