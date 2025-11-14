import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torrstv/core/services/torrserver/api.dart';
import 'package:torrstv/core/tmdb/tmdb.dart';
import 'package:torrstv/ui/main_navigation/tab_controller_provider.dart';

class AddPage extends ConsumerStatefulWidget {
  const AddPage({super.key});

  @override
  ConsumerState<AddPage> createState() => _AddPageState();
}

class _AddPageState extends ConsumerState<AddPage> {
  final _magnetController = TextEditingController();
  final _titleController = TextEditingController();
  final _posterUrlController = TextEditingController();

  String? _selectedFilePath;
  String? _selectedCategory;
  List<String> _posterSuggestions = [];
  bool _isSearchingPosters = false;
  bool _isSaving = false;

  final List<String> _categories = ['Movies', 'Series', 'Music', 'Other'];

  @override
  void initState() {
    super.initState();
    _magnetController.addListener(_onMagnetChanged);
    _titleController.addListener(_onTitleChanged);
  }

  Future<void> _pickTorrentFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['torrent']);

    if (result != null) {
      setState(() {
        _selectedFilePath = result.files.single.path;
        _magnetController.clear();
      });
    }
  }

  void _clearSelectedFile() {
    setState(() {
      _selectedFilePath = null;
    });
  }

  void _onMagnetChanged() {
    final magnet = _magnetController.text;
    if (magnet.startsWith('magnet:') && magnet.contains('dn=')) {
      final dnMatch = RegExp(r'dn=([^&]+)').firstMatch(magnet);
      if (dnMatch != null) {
        final name = Uri.decodeComponent(dnMatch.group(1)!);
        if (_titleController.text.isEmpty) {
          _titleController.text = name;
        }
      }
    }
  }

  void _onTitleChanged() {
    final title = _titleController.text;
    if (title.length > 2) {
      _searchPosters(title);
    } else {
      setState(() {
        _posterSuggestions = [];
      });
    }
  }

  Future<void> _searchPosters(String query) async {
    setState(() {
      _isSearchingPosters = true;
    });

    try {
      final ents = await Tmdb.videos("search/multi", {"include_image_language": "null,en", "query": query}, "ru");
      final list = ents.map((e) => e.poster_path).toList().where((e) => e.isNotEmpty);

      setState(() {
        _posterSuggestions = list.toList();
        _isSearchingPosters = false;
      });
    } catch (e) {
      setState(() {
        _posterSuggestions = [];
        _isSearchingPosters = false;
      });
    }
  }

  void _selectPoster(String url) {
    setState(() {
      _posterUrlController.text = url;
    });
  }

  void _clearPoster() {
    setState(() {
      _posterUrlController.clear();
    });
  }

  Future<void> _saveTorrent() async {
    if (_magnetController.text.isEmpty && _selectedFilePath == null) {
      _showError('Please enter a magnet link or select a torrent file');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final api = ref.read(torrServerApiProvider);
      var success = false;

      if (_magnetController.text.isNotEmpty) {
        success = await api.addTorrent(_magnetController.text, _titleController.text, _posterUrlController.text, _selectedCategory ?? '');
      } else if (_selectedFilePath != null) {
        success = await api.addTorrentFile(_selectedFilePath!, _titleController.text, _posterUrlController.text, _selectedCategory ?? '');
      }

      if (success) {
        _showSuccess('Torrent added successfully');
        final tabController = ref.read(tabControllerProvider);
        tabController.animateTo(0);
      } else {
        _showError('Error adding torrent');
      }
    } catch (e) {
      print(e);
      _showError('Error: $e');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Add'), backgroundColor: colorScheme.surface, elevation: 0),
      body: Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _magnetController,
                  keyboardType: TextInputType.url,
                  style: TextStyle(color: colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Magnet:',
                    hintText: 'magnet:?xt=urn:btih:...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.primary),
                    ),
                    filled: true,
                    fillColor: colorScheme.surface.withOpacity(0.5),
                    labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                  ),
                ),

                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedFilePath ?? 'No file selected',
                        style: TextStyle(
                          color: _selectedFilePath != null ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.5),
                          fontStyle: _selectedFilePath != null ? FontStyle.normal : FontStyle.italic,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Кнопка выбора файла
                    IconButton(icon: const Icon(Icons.folder_open), onPressed: _isSaving ? null : _pickTorrentFile, tooltip: 'Select .torrent file'),
                    // Кнопка очистки
                    if (_selectedFilePath != null) IconButton(icon: const Icon(Icons.clear), onPressed: _isSaving ? null : _clearSelectedFile, tooltip: 'Clear selected file'),
                  ],
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveTorrent,
                    icon: _isSaving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
                    label: _isSaving ? const Text('Saving...') : const Text('Add'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(
                      height: 120,
                      width: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          _posterUrlController.text,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: Colors.grey[300], child: const Icon(Icons.broken_image));
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        children: [
                          // Поле названия
                          TextField(
                            controller: _titleController,
                            keyboardType: TextInputType.url,
                            style: TextStyle(color: colorScheme.onSurface),
                            decoration: InputDecoration(
                              labelText: 'Title of torrent',
                              hintText: 'Enter a title',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: colorScheme.primary),
                              ),
                              filled: true,
                              fillColor: colorScheme.surface.withOpacity(0.5),
                              labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Поле URL постера
                          TextField(
                            controller: _posterUrlController,
                            keyboardType: TextInputType.url,
                            style: TextStyle(color: colorScheme.onSurface),
                            decoration: InputDecoration(
                              labelText: 'Poster URL',
                              hintText: 'https://example.com/poster.jpg',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: colorScheme.primary),
                              ),
                              filled: true,
                              fillColor: colorScheme.surface.withOpacity(0.5),
                              labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
                              suffixIcon: _posterUrlController.text.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: _clearPoster) : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Выбор категории
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                  items: _categories.map((category) {
                    return DropdownMenuItem(value: category, child: Text(category));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Предложения постеров из TMDB
                if (_titleController.text.isNotEmpty) ...[
                  Text('Posters:', style: Theme.of(context).textTheme.titleMedium),

                  if (_isSearchingPosters) const Center(child: CircularProgressIndicator()),

                  if (_posterSuggestions.isNotEmpty)
                    SizedBox(
                      height: 150,
                      child: CarouselView(
                        itemExtent: 100,
                        shrinkExtent: 80,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        onTap: (index) {
                          if (index >= 0 && index < _posterSuggestions.length) {
                            _selectPoster(_posterSuggestions[index]);
                          }
                        },
                        children: _posterSuggestions.map((posterUrl) {
                          return Container(
                            width: 80,
                            height: 120,
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              border: Border.all(color: _posterUrlController.text == posterUrl ? colorScheme.primary : Colors.transparent, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                posterUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(color: Colors.grey[300], child: const Icon(Icons.broken_image));
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _magnetController.dispose();
    _titleController.dispose();
    _posterUrlController.dispose();
    super.dispose();
  }
}
