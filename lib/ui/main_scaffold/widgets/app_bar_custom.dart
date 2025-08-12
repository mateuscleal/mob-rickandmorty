import 'package:app/ui/_core/theme/app_colors.dart';
import 'package:app/ui/home_episodes/view_models/episodes_view_model.dart';
import 'package:app/ui/main_scaffold/view_models/main_scaffold_view_model.dart';
import 'package:flutter/material.dart';

class AppBarCustom extends StatefulWidget implements PreferredSizeWidget {
  final MainScaffoldViewModel viewModel;
  final EpisodesViewModel episodesViewModel;

  const AppBarCustom({super.key, required this.viewModel, required this.episodesViewModel});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  State<AppBarCustom> createState() => _AppBarCustomState();
}

class _AppBarCustomState extends State<AppBarCustom> {

  final _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return AppBar(
      toolbarHeight: 80,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.primary,
      title: Image.asset(viewModel.titles[viewModel.currentIndex], width: 200),
      centerTitle: true,
      actions: [
        Visibility(
          visible: viewModel.currentIndex == 1,
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: widget.viewModel.isExpanded ? MediaQuery.of(context).size.width * 0.8 : 0,
                curve: Curves.easeInOut,
                child: TextField(
                  focusNode: _focusNode,
                  controller: _controller,
                  style: TextStyle(color: AppColors.textPrimary),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: 'Search episodes by name',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.accent),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  onSubmitted: (value) async {
                    _focusNode.unfocus();
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final flag = await widget.episodesViewModel.filterEpisodes(value);
                    if (!flag) {
                      scaffoldMessenger.clearSnackBars();
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(backgroundColor: Colors.red, content: Text('Episode not found')),
                      );
                    }
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  widget.viewModel.isExpanded ? Icons.close_outlined : Icons.search_outlined,
                  color: AppColors.secondary,
                ),
                onPressed: () {
                  widget.viewModel.toggleSearch();
                  if (widget.viewModel.isExpanded) {
                    _controller.clear();
                  }
                  _focusNode.unfocus();
                  widget.episodesViewModel.filterEpisodes('');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
