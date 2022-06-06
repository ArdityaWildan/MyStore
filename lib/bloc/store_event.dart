abstract class StoreEvent {}

class FetchDummy extends StoreEvent {}

class ChangeFavorite extends StoreEvent {
  final int position;

  ChangeFavorite(this.position);
  
}

class ReloadItems extends StoreEvent {} 
