import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mystore/bloc/store_event.dart';
import 'package:mystore/bloc/store_state.dart';
import 'package:mystore/model/store_item.dart';
import 'package:mystore/repository/dummy_remote_repository.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final DummyRemoteRepository dummyRemoteRepository;
  StoreBloc(this.dummyRemoteRepository) : super(StoreState()) {
    on<FetchDummy>(fetchDummy);
    on<ChangeFavorite>(changeFavorite);
    on<ReloadItems>(reloadItems);
  }

  void changeFavorite(ChangeFavorite event, Emitter<StoreState> emit) {
    final item = state.storeItems.elementAt(event.position);
    final updated = StoreItem(
      id: item.id,
      title: item.title,
      description: item.description,
      thumbnail: item.thumbnail,
      price: item.price,
      discountPercentage: item.discountPercentage,
      rating: item.rating,
      favorite: !item.favorite,
    );

    final items = List.of(state.storeItems);
    items.replaceRange(event.position, event.position + 1, [updated]);
    emit(
      StoreState(
        page: state.page,
        storeItems: items,
      ),
    );
  }

  void reloadItems(ReloadItems event, Emitter<StoreState> emit) async {
    emit(StoreState());
    return fetchDummy(FetchDummy(), emit);
  }

  void fetchDummy(FetchDummy event, Emitter<StoreState> emit) async {
    emit(
      StoreState(
        loadingState: LoadingState.loading,
        page: state.page,
        storeItems: state.storeItems,
      ),
    );

    final data = await dummyRemoteRepository.fetchData(state.page);
    final error = data.errorType;
    if (error == null) {
      // log(data.data);
      // success
      final parsed = json
          .decode(data.data)['products']
          .map<StoreItem>(
            (json) => StoreItem.fromJson(json),
          )
          .toList();

      return emit(
        StoreState(
          storeItems: List.of(state.storeItems)..addAll(parsed),
          page: state.page + 1,
        ),
      );
    }
    emit(
      StoreState(
        errorType: error,
        storeItems: state.storeItems,
        page: state.page,
      ),
    );
  }
}
