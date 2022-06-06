import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mystore/bloc/store_bloc.dart';
import 'package:mystore/bloc/store_event.dart';
import 'package:mystore/bloc/store_state.dart';
import 'package:mystore/model/store_item.dart';
import 'package:mystore/repository/dummy_remote_repository.dart';
import 'package:mystore/ui/ui_util.dart';

import '../../model/common_response.dart';
import '../common/mytext.dart';

class StorePageProvider extends StatelessWidget {
  const StorePageProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoreBloc(context.read<DummyRemoteRepository>()),
      child: const StorePage(),
    );
  }
}

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StorePageState();
}

class StorePageState extends State<StorePage> {
  final scrollController = ScrollController();
  UiUtil? uiUtil;

  @override
  void initState() {
    super.initState();
    uiUtil = UiUtil(context);
    context.read<StoreBloc>().add(FetchDummy());
    scrollController.addListener(_onScroll);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyStore',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(5),
        child: RefreshIndicator(
          child: consumer,
          onRefresh: () async {
            context.read<StoreBloc>().add(ReloadItems());
          },
        ),
      ),
    );
  }

  Widget get consumer => BlocConsumer<StoreBloc, StoreState>(
        listener: storeListener,
        builder: (context, state) => state.storeItems.isEmpty
            ? state.loadingState == LoadingState.loading
                ? progress
                : noData
            : Column(
                children: [
                  Expanded(
                    child: gridView(state),
                  ),
                  if (state.loadingState == LoadingState.loading) progress,
                ],
              ),
      );

  Widget get noData => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.not_interested),
            const SizedBox(height: 6),
            const MyText('Tidak ada data.'),
            IconButton(
              onPressed: () {
                context.read<StoreBloc>().add(ReloadItems());
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      );

  Widget itemView(MapEntry<int, StoreItem> e) => e.value.discountPercentage > 0
      ? ClipRect(
          child: Banner(
            color: Colors.deepOrange,
            message: '${e.value.discountPercentage} % off',
            location: BannerLocation.topEnd,
            child: itemCard(e),
          ),
        )
      : itemCard(e);

  Widget itemCard(MapEntry<int, StoreItem> e) => GestureDetector(
        onTap: () => context.read<StoreBloc>().add(ChangeFavorite(e.key)),
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.all(5),
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  e.value.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (context, object, stackstrace) {
                    return const Icon(Icons.broken_image_outlined);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      e.value.title,
                    ),
                    const SizedBox(height: 6),
                    e.value.discountPercentage > 0
                        ? Row(
                            children: [
                              MyText(
                                "\$ ${e.value.price}",
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 7),
                              MyText(
                                "\$ ${(e.value.price - (e.value.price * e.value.discountPercentage / 100)).toStringAsFixed(2)}",
                                color: Colors.deepOrange,
                              ),
                            ],
                          )
                        : MyText(
                            "\$ ${e.value.price}",
                            color: Colors.deepOrange,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            for (int i = 0; i < e.value.rating.round(); i++)
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amberAccent,
                              ),
                          ],
                        ),
                        Icon(
                          e.value.favorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget gridView(StoreState state) => GridView.count(
        crossAxisCount: 2,
        controller: scrollController,
        children: state.storeItems
            .asMap()
            .entries
            .map(
              (e) => itemView(e),
            )
            .toList(),
      );

  Widget get progress => Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: const Center(
          child: SizedBox(
            height: 40,
            child: LoadingIndicator(
              indicatorType: Indicator.lineScale,
              colors: [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
              ],
            ),
          ),
        ),
      );

  void storeListener(BuildContext context, StoreState state) {
    final errorType = state.errorType;
    if (errorType != null) {
      String msg;
      switch (errorType) {
        case ResponseErrorType.connection:
          msg = 'Request failed. Please check your connection !';
          break;
        case ResponseErrorType.timeout:
          msg = 'Request failed. Timeout error.';
          break;
        case ResponseErrorType.auth:
          msg =
              'You are unauthenticated. Thus you can only send up to 10 requests per minute.';
          break;
        case ResponseErrorType.server:
          msg = 'Internal server error occured.';
          break;
        case ResponseErrorType.unknown:
          msg = 'Cannot get data from the server.';
          break;
      }
      uiUtil?.alert(
        msg: msg,
        title: 'Error',
      );
    }
  }

  void _onScroll() {
    final storeBloc = context.read<StoreBloc>();
    if (_isBottom) {
      storeBloc.add(FetchDummy());
    }
  }

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    return maxScroll == scrollController.position.pixels;
  }
}
