import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/site.dart';
import '../../providers/site_provider.dart';

class SiteFormScreen extends StatefulWidget {
  final Site? site;
  const SiteFormScreen({super.key, this.site});

  @override
  State<SiteFormScreen> createState() => _SiteFormScreenState();
}

class _SiteFormScreenState extends State<SiteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _url;
  late TextEditingController _client;
  String _type = 'Website';

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.site?.name ?? '');
    _url = TextEditingController(text: widget.site?.url ?? '');
    _client = TextEditingController(text: widget.site?.clientName ?? '');
    _type = widget.site?.type == SiteType.api ? 'API' : 'Website';
  }

  @override
  void dispose() {
    _name.dispose();
    _url.dispose();
    _client.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<SiteProvider>();
    final isEdit = widget.site != null;
    final type = _type == 'API' ? SiteType.api : SiteType.website;
    if (isEdit) {
      final ok = await provider.updateSite(widget.site!.id,
          name: _name.text,
          url: _url.text,
          type: type,
          clientName: _client.text);
      if (ok && mounted) Navigator.of(context).pop(true);
    } else {
      final created = await provider.createSite(
          name: _name.text,
          url: _url.text,
          type: type,
          clientName: _client.text);
      if (created != null && mounted) Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.site != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Site' : 'Add Site')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _url,
                decoration: const InputDecoration(labelText: 'URL'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _client,
                decoration: const InputDecoration(labelText: 'Client Name'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _type,
                onChanged: (v) => setState(() => _type = v ?? 'Website'),
                items: const [
                  DropdownMenuItem(value: 'Website', child: Text('Website')),
                  DropdownMenuItem(value: 'API', child: Text('API')),
                ],
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _save,
                child: Text(isEdit ? 'Save Changes' : 'Create Site'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
