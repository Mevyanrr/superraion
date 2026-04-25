import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/widgets/navbar.dart';
import '../viewmodel/profil_view_model.dart';
import '../widget/profil_list.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadFromFirestore(); // ← tambah ini
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  "My Profile",
                  style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30.h),

              // User Info Section
              Consumer<ProfileViewModel>(
                builder: (context, vm, _) {
                  if (vm.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 30.r,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: vm.userProfile?.avatarUrl != null &&
                            vm.userProfile!.avatarUrl!.isNotEmpty
                            ? NetworkImage(vm.userProfile!.avatarUrl!)
                            : null,
                        child: vm.userProfile?.avatarUrl == null ||
                            vm.userProfile!.avatarUrl!.isEmpty
                            ? Icon(Icons.person, size: 30.sp, color: Colors.grey)
                            : null,
                      ),
                      SizedBox(width: 15.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vm.userProfile?.name ?? 'User',
                            style: TextStyle(
                                fontSize: 19.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            vm.userProfile?.email ?? '',
                            style: TextStyle(
                                fontSize: 12.sp, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              // ... sisanya sama persis tidak berubah

              SizedBox(height: 20.h),

              // Subscribe Card
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.pinkMedium.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.workspace_premium, color: AppColors.pinkMedium),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Subscribe", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            "Personalize consultation",
                            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.pinkMedium),
                      onPressed: () {},
                      child: Text("Subscribe Now", style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              // Account Section
              _buildSectionGroup("Account", [
                ProfileListTile(icon: Icons.settings, title: "Account Setting", onTap: () {}),
                Divider(height: 1, indent: 60.w, color: Colors.grey.withOpacity(0.2)),
                ProfileListTile(icon: Icons.notifications, title: "Notifications", onTap: () {}),
              ]),

              // Others Section
              _buildSectionGroup("Others", [
                ProfileListTile(icon: Icons.security, title: "Privacy & Security", onTap: () {}),
                Divider(height: 1, indent: 60.w, color: Colors.grey.withOpacity(0.2)),
                ProfileListTile(icon: Icons.help_outline, title: "Help & FAQ", onTap: () {}),
              ]),

              // Logout Button
              SizedBox(height: 10.h),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.pinkMedium,
                  side: BorderSide(color: AppColors.pinkMedium),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                onPressed: () {},
                child: Center(child: Text("Logout")),
              ),
              SizedBox(height: 70.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MainNavbarView(),
    );
  }

  Widget _buildSectionGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1F2937),
        ),
      ),
    );
  }
}