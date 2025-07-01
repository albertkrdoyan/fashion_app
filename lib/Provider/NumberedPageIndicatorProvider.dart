import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageIndicator{
  int currentPage;
  int totalPagesCount;

  PageIndicator({this.currentPage = 0, required this.totalPagesCount});
}

class PageIndicatorProvider extends Notifier<PageIndicator>{
  @override
  PageIndicator build() {
    return PageIndicator(totalPagesCount: 0);
  }

  void setPagesCount(int count){
    state.totalPagesCount = count;
  }

  void changeCurrentPage(int changeTo){
    state = PageIndicator(totalPagesCount: state.totalPagesCount, currentPage: changeTo);
  }
}

final numberedPageIndicatorProvider = NotifierProvider<PageIndicatorProvider, PageIndicator>(() {
  return PageIndicatorProvider();
},);

class ListItemsCount extends Notifier<int>{
  @override
  int build() {
    return 0;
  }

  void update(int count){
    state = count;
  }
}

final listItemsCountProvider = NotifierProvider<ListItemsCount, int>(() {
  return ListItemsCount();
},);