import '../model/common_response.dart';
import '../model/store_item.dart';

enum LoadingState { idle, loading }

class StoreState {
  final LoadingState loadingState;
  final ResponseErrorType? errorType;
  final List<StoreItem> storeItems;
  final int page;

  StoreState({
    this.loadingState = LoadingState.idle,
    this.errorType,
    this.storeItems = const <StoreItem>[],
    this.page = 1,
  });
}
