import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:insta_clone/constants/common_size.dart';
import 'package:insta_clone/widgets/rounded_avatar.dart';

class ProfileBody extends StatefulWidget {
  final Function onMenuChanged;
  const ProfileBody({Key? key, required this.onMenuChanged}) : super(key: key);

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final AnimationController _iconAnimationController;

  @override
  void initState() {
    super.initState();   // ① ALWAYS first
    _tabController = TabController(length: 3, vsync: this);
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        // App bar with animated menu icon
        _buildAppBar(),
        // Profile header: avatar, stats, name, bio, edit button
        SliverToBoxAdapter(child: _buildProfileHeader()),
        // Pinned TabBar
        SliverPersistentHeader(
          pinned: true,
          delegate: _TabBarDelegate(
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.black,
              tabs: [
                Tab(icon: ImageIcon(AssetImage('assets/images/grid.png'))),
                Tab(icon: ImageIcon(AssetImage('assets/images/profile_video.png'))),
                Tab(icon: ImageIcon(AssetImage('assets/images/profile_tag.png'))),
              ],
            ),
          ),
        ),
      ],
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGridPage(),
          _buildVideoPage(),
          _buildTaggedPage(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 0,
      surfaceTintColor: Colors.transparent, // 스크롤 시 틴트 효과 제거
      // scrolledUnderElevation: 0.0, // 혹시 모르니 이것도 명시 (선택 사항)
      title: Padding(
        padding: const EdgeInsets.only(left: common_gap),
        child: Text(
          'Profile Name',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            widget.onMenuChanged();
            if (_iconAnimationController.status == AnimationStatus.completed) {
              _iconAnimationController.reverse();
            } else {
              _iconAnimationController.forward();
            }
          },
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _iconAnimationController,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: common_gap),
                child: RoundedAvatar(size: 80),
              ),
              Expanded(child: _buildStatsTable()),
            ],
          ),
          const SizedBox(height: common_xs_gap),
          _buildUsername(),
          _buildUserBio(),
          const SizedBox(height: common_xxs_gap),
          _buildEditButtons(),
        ],
      ),
    );
  }

  Widget _buildStatsTable() {
    return Table(
      children: [
        TableRow(children: [
          _valueText('123'),
          _valueText('54'),
          _valueText('44'),
        ]),
        TableRow(children: [
          _labelText('Posts'),
          _labelText('Followers'),
          _labelText('Following'),
        ]),
      ],
    );
  }

  Text _valueText(String value) => Text(
    value,
    textAlign: TextAlign.center,
    style: const TextStyle(fontWeight: FontWeight.bold),
  );

  Text _labelText(String label) => Text(
    label,
    textAlign: TextAlign.center,
    style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
  );

  Widget _buildUsername() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: common_xxs_gap),
      child: Text(
        'Real User Name',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildUserBio() {
    return Text(
      'This is the user bio.',
      style: const TextStyle(fontWeight: FontWeight.w400),
    );
  }

  Widget _buildEditButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: common_xs_gap),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black87),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                foregroundColor: Colors.black87,
              ),
              child: const Text('Edit Profile'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black87),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                foregroundColor: Colors.black87,
              ),
              child: const Text('Share Profile'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridPage() {
    return CustomScrollView(
      slivers: [
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          delegate: SliverChildBuilderDelegate(
                (context, index) => CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: "https://picsum.photos/id/${index + 50}/200/200",
              placeholder: (ctx, url) => Container(color: Colors.grey[300]),
              errorWidget: (ctx, url, error) => const Icon(Icons.error),
            ),
            childCount: 27,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPage() {
    return CustomScrollView(
      slivers: [
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.videocam)),
            ),
            childCount: 27,
          ),
        ),
      ],
    );
  }

  Widget _buildTaggedPage() {
    return CustomScrollView(
      slivers: [
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
              color: Colors.grey[200],
              child: const Center(child: Icon(Icons.tag)),
            ),
            childCount: 27,
          ),
        ),
      ],
    );
  }
}

/// Delegate to pin the TabBar in the NestedScrollView
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _TabBarDelegate(this._tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
