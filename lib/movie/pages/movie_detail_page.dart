import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_movie/injector.dart';
import 'package:flutter_movie/movie/providers/movie_get_detail_provider.dart';
import 'package:flutter_movie/movie/providers/movie_get_video_provider.dart';
import 'package:flutter_movie/widget/image_widget.dart';
import 'package:flutter_movie/widget/item_movie_widget.dart';
import 'package:flutter_movie/widget/web_view_widget.dart';
import 'package:flutter_movie/widget/youtube_player_widget.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key, required this.id});

  final int id;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              getIt<MovieGetDetailProvider>()..getDetail(context, id: id),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              getIt<MovieGetVideoProvider>()..getVideo(context, id: id),
        ),
      ],
      builder: (context, child) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _WidgetAppBar(context),
              Consumer<MovieGetVideoProvider>(
                builder: (context, value, child) {
                  final video = value.video;
                  if (video != null) {
                    return SliverToBoxAdapter(
                      child: _Content(
                        title: 'Trailer',
                        padding: 0,
                        body: SizedBox(
                          height: 200,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final item = video.results[index];
                              return Stack(
                                children: [
                                  ImageWidget(
                                    type: TypeSrcImg.external,
                                    radius: 12,
                                    imageSrc: YoutubePlayer.getThumbnail(
                                      videoId: item.key,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 36,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                      child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                YoutubePlayerWidget(
                                                    youtubeKey: item.key),
                                          ),
                                        );
                                      },
                                    ),
                                  ))
                                ],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(width: 10);
                            },
                            itemCount: video.results.length,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter();
                },
              ),
              _WidgetSummary(),
            ],
          ),
        );
      },
    );
  }
}

class _WidgetAppBar extends SliverAppBar {
  final BuildContext context;

  const _WidgetAppBar(this.context);
  @override
  Color? get backgroundColor => Colors.white;

  @override
  Color? get foregroundColor => Colors.black;

  @override
  Widget? get leading => Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
      );

  @override
  List<Widget>? get actions => [
        Consumer<MovieGetDetailProvider>(
          builder: (context, value, child) {
            final movie = value.movie;

            if (movie != null) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebViewContentWidget(
                                  title: movie.title, url: movie.homepage)));
                    },
                    icon: const Icon(Icons.public),
                  ),
                ),
              );
            }

            return SizedBox();
          },
        )
      ];

  @override
  double? get expandedHeight => 300;

  @override
  Widget? get flexibleSpace => Consumer<MovieGetDetailProvider>(
        builder: (context, value, child) {
          final movie = value.movie;

          if (movie != null) {
            return ItemMovieWidget(
              movieDetail: movie,
              heightBackdrop: double.infinity,
              widthBackdrop: double.infinity,
              heightPoster: 160,
              widthPoster: 100,
              radius: 0,
            );
          }

          return Container(
            color: Colors.grey[300],
            height: double.infinity,
            width: double.infinity,
          );
        },
      );
}

class _Content extends StatelessWidget {
  const _Content(
      {super.key, required this.title, required this.body, this.padding = 16});

  final String title;
  final Widget body;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: body,
        ),
      ],
    );
  }
}

class _WidgetSummary extends SliverToBoxAdapter {
  TableRow _tableContent({required String title, required String content}) =>
      TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(content),
        ),
      ]);

  @override
  Widget? get child => Consumer<MovieGetDetailProvider>(
        builder: (context, value, child) {
          final movie = value.movie;

          if (movie != null) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Content(
                    title: 'Release Date',
                    body: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 30,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          movie.releaseDate.toString().split(' ')[0],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _Content(
                    title: 'Genres',
                    body: Wrap(
                      spacing: 8,
                      children: movie.genres
                          .map((e) => Chip(label: Text(e.name)))
                          .toList(),
                    ),
                  ),
                  _Content(
                    title: 'Overview',
                    body: Text(
                      movie.overview,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  _Content(
                    title: 'Summary',
                    body: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                      },
                      border: TableBorder.all(
                        color: Colors.grey[300]!,
                        width: 1,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      children: [
                        _tableContent(
                            title: 'Adult',
                            content: movie.adult ? 'Yes' : 'No'),
                        _tableContent(
                          title: 'Popularity',
                          content: '${movie.popularity}',
                        ),
                        _tableContent(
                            title: 'Budget', content: '${movie.budget}'),
                        _tableContent(
                            title: 'Revenue', content: '${movie.revenue}'),
                        _tableContent(title: 'Tagline', content: movie.tagline),
                      ],
                    ),
                  ),
                ]);
          }

          return Container();
        },
      );
}
