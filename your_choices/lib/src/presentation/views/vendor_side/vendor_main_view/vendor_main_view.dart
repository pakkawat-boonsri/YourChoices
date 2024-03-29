import 'dart:ui';

import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/global.dart';
import 'package:your_choices/injection_container.dart' as di;
import 'package:your_choices/src/config/app_routes/on_generate_routes.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/presentation/blocs/vendor_bloc/order_history/order_history_cubit.dart';
import 'package:your_choices/src/presentation/views/vendor_side/order_history_view.dart/order_history_view.dart';
import 'package:your_choices/src/presentation/views/vendor_side/today_order_view/cubit/today_order_cubit.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/text_style.dart';

import '../../../blocs/utilities_bloc/auth/auth_cubit.dart';
import '../../../blocs/vendor_bloc/vendor/vendor_cubit.dart';

class VendorMainView extends StatefulWidget {
  final String uid;

  const VendorMainView({super.key, required this.uid});

  @override
  State<VendorMainView> createState() => _VendorMainViewState();
}

class _VendorMainViewState extends State<VendorMainView> {
  List<AssetImage> images = [
    const AssetImage("assets/images/menu.png"),
    const AssetImage("assets/images/restaurant.png"),
    const AssetImage("assets/images/record.png"),
  ];

  List<String> imageTitles = [
    "เมนูอาหาร",
    "ข้อมูลร้าน",
    "ประวัติการสั่งซื้อ",
  ];

  @override
  void initState() {
    BlocProvider.of<VendorCubit>(context).getSingleVendor(uid: widget.uid);
    BlocProvider.of<TodayOrderCubit>(context).receiveOrderFromCustomer(widget.uid, OrderTypes.pending.toString());
    super.initState();
  }

