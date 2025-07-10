import 'package:flutter/material.dart';

/// Widget riutilizzabile per selezione multipla di tag tramite chip e autocomplete.
class TagSelector extends StatefulWidget {
  final List<String> allTags;
  final Set<String> selectedTags;
  final Function(Set<String>) onChanged;
  final int maxTags;

  const TagSelector({
    super.key,
    required this.allTags,
    required this.selectedTags,
    required this.onChanged,
    this.maxTags = 5,
  });

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  late Set<String> _selectedTags;

  @override
  void initState() {
    super.initState();
    _selectedTags = Set<String>.from(widget.selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tag selezionati
        Wrap(
          spacing: 6,
          children: _selectedTags
              .map(
                (tag) => Chip(
                  label: Text(tag),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () {
                    setState(() {
                      _selectedTags.remove(tag);
                      widget.onChanged(_selectedTags);
                    });
                  },
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        // Campo di ricerca/autocomplete solo se non superato max tag
        if (_selectedTags.length < widget.maxTags)
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return widget.allTags.where(
                  (tag) => !_selectedTags.contains(tag),
                );
              }
              return widget.allTags.where(
                (tag) =>
                    tag.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    ) &&
                    !_selectedTags.contains(tag),
              );
            },
            onSelected: (String tag) {
              setState(() {
                _selectedTags.add(tag);
                widget.onChanged(_selectedTags);
              });
            },
            fieldViewBuilder:
                (context, controller, focusNode, onEditingComplete) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText: "Aggiungi tag...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                    ),
                    onEditingComplete: onEditingComplete,
                  );
                },
          ),
        if (_selectedTags.length >= widget.maxTags)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Max ${widget.maxTags} tag selezionati.",
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ),
      ],
    );
  }
}
