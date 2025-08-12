import 'package:app/ui/_core/theme/app_colors.dart';
import 'package:app/ui/home_episodes/view_models/episodes_view_model.dart';
import 'package:app/ui/main_scaffold/view_models/main_scaffold_view_model.dart';
import 'package:app/ui/main_scaffold/widgets/app_bar_custom.dart';
import 'package:app/ui/main_scaffold/widgets/bottom_nav_bar_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScaffoldScreen extends StatelessWidget {
  MainScaffoldScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScaffoldViewModel>(
      builder: (_, viewModel, child) {
        return Consumer<EpisodesViewModel>(
          builder: (_, episodesViewModel, child) {
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBarCustom(
                viewModel: viewModel,
                episodesViewModel: episodesViewModel,
              ),
              body: viewModel.currentView,
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Container(
                height: 60,
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(color: Colors.black54, spreadRadius: 3, blurRadius: 10, offset: Offset(0, 3)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        episodesViewModel.filterEpisodes('');
                        viewModel.getIndex(0);
                      },
                      child: BottomNavBarItems(
                        width: 75,
                        isSelected: viewModel.currentIndex == 0,
                        title: 'Locations',
                        icon: Icons.public,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        episodesViewModel.filterEpisodes('');
                        viewModel.getIndex(1);
                      },
                      child: BottomNavBarItems(
                        width: 75,
                        isSelected: viewModel.currentIndex == 1,
                        title: 'Home',
                        icon: Icons.home,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        episodesViewModel.filterEpisodes('');
                        viewModel.getIndex(2);
                      },
                      child: BottomNavBarItems(
                        width: 75,
                        isSelected: viewModel.currentIndex == 2,
                        title: 'Favorites',
                        icon: Icons.favorite,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
