import 'package:flutter/material.dart';

class CancelAddDialog extends StatelessWidget {
  final Widget destination;

  const CancelAddDialog({
    super.key,
    required this.destination,
  });

  static void show(BuildContext context, Widget destination) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CancelAddDialog(destination: destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🔴 Icon
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 32,
              ),
            ),

            const SizedBox(height: 20),

            /// 📝 Title
            const Text(
              "Annuler l'opération ?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            /// 📄 Content
            const Text(
              "Voulez-vous vraiment annuler le processus en cours ?",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            /// 🔘 Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Non"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      final navigator = Navigator.of(context);
                      navigator.pop(); // close dialog first
                      navigator.push(
                        MaterialPageRoute(
                          builder: (_) => destination,
                        ),
                      );
                    },
                    child: const Text(
                      "Oui",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
