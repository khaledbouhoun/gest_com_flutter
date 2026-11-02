import 'package:flutter/material.dart';
import 'package:gestion_stock/models/journal.dart';
import 'package:gestion_stock/view_models/reception_entate_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';

class SaveReceptionPage extends StatefulWidget {
  const SaveReceptionPage({super.key});
  @override
  State<StatefulWidget> createState() => SaveReceptionPagePage();
}

class SaveReceptionPagePage extends State<SaveReceptionPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeBonController = TextEditingController();

  @override
  void dispose() {
    _codeBonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final secondaryColor = Theme.of(context).secondaryHeaderColor;

    return Consumer3<ReceptionEntateViewModel, StockViewModel, AuthViewModel>(
      builder: (context, entateProvider, stockProvider, authProvider, child) {
        _codeBonController.text = entateProvider.codeBon;
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: Colors.white)),
            backgroundColor: secondaryColor,
            actions: [
              _buildTipeDropdown(entateProvider, width),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nouvelle Reception',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                    SizedBox(height: 30),
                    _buildDateSection(entateProvider, width),
                    const SizedBox(height: 24),
                    _buildCodeSection(entateProvider, width),
                    const SizedBox(height: 24),
                    _buildJournalSection(entateProvider, width),
                    const SizedBox(height: 24),
                    _buildPieceSection(entateProvider, width),
                    const SizedBox(height: 24),
                    _buildCodeSelSection(entateProvider, width),
                    const SizedBox(height: 32),
                    _buildSaveButton(context, entateProvider, width),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTipeDropdown(ReceptionEntateViewModel provider, double width) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: DropdownButtonFormField<Tipe>(
        initialValue: provider.selectedT,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).secondaryHeaderColor,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).secondaryHeaderColor,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).secondaryHeaderColor,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        items: provider.listTipe.map((tipe) {
          return DropdownMenuItem(
            value: tipe,
            child: Text(tipe.tipe, style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontWeight: FontWeight.bold)),
          );
        }).toList(),
        onChanged: (Tipe? tipe) async {
          if (tipe != null) {
            provider.selectedT = tipe;
            await provider.getcodebon(context);
            provider.notifyListeners();
          }
        },
      ),
    );
  }

  Widget _buildDateSection(ReceptionEntateViewModel provider, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Date de la reception'),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).secondaryHeaderColor,
          ),
          onPressed: () async {
            await provider.selectDate(context, provider.datesave);
            await provider.getcodebon(context);
            provider.notifyListeners();
          },
          icon: const Icon(Icons.calendar_today),
          label: Text(DateFormat('dd/MM/yyyy').format(provider.datesave)),
        ),
      ],
    );
  }

  Widget _buildCodeSection(ReceptionEntateViewModel provider, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Code de la reception'),
        TextFormField(
          readOnly: true,
          controller: _codeBonController,
          decoration: _getInputDecoration(),
        ),
      ],
    );
  }

  Widget _buildJournalSection(ReceptionEntateViewModel provider, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Journal'),
        DropdownButtonFormField<JournalModel>(
          initialValue: provider.selectedJournal,
          decoration: _getInputDecoration(),
          items: provider.listJournals.map((journal) {
            return DropdownMenuItem(
              value: journal,
              child: Text('${journal.jouNo!} - ${journal.jouNom!}'),
            );
          }).toList(),
          onChanged: (JournalModel? journal) async {
            if (journal != null) {
              provider.selectedJournal = journal;
              await provider.getcodebon(context);
              provider.notifyListeners();
            }
          },
        ),
      ],
    );
  }

  InputDecoration _getInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor, width: 2),
      ),
    );
  }

  Widget _buildPieceSection(ReceptionEntateViewModel provider, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Numéro de la pièce'),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: provider.noPiece,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir un numéro de pièce';
              }
              return null;
            },
            decoration: _getInputDecoration(),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeSelSection(ReceptionEntateViewModel provider, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Code sél'),
        TextFormField(
          controller: provider.codeselController,
          decoration: _getInputDecoration(),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, ReceptionEntateViewModel provider, double width) {
    return Center(
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          minimumSize: Size(width * 0.6, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            provider.codeselController.text = provider.codeselController.text.isEmpty ? '' : provider.codeselController.text;
            await provider.saveReception(context);
            
          }
        },
        icon: const Icon(Icons.save),
        label: const Text('Enregistrer'),
      ),
    );
  }
}
