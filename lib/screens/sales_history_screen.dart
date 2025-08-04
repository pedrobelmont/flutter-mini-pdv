
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos/models/sale.dart';
import 'package:flutter_pos/providers/sales_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class SalesHistoryScreen extends StatefulWidget {
  @override
  _SalesHistoryScreenState createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  Future<void> _exportSales(bool exportAsPdf) async {
    final salesProvider = Provider.of<SalesProvider>(context, listen: false);
    final sales = salesProvider.sales;

    if (exportAsPdf) {
      await _exportToPdf(sales);
    } else {
      await _exportToCsv(sales);
    }
  }

  Future<void> _exportToCsv(List<Sale> sales) async {
    final List<List<dynamic>> rows = [];
    rows.add(['ID da Venda', 'Data', 'Total', 'Método de Pagamento', 'Itens']);
        for (var i = 0; i < sales.length; i++) {
      final sale = sales[i];
      rows.add([
        i + 1,
        sale.date,
        sale.total,
        sale.paymentMethod,
        sale.items.map((e) => e.product.name).join(', ')
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/sales.csv";
    final file = File(path);
    await file.writeAsString(csv);

        await Share.shareXFiles([XFile(path)], text: 'Vendas Exportadas');
  }

  Future<void> _exportToPdf(List<Sale> sales) async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.ListView.builder(
            itemCount: sales.length,
            itemBuilder: (context, index) {
              final sale = sales[index];
              return pw.Container(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                                                                                pw.Text('Venda #${index + 1}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Data: ${sale.date}'),
                    pw.Text('Total: R\$ ${sale.total.toStringAsFixed(2)}'),
                    pw.Text('Pagamento: ${sale.paymentMethod.toString().split('.').last}'),
                    pw.Divider(),
                    pw.Text('Itens:'),
                    pw.ListView.builder(
                      itemCount: sale.items.length,
                      itemBuilder: (context, itemIndex) {
                        final item = sale.items[itemIndex];
                        return pw.Text('- ${item.product.name}: R\$ ${item.product.price.toStringAsFixed(2)}');
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }));

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'sales.pdf');
  }

  @override
  Widget build(BuildContext context) {
    final sales = Provider.of<SalesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Vendas'),
        actions: [
          PopupMenuButton<
              bool>(
            onSelected: (value) => _exportSales(value),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<bool>>[
              const PopupMenuItem<bool>(
                value: false,
                child: Text('Exportar para CSV'),
              ),
              const PopupMenuItem<bool>(
                value: true,
                child: Text('Exportar para PDF'),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sales.sales.length,
        itemBuilder: (context, index) {
          final sale = sales.sales[index];
          return ExpansionTile(
            title: Text('Venda #${index + 1} - R\$ ${sale.total.toStringAsFixed(2)}'),
            subtitle: Text('${sale.date} - ${sale.paymentMethod.toString().split('.').last}'),
            children: sale.items.map((item) => ListTile(
              title: Text(item.product.name),
              trailing: Text('R\$ ${item.product.price.toStringAsFixed(2)}'),
            )).toList(),
          );
        },
      ),
    );
  }
}
