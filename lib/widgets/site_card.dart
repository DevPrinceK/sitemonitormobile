import 'package:flutter/material.dart';
import '../models/site.dart';

class SiteCard extends StatelessWidget {
  final Site site;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const SiteCard(
      {super.key, required this.site, this.onTap, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(site.isUp ? Icons.check_circle : Icons.error,
                  color: site.isUp ? Colors.green : Colors.red),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(site.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(site.url,
                        style: Theme.of(context).textTheme.bodySmall),
                    if (site.clientName != null)
                      Text(site.clientName!,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey)),
                  ],
                ),
              ),
              if (onEdit != null)
                IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
              if (onDelete != null)
                IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete),
            ],
          ),
        ),
      ),
    );
  }
}