  String? logout;
  bool? isActive;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(150),
          child: BlocBuilder<VendorCubit, VendorState>(
            builder: (context, vendorState) {
              if (vendorState is VendorLoaded) {
                VendorEntity vendorEntity = vendorState.vendorEntity;
                return headerTitle(size, vendorEntity, context);
              }
              return Container();
            },
          ),
        ),
        flexibleSpace: FlexibleSpaceBar(
          background: BlocBuilder<VendorCubit, VendorState>(
            builder: (context, vendorState) {
              if (vendorState is VendorLoaded) {
                VendorEntity vendorEntity = vendorState.vendorEntity;
                return blurImageBg(size, vendorEntity);
              }
              return Container();
            },
          ),
        ),
        elevation: 0,
        title: PopupMenuButton(
          child: const Icon(Icons.exit_to_app_rounded),
          itemBuilder: (context) => [
            PopupMenuItem(
              textStyle: AppTextStyle.googleFont(
                Colors.black,
                14,
                FontWeight.w400,
              ),
              onTap: () => BlocProvider.of<AuthCubit>(context).loggingOut(),
              child: const Text(
                "Logout",
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // _buildBlocHeaderSection(size),
          const SizedBox(
            height: 20,
          ),
          _buildOrderContainer(size),
          const SizedBox(
            height: 20,
          ),
          _buildFeatureText(size),
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<VendorCubit, VendorState>(
            builder: (context, state) {
              if (state is VendorLoaded) {
                VendorEntity vendorEntity = state.vendorEntity;
                return _buildGridViewBuilder(vendorEntity);
              }
              return Container();
            },
          )
        ],
      ),
    );
  }

  _onSelectedRouter(int index, VendorEntity vendorEntity) {
    switch (index) {
      case 0:
        {
          return Navigator.pushNamed(
            context,
            PageConst.menuPage,
            arguments: widget.uid,
          );
        }
      case 1:
        {
          return Navigator.pushNamed(
            context,
            PageConst.restaurantInfoPage,
            arguments: vendorEntity,
          );
        }
      case 2:
        {
          return Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => di.sl<OrderHistoryCubit>(),
                  child: OrderHistoryView(vendorEntity: vendorEntity),
                ),
              ));
        }
      default:
    }
  }

  Widget _buildGridViewBuilder(VendorEntity vendorEntity) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: images.length,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 150,
      ),
      itemBuilder: (BuildContext context, int index) {
        return TouchableOpacity(
          onTap: () => _onSelectedRouter(index, vendorEntity),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                index != 2
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: 80,
                          height: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: "D9D9D9".toColor(),
                            image: DecorationImage(
                              alignment: Alignment.center,
                              image: images[index],
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: 80,
                          height: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: "D9D9D9".toColor(),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                width: 80,
                                height: 80,
                                left: 4,
                                child: Image.asset(
                                  "assets/images/record.png",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                const Spacer(),
                Text(
                  imageTitles[index],
                  style: AppTextStyle.googleFont(
                    Colors.black,
                    16,
                    FontWeight.w500,
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }

  Container _buildFeatureText(Size size) {
    return Container(
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "ฟีเจอร์ต่างๆ",
        style: AppTextStyle.googleFont(
          Colors.white,
          26,
          FontWeight.w600,
        ),
      ),
    );
  }

  BlocBuilder<VendorCubit, VendorState> _buildOrderContainer(Size size) {
    return BlocBuilder<VendorCubit, VendorState>(
      builder: (context, vendorState) {
        if (vendorState is VendorLoaded) {
          VendorEntity vendorEntity = vendorState.vendorEntity;

          return TouchableOpacity(
            onTap: vendorEntity.isActive == true
                ? () {
                    Navigator.pushNamed(context, PageConst.todayOrderPage, arguments: vendorEntity.uid);
                  }
                : null,
            child: Container(
              width: size.width,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: vendorEntity.isActive! ? Colors.green : Colors.red,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    BlocBuilder<TodayOrderCubit, TodayOrderState>(
                      builder: (context, state) {
                        if (state is TodayOrderLoading) {
                          return const Icon(
                            CupertinoIcons.cart,
                            color: Colors.white,
                            size: 26,
                          );
                        } else if (state is TodayOrderLoaded) {
                          return state.orderEntities
                                  .where((element) => element.orderTypes == OrderTypes.pending.toString())
                                  .isNotEmpty
                              ? badges.Badge(
                                  position: badges.BadgePosition.topEnd(top: -16, end: -12),
                                  badgeContent: Text(
                                    "${state.orderEntities.length}",
                                    style: AppTextStyle.googleFont(
                                      Colors.white,
                                      14,
                                      FontWeight.w500,
                                    ),
                                  ),
                                  badgeStyle: const badges.BadgeStyle(
                                    badgeColor: Colors.red,
                                    padding: EdgeInsets.all(6),
                                  ),
                                  showBadge: state.orderEntities.isNotEmpty,
                                  child: const Icon(
                                    CupertinoIcons.cart,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                )
                              : const Icon(
                                  CupertinoIcons.cart,
                                  color: Colors.white,
                                  size: 26,
                                );
                        }
                        return Container();
                      },
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "ออเดอร์สำหรับวันนี้",
                      style: AppTextStyle.googleFont(
                        Colors.white,
                        18,
                        FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 4.5,
                            child: Icon(
                              CupertinoIcons.forward,
                              size: 23,
                              color: vendorEntity.isActive! ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget headerTitle(
    Size size,
    VendorEntity vendorEntity,
    BuildContext context,
  ) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          width: size.width,
          child: Text(
            "${vendorEntity.resName}",
            style: AppTextStyle.googleFont(
              Colors.white,
              24,
              FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${vendorEntity.username}",
                style: AppTextStyle.googleFont(
                  Colors.white,
                  18,
                  FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 56,
                height: 56,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: vendorEntity.profileUrl != null || vendorEntity.profileUrl != ""
                      ? CachedNetworkImage(
                          imageUrl: vendorEntity.profileUrl!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset("assets/images/image_picker.png"),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: size.width,
          height: 49,
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.store,
                  size: 26,
                  color: vendorEntity.isActive! ? Colors.green : Colors.red,
                ),
                const SizedBox(
                  width: 10,
                ),
                vendorEntity.isActive!
                    ? Text(
                        "เปิดรับออเดอร์",
                        style: AppTextStyle.googleFont(
                          Colors.green,
                          17,
                          FontWeight.w500,
                        ),
                      )
                    : Text(
                        "ปิดรับออเดอร์",
                        style: AppTextStyle.googleFont(
                          Colors.red,
                          17,
                          FontWeight.w500,
                        ),
                      ),
                const Spacer(),
                const VerticalDivider(
                  endIndent: 7,
                  indent: 7,
                  color: Colors.grey,
                  thickness: 1,
                ),
                const SizedBox(
                  width: 3,
                ),
                TouchableOpacity(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          children: [
                            ListTile(
                              onTap: () async {
                                await BlocProvider.of<VendorCubit>(context)
                                    .openAndCloseRestaurant(
                                  vendorEntity.copyWith(isActive: true),
                                )
                                    .then((value) {
                                  if (mounted) {
                                    Navigator.of(context).pop();
                                  }
                                });
                              },
                              title: Text(
                                "เปิดร้าน",
                                style: AppTextStyle.googleFont(
                                  Colors.black,
                                  18,
                                  FontWeight.w500,
                                ),
                              ),
                            ),
                            const Divider(
                              indent: 10,
                              endIndent: 10,
                              height: 1,
                              color: Colors.black,
                            ),
                            ListTile(
                              onTap: () async {
                                await BlocProvider.of<VendorCubit>(context)
                                    .openAndCloseRestaurant(
                                  vendorEntity.copyWith(isActive: false),
                                )
                                    .then((value) {
                                  if (mounted) {
                                    Navigator.of(context).pop();
                                  }
                                });
                              },
                              title: Text(
                                "ปิดร้าน",
                                style: AppTextStyle.googleFont(
                                  Colors.black,
                                  18,
                                  FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    "เปลี่ยน",
                    style: AppTextStyle.googleFont(
                      Colors.grey,
                      17,
                      FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Container blurImageBg(Size size, VendorEntity vendorEntity) {
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(vendorEntity.resProfileUrl!),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4,
            sigmaY: 4,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.0),
            ),
          ),
        ),
      ),
    );
  }
}
