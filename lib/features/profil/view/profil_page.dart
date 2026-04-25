import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/widgets/navbar.dart';
import '../viewmodel/profil_view_model.dart';
import '../widget/profil_list.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

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
              Row(
                children: [
                  CircleAvatar(radius: 30.r, backgroundImage: const AssetImage("assets/images/fotoprofil.png")),
                  SizedBox(width: 15.w),
                  Consumer<ProfileViewModel>(builder: (context, vm, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vm.userProfile?.name ?? "Kamilia Trisha",
                          style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          vm.userProfile?.email ?? "kamilTrisha@gmail.com",
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ],
                    );
                  })
                ],
              ),

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