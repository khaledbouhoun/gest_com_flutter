import 'package:flutter/material.dart';
import 'package:gestion_stock/models/journal.dart';
import 'package:gestion_stock/models/site.dart';
import 'package:gestion_stock/view_models/auth_view_model.dart';
import 'package:gestion_stock/view_models/commande_entate_view_model.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SaveCommandePage extends StatefulWidget {
  const SaveCommandePage({super.key});
  @override
  State<StatefulWidget> createState() => SaveCommandePagePage();
}

class SaveCommandePagePage extends State<SaveCommandePage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final secondaryColor = Theme.of(context).secondaryHeaderColor;

    return Consumer3<CommandeEntateViewModel, StockViewModel, AuthViewModel>(
      builder: (context, entateProvider, stockProvider, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            leading:
                IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: Colors.white)),
            backgroundColor: secondaryColor,
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
                        'Nouvelle Commande',
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
                      _builddtpDateLivrSection(entateProvider, width),
                      const SizedBox(height: 24),
                      _buildCheck(entateProvider, width),
                      _buildCheckvisible(entateProvider, width),
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

  Widget _buildDateSection(CommandeEntateViewModel provider, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Date de la commande'),
        InkWell(
          onTap: () async {
            provider.datesave = await provider.selectDate(context, provider.datesave);

            provider.notifyListeners();
          },
          child: Container(
            height: 60,
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

  Widget _builddtpDateLivrSection(CommandeEntateViewModel provider, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Date de la livraison'),
        InkWell(
          onTap: () async {
            provider.dtpDateLivr = await provider.selectDate(context, provider.dtpDateLivr);

            provider.notifyListeners();
          },
          child: Container(
            height: 60,
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
                Text(DateFormat('dd/MM/yyyy').format(provider.dtpDateLivr)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _builddtpDateRSVSection(CommandeEntateViewModel provider, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Date de la reservation'),
        InkWell(
          onTap: () async {
            provider.dtpDateRSV = await provider.selectDate(context, provider.dtpDateRSV);

            provider.notifyListeners();
          },
          child: Container(
            height: 60,
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
                Text(DateFormat('dd/MM/yyyy').format(provider.dtpDateRSV)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheck(CommandeEntateViewModel provider, double width) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border.all(color: provider.checkedRSV ? Theme.of(context).secondaryHeaderColor : Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: CheckboxListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          checkboxShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          checkColor: Colors.white,
          side: BorderSide(
            color: Theme.of(context).secondaryHeaderColor,
            width: 2,
          ),
          activeColor: Theme.of(context).secondaryHeaderColor,
          title: Text('Reservation :'),
          value: provider.checkedRSV,
          onChanged: (value) {
            provider.checkedRSV = value ?? false;
            provider.notifyListeners();
          },
        ));
  }

  Widget _buildCheckvisible(CommandeEntateViewModel provider, double width) {
    return Visibility(
      visible: provider.checkedRSV,
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).secondaryHeaderColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_builddtpDateRSVSection(provider, width)],
        ),
      ),
    );
  }

  Widget _buildTipeDropdown(CommandeEntateViewModel provider, double width) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: DropdownButtonFormField<dynamic>(
        initialValue: provider.selectedT,
        decoration: _getInputDecoration(),
        items: provider.listTipe.map((tipe) {
          return DropdownMenuItem(
            value: tipe,
            child: Text(tipe.toString()),
          );
        }).toList(),
        onChanged: (dynamic tipe) async {
          if (tipe != null) {
            provider.selectedT = tipe;

            provider.notifyListeners();
          }
        },
      ),
    );
  }

  Widget _buildCodeSection(CommandeEntateViewModel provider, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Code de la commande'),
        TextFormField(
          readOnly: true,
          initialValue: provider.codeBon ?? '...',
          decoration: _getInputDecoration(),
        ),
      ],
    );
  }

  Widget _buildJournalSection(CommandeEntateViewModel provider, double width) {
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
          items: provider.listJournals.map<DropdownMenuItem<JournalModel>>((journal) {
            return DropdownMenuItem(
              value: journal,
              child: Text('${journal.jouNo!} - ${journal.jouNom!}'),
            );
          }).toList(),
          onChanged: (JournalModel? journal) async {
            if (journal != null) {
              provider.selectedJournal = journal;

              provider.notifyListeners();
            }
          },
        ),
      ],
    );
  }

  Widget _buildSiteSection(CommandeEntateViewModel provider, double width) {
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
          items: provider.listSites.map<DropdownMenuItem<SiteModel>>((site) {
            return DropdownMenuItem(
                value: site,
                child: SizedBox(
                  width: width * 0.6,
                  child: Text(
                    '${site.cLSNO!} - ${site.cLSNOM!}',
                    style: TextStyle(
                        // overflow: TextOverflow.ellipsis,
                        ),
                  ),
                ));
          }).toList(),
          onChanged: (SiteModel? site) async {
            if (site != null) {
              provider.siteerorr = false;
              provider.selectedSite = site;

              provider.notifyListeners();
            }
          },
        ),
        // Visibility(
        //     visible: provider.siteerorr,
        //     child: Column(
        //       children: [
        //         const SizedBox(height: 10),
        //         Text(
        //           'Veuillez selectionner un site',
        //           style: TextStyle(
        //             fontSize: 13,
        //             color: Colors.red,
        //           ),
        //         ),
        //       ],
        //     )),
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

  Widget _buildBCNoSection(CommandeEntateViewModel provider, double width) {
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

  Widget _buildCodeSelSection(CommandeEntateViewModel provider, double width) {
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

  Widget _buildSaveButton(BuildContext context, CommandeEntateViewModel provider, double width) {
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
            await provider.saveCommande(context);
          }
          provider.notifyListeners();
        },
        icon: const Icon(Icons.save),
        label: const Text('Enregistrer'),
      ),
    );
  }
}
