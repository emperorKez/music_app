import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/app/common/bottom_navigation.dart';
import 'package:music_app/explore/bloc/search_bloc/search_bloc.dart';
import 'package:music_app/explore/view/widget/search_form.dart';
import 'package:music_app/library/view/widget/library_widgets.dart';
import 'package:music_app/library/view/widget/show_dialog.dart';
import 'package:music_app/player/bloc/player_bloc/player_bloc.dart';
import 'package:music_app/player/screen/now_playing.dart';
import 'package:music_app/player/utils/common.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({required this.player, super.key});
  final AudioPlayer player;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios)),
        title: const SearchForm(),
      ),
      bottomNavigationBar: const BottomNavBar(activeIndex: 1),
      body: body(),
    ));
  }

  Widget body() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchLoaded) {
          return state.songs == null || state.songs!.isEmpty
              ? const SizedBox()
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: state.songs!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        context.read<PlayerBloc>().add(ChangePlaylist(
                            playlist: createNowPlaylist(
                                songList: state.songs!, context: context),
                            songIndex: index));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NowPlayingScreen(
                                      player: context
                                          .read<PlayerBloc>()
                                          .state
                                          .player!,
                                    )));
                      },
                      onLongPress: () {
                        //Todo
                        showOnPressedDialog(
                            context: context, song: state.songs![index]);
                      },
                      leading: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: artworkWidget(
                                audioId: state.songs![index].id,
                                artworkType: ArtworkType.AUDIO)),
                      ),
                      title: Text(
                        state.songs![index].title,
                        softWrap: true,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      subtitle: Text(
                        state.songs![index].artist!,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      horizontalTitleGap: 10,
                      minVerticalPadding: 0,
                    );
                  });
        } else {
          return exploreWidget();
        }
      },
    );
  }

  Widget exploreWidget() {
    return Center(
      child: Text('data'),
    );
  }
}
