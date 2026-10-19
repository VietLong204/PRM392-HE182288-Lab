import 'package:flutter/material.dart';
import '../../models/post.dart';
import '../../services/api_service.dart';
import 'post_detail_screen.dart';
import 'create_post_screen.dart';

/// PostListScreen – Main screen (Lab 8.1, 8.2, 8.3, 8.4 combined).
///
/// Features:
/// - Lab 8.1: Calls public REST API with http.get
/// - Lab 8.2: Parses JSON → List<Post> via Post.fromJson(), displays with ListView.builder
/// - Lab 8.3: Handles loading/error states with FutureBuilder
/// - Lab 8.4: Uses ApiService (Service Layer Pattern) – UI is clean, no networking logic
/// - Bonus: Pull-to-refresh, retry button, detail screen navigation, card UI
class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen>
    with SingleTickerProviderStateMixin {
  // ── ApiService (Lab 8.4) – separated networking concern ──
  final ApiService _apiService = ApiService();

  // ── Future holds the async API call result (Lab 8.2, 8.3) ──
  late Future<List<Post>> _postsFuture;

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _loadPosts();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // ── Lab 8.1 goal: retrieve API data successfully ──
  void _loadPosts() {
    setState(() {
      _postsFuture = _apiService.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      // ── AppBar ──
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF3D5AFE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lab 8 – API Posts',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'jsonplaceholder.typicode.com/posts',
              style: TextStyle(color: Color(0xFFBDB9FF), fontSize: 11),
            ),
          ],
        ),
        actions: [
          // ── Navigate to Create Post screen (POST request) ──
          IconButton(
            tooltip: 'Create new post (POST)',
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreatePostScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),

      // ─────────────────────────────────────────────
      // Lab 8.2 & 8.3: FutureBuilder binds async data to UI
      // ─────────────────────────────────────────────
      body: RefreshIndicator(
        // ── Bonus: Pull-to-refresh ──
        onRefresh: () async => _loadPosts(),
        color: const Color(0xFF6C63FF),
        backgroundColor: const Color(0xFF1A1D2E),
        child: FutureBuilder<List<Post>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            // ── State 1: waiting → show loading indicator (Lab 8.3) ──
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            // ── State 2: hasError → show error message + retry button (Lab 8.3) ──
            if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString());
            }

            // ── State 3: hasData → show ListView (Lab 8.2) ──
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return _buildPostList(snapshot.data!);
            }

            // ── Empty state ──
            return _buildEmptyState();
          },
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Loading State – Lab 8.3
  // ─────────────────────────────────────────────
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Fetching posts...',
            style: TextStyle(
              color: Color(0xFFB0B3C6),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'GET /posts',
            style: TextStyle(
              color: const Color(0xFF6C63FF).withOpacity(0.7),
              fontSize: 13,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Error State – Lab 8.3 (with Retry button)
  // ─────────────────────────────────────────────
  Widget _buildErrorState(String error) {
    final message = error.replaceFirst('Exception: ', '');
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                size: 40,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFB0B3C6),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            // ── Retry Button ──
            ElevatedButton.icon(
              onPressed: _loadPosts,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                'Retry',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Post List – Lab 8.2 (ListView.builder)
  // ─────────────────────────────────────────────
  Widget _buildPostList(List<Post> posts) {
    return Column(
      children: [
        // ── Header Info Bar ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: const Color(0xFF1A1D2E),
          child: Row(
            children: [
              const Icon(Icons.cloud_done, color: Color(0xFF00D4AA), size: 16),
              const SizedBox(width: 8),
              Text(
                '${posts.length} posts loaded',
                style: const TextStyle(
                  color: Color(0xFF00D4AA),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(Icons.swipe_down, color: Color(0xFF555870), size: 14),
              const SizedBox(width: 4),
              const Text(
                'Pull to refresh',
                style: TextStyle(color: Color(0xFF555870), fontSize: 12),
              ),
            ],
          ),
        ),

        // ── ListView.builder (Lab 8.2) ──
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return _PostCard(post: post, index: index);
            },
          ),
        ),
      ],
    );
  }

  // ── Empty State ──
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Color(0xFF555870)),
          SizedBox(height: 16),
          Text(
            'No posts found',
            style: TextStyle(color: Color(0xFFB0B3C6), fontSize: 18),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PostCard Widget – displays one post item
// Shows title + ID (as required by Lab 8.2)
// ─────────────────────────────────────────────
class _PostCard extends StatefulWidget {
  final Post post;
  final int index;

  const _PostCard({required this.post, required this.index});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + widget.index * 30),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: _isHovered
                  ? const Color(0xFF1E2235)
                  : const Color(0xFF1A1D2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isHovered
                    ? const Color(0xFF6C63FF).withOpacity(0.5)
                    : const Color(0xFF2A2D3E),
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailScreen(post: widget.post),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── ID Badge ──
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF3D5AFE)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${widget.post.id}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      // ── Title + Preview ──
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.post.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.post.body,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF777A8E),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.person_outline,
                                  size: 12,
                                  color: Color(0xFF6C63FF),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'User ${widget.post.userId}',
                                  style: const TextStyle(
                                    color: Color(0xFF6C63FF),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // ── Arrow ──
                      const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF555870),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
