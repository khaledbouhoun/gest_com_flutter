import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailCard extends StatelessWidget {
  String? title;
  String? subtitle;
  String? secondSubtitle;
  String? section;
  DetailCard(
      {super.key,
      this.title,
      this.subtitle,
      this.section,
      this.secondSubtitle});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget? widget;

    //costume the widget
    if (title == 'Code-Barres') {
      widget = Row(
        children: [
          Expanded(
            child: ListTile(
              title: Text(
                title!,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.05),
              ),
              subtitle: Text(
                subtitle!,
                style: TextStyle(
                  fontSize: width * 0.05,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.black,
            size: width * 0.1,
          )
        ],
      );
    } else if (title == 'Téléphone 01' ||
        title == 'Téléphone 02' ||
        title == 'Fax') {
      widget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListTile(
              title: Text(
                title!,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.045),
              ),
              subtitle: Text(
                subtitle!,
                style: TextStyle(
                  fontSize: width * 0.05,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                launchUrlString(
                    'tel:${subtitle?.replaceAll(RegExp(r'\D'), '')}');
              },
              icon: Icon(
                Icons.call,
                color: Colors.green,
                size: width * 0.09,
              ))
        ],
      );
    } else if (title == 'LOCALISATION') {
      widget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListTile(
              title: Text(
                title!,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.045),
              ),
              subtitle: Text(
                (subtitle == null || subtitle!.isEmpty) ? '' : subtitle!,
                style: TextStyle(
                  fontSize: width * 0.05,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
                if (subtitle != null && subtitle!.trim().isNotEmpty) {
                  final String urlText = subtitle!.trim();
                  final Uri? url = Uri.tryParse(urlText);
                  if (url != null) {
                    try {
                      bool launched = false;
                      if (await canLaunchUrl(url)) {
                        launched = await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      }
                      if (!launched) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      }
                    } catch (e) {
                      // Silently fail
                    }
                  }
                }
              },
              icon: Icon(
                Icons.location_on_sharp,
                color: (subtitle != null && subtitle!.isNotEmpty)
                    ? Colors.red
                    : Colors.grey,
                size: width * 0.09,
              ))
        ],
      );
    } else {
      widget = ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title ?? '',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: width * 0.05,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle ?? '',
            style: TextStyle(
              fontSize: width * 0.05,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
        ),
      );
    }

    //the whole card
    if (section != null) {
      return Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: width * 0.08),
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            alignment: Alignment.centerLeft,
            child: Text(section!,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width * 0.06)),
          ),
          Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 0.2, color: Colors.grey))),
              child: widget),
        ],
      );
    } else {
      return Container(
          decoration: const BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 0.2, color: Colors.grey))),
          child: widget);
    }
  }
}
