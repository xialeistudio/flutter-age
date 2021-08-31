import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 加载更多
class LoadMoreIndicator extends StatefulWidget {
  final LoadMoreCallback onLoadMore;
  final CustomScrollView child;
  final bool hasMore;

  const LoadMoreIndicator({
    Key? key,
    required this.onLoadMore,
    required this.child,
    required this.hasMore,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoadMoreIndicatorState();
  }
}

/// 回调函数
typedef LoadMoreCallback = Future<void> Function();

class _LoadMoreIndicatorState extends State<LoadMoreIndicator> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    var scrollView = widget.child;
    scrollView.slivers.add(
      SliverPadding(
        padding: const EdgeInsets.only(bottom: 20),
        sliver: SliverToBoxAdapter(child: _LoadMoreIndicatorBar(loading: _loading, hasMore: widget.hasMore)),
      ),
    );
    final Widget child = NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: scrollView,
    );

    return child;
  }

  /// 滚动监听
  bool _handleScrollNotification(ScrollNotification notification) {
    // 未滚动到底部
    if (notification.metrics.pixels != notification.metrics.maxScrollExtent) {
      return false;
    }
    if (!widget.hasMore || _loading) {
      return true;
    }
    loadData();
    return true;
  }

  /// 加载数据
  Future<void> loadData() async {
    setState(() {
      _loading = true;
    });
    try {
      await widget.onLoadMore();
      setState(() {
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _loading = false;
      });
    }
  }
}

/// 加载更多
class _LoadMoreIndicatorBar extends StatelessWidget {
  final bool loading;
  final bool hasMore;

  const _LoadMoreIndicatorBar({Key? key, required this.loading, required this.hasMore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container(
        alignment: Alignment.center,
        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator()),
        padding: const EdgeInsets.symmetric(vertical: 4),
      );
    }
    if (!hasMore) {
      return Container(
        child: Text('加载完毕', style: TextStyle(color: Colors.grey)),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 4),
      );
    }
    return Container();
  }
}
