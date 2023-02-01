import 'package:flutter/material.dart';
import 'package:flutter_movie/injector.dart';
import 'package:flutter_movie/movie/providers/movie_get_detail_provider.dart';
import 'package:flutter_movie/widget/item_movie_widget.dart';
import 'package:flutter_movie/widget/web_view_widget.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatelessWidget {
  const MovieDetailPage({super.key, required this.id});

  final int id;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          getIt<MovieGetDetailProvider>()..getDetail(context, id: id),
      builder: (context, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            _WidgetAppBar(context),
            _WidgetSummary(),
          ],
        ),
      ),
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

class _WidgetSummary extends SliverToBoxAdapter {
  Widget _content({required String title, required Widget body}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          body,
          const SizedBox(height: 16),
        ],
      );

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
  Widget? get child => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<MovieGetDetailProvider>(
          builder: (context, value, child) {
            final movie = value.movie;

            if (movie != null) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _content(
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
                    _content(
                      title: 'Genres',
                      body: Wrap(
                        spacing: 8,
                        children: movie.genres
                            .map((e) => Chip(label: Text(e.name)))
                            .toList(),
                      ),
                    ),
                    _content(
                      title: 'Overview',
                      body: Text(
                        movie.overview,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    _content(
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
                          _tableContent(
                              title: 'Tagline', content: movie.tagline),
                        ],
                      ),
                    ),
                  ]);
            }

            return Container();
          },
        ),
      );
}
