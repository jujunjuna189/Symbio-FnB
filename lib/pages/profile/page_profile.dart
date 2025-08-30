import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_simple_v2/pages/profile/bloc/bloc_profile.dart';
import 'package:pos_simple_v2/pages/profile/state/state_profile.dart';
import 'package:pos_simple_v2/pages/profile/widget/modal/modal_update_outlet.dart';
import 'package:pos_simple_v2/pages/profile/widget/modal/modal_update_profile.dart';
import 'package:pos_simple_v2/utils/theme/theme.dart';
import 'package:pos_simple_v2/widgets/atoms/button/button.dart';

class PageProfile extends StatelessWidget {
  const PageProfile({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProfile blocProfile = context.read<BlocProfile>();
    return Scaffold(
      backgroundColor: ThemeApp.color.grey,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          children: [
            Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Navigator.of(context).pop(),
                  child: Transform.translate(
                    offset: const Offset(-10, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          color: ThemeApp.color.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(Icons.chevron_left, color: ThemeApp.color.white, size: 20),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Profil", style: ThemeApp.font.bold.copyWith(fontSize: 18)),
                      Text(
                        "Atur Profil & Toko Disini",
                        style: ThemeApp.font.regular.copyWith(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text("Detail Pengguna", style: ThemeApp.font.semiBold),
            SizedBox(height: 3),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(color: ThemeApp.color.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [ThemeApp.color.white, ThemeApp.color.white]),
                          border: Border.all(width: 1, color: Colors.black.withOpacity(0.3)),
                        ),
                        child: Icon(Icons.person),
                      ),
                      SizedBox(width: 10),
                      BlocBuilder<BlocProfile, StateProfile>(
                        bloc: blocProfile,
                        builder: (context, state) {
                          final currentState = state as ProfileLoaded;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(currentState.user?.name ?? "Nama Pengguna", style: ThemeApp.font.semiBold),
                              Text(
                                currentState.user?.email ?? "Nama pengguna belum ditambahkan",
                                style: ThemeApp.font.regular.copyWith(fontSize: 10),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<BlocProfile, StateProfile>(
                          bloc: blocProfile,
                          builder: (context, state) {
                            final currentState = state as ProfileLoaded;
                            return Button(
                              onPress: () => ModalUpdateProfile.instance.show(
                                context,
                                blocProfile: blocProfile,
                                user: currentState.user,
                              ),
                              child: Text(
                                "Ubah Data Pengguna",
                                textAlign: TextAlign.center,
                                style: ThemeApp.font.semiBold.copyWith(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text("Detail Toko", style: ThemeApp.font.semiBold),
            SizedBox(height: 3),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(color: ThemeApp.color.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [ThemeApp.color.white, ThemeApp.color.white]),
                          border: Border.all(width: 1, color: Colors.black.withOpacity(0.3)),
                        ),
                        child: Icon(Icons.storefront_outlined),
                      ),
                      SizedBox(width: 10),
                      BlocBuilder<BlocProfile, StateProfile>(
                        bloc: blocProfile,
                        builder: (context, state) {
                          final currentState = state as ProfileLoaded;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(currentState.outlet?.name ?? "Nama Toko", style: ThemeApp.font.semiBold),
                              Text(
                                currentState.outlet?.phone ?? "Nama toko belum ditambahkan",
                                style: ThemeApp.font.regular.copyWith(fontSize: 10),
                              ),
                              Text(
                                currentState.outlet?.address ?? "Nomor hp & alamat belum ditambahkan",
                                style: ThemeApp.font.regular.copyWith(fontSize: 10),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: BlocBuilder<BlocProfile, StateProfile>(
                          bloc: blocProfile,
                          builder: (context, state) {
                            final currentState = state as ProfileLoaded;
                            return Button(
                              onPress: () => ModalUpdateOutlet.instance.show(
                                context,
                                blocProfile: blocProfile,
                                outlet: currentState.outlet,
                              ),
                              child: Text(
                                "Ubah Data Toko",
                                textAlign: TextAlign.center,
                                style: ThemeApp.font.semiBold.copyWith(fontSize: 10),
                              ),
                            );
                          },
                        ),
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
  }
}
