import 'package:flutter/material.dart';
import 'package:gestion_stock/models/journal.dart';
import 'package:gestion_stock/models/site.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/facture_entate_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SaveFacturePage extends StatefulWidget {
  const SaveFacturePage({super.key});
  @override
  State<StatefulWidget> createState() => SaveFacturePagePage();
}

class SaveFacturePagePage extends State<SaveFacturePage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final secondaryColor = Theme.of(context).secondaryHeaderColor;

    return Consumer3<FactureEntateViewModel, StockViewModel, AuthViewModel>(
      builder: (context, entateProvider, stockProvider, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            leading:
                IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: Colors.white)),
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
                child: Form(
                  key: entateProvider.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nouvelle Facture',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _buildDateSection(entateProvider, width),
                      const SizedBox(height: 24),
                      _buildCodeSection(entateProvider, width),
                      const SizedBox(height: 24),
                      _buildJournalSection(entateProvider, width),
                      const SizedBox(height: 24),
                      _buildSiteSection(entateProvider, width),
                      const SizedBox(height: 24),
                      _buildBCNoSection(entateProvider, width),
                      const SizedBox(height: 24),
                      _buildCodeSelSection(entateProvider, width),
                      const SizedBox(height: 32),
                      _buildSaveButton(context, entateProvider, width),
                    ],
                  ),
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

  Widget _buildDateSection(FactureEntateViewModel provider, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Date de la facture'),
        InkWell(
          onTap: () async {
            await provider.selectDate(context, provider.datesave);
            await provider.getcodebon(context);
            provider.notifyListeners();
          },
          child: Container(
            height: 50,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Theme.of(context).secondaryHeaderColor, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(
                  width: 10,
                ),
                Text(DateFormat('dd/MM/yyyy').format(provider.datesave)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTipeDropdown(FactureEntateViewModel provider, double width) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: DropdownButtonFormField<Tipe>(
        initialValue: provider.selectedT,
        decoration: _getInputDecoration(),
        items: provider.listTipe.map((tipe) {
          return DropdownMenuItem(
            value: tipe,
            child: Text(tipe.tipe),
          );
        }).toList(),
        onChanged: (Tipe? tipe) async {
          if (tipe != null) {
            provider.setSelectedT(tipe: tipe);
            await provider.getcodebon(context);
            provider.notifyListeners();
          }
        },
      ),
    );
  }

  Widget _buildCodeSection(FactureEntateViewModel provider, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Code de la facture'),
        TextFormField(
          readOnly: true,
          initialValue: provider.codeBon ?? '...',
          decoration: _getInputDecoration(),
        ),
      ],
    );
  }

  Widget _buildJournalSection(FactureEntateViewModel provider, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Journal'),
        DropdownButtonFormField<JournalModel>(
          validator: (value) {
            if (value == null) {
              return 'Veuillez sélectionner un journal';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
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

  Widget _buildSiteSection(FactureEntateViewModel provider, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Site'),
        DropdownButtonFormField<SiteModel>(
          initialValue: provider.selectedSite,
          validator: (value) {
            if (value == null) {
              return 'Veuillez sélectionner un site';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: _getInputDecoration(),
          items: provider.listSites.map((site) {
            return DropdownMenuItem(
              value: site,
              child: Text('${site.cLSNO!} - ${site.cLSNOM!}'),
            );
          }).toList(),
          onChanged: (SiteModel? site) async {
            if (site != null) {
              provider.siteerorr = false;
              provider.selectedSite = site;
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

  Widget _buildBCNoSection(FactureEntateViewModel provider, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('B.C N°'),
        TextFormField(
          controller: provider.edtBCNo,
          decoration: _getInputDecoration(),
        ),
      ],
    );
  }

  Widget _buildCodeSelSection(FactureEntateViewModel provider, double width) {
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

  Widget _buildSaveButton(BuildContext context, FactureEntateViewModel provider, double width) {
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
          provider.edtBCNo.text = provider.edtBCNo.text.isEmpty ? '' : provider.edtBCNo.text;
          provider.codeselController.text =
              provider.codeselController.text.isEmpty ? '' : provider.codeselController.text;
          if (provider.formKey.currentState!.validate()) {
            await provider.saveFacture(context);
          }
        },
        icon: const Icon(Icons.save),
        label: const Text('Enregistrer'),
      ),
    );
  }
}
