import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:your_choices/src/presentation/blocs/customer/customer_cubit.dart';
import 'package:your_choices/utilities/date_format.dart';
import 'package:your_choices/utilities/text_style.dart';
import 'package:your_choices/src/presentation/views/home_view/deposit_view/deposit_view.dart';
import 'package:your_choices/src/presentation/views/home_view/withdraw_view/withdraw_view.dart';
import 'package:your_choices/utilities/hex_color.dart';

class TransactionView extends StatefulWidget {
  final String uid;
  const TransactionView({super.key, required this.uid});

  @override
  State<StatefulWidget> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  @override
  void initState() {
    context.read<CustomerCubit>().getSingleCustomer(uid: widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: size.height * 0.5,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                child: BlocBuilder<CustomerCubit, CustomerState>(
                                  builder: (context, state) {
                                    if (state is CustomerLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.orangeAccent,
                                        ),
                                      );
                                    } else if (state is CustomerLoaded) {
                                      if (state.customerEntity.profileUrl != null) {
                                        return Image.network(
                                          state.customerEntity.profileUrl!,
                                          fit: BoxFit.cover,
                                        );
                                      } else if (state.customerEntity.profileUrl ==
                                          null) {
                                        return const Icon(
                                          Icons.person,
                                        );
                                      } else {
                                        return Container();
                                      }
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "?????????????????? ????????????????????????????????????",
                                  style: GoogleFonts.ibmPlexSansThai(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                BlocBuilder<CustomerCubit, CustomerState>(
                                  builder: (context, state) {
                                    if (state is CustomerLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.orangeAccent,
                                        ),
                                      );
                                    }
                                    if (state is CustomerLoaded) {
                                      return Text(
                                        state.customerEntity.username!,
                                        style: GoogleFonts.ibmPlexSansThai(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      );
                                    }
                                    return Container();
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: size.width,
                          height: size.height / 4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  "#0F2027".toColor(),
                                  "#203A43".toColor(),
                                  "#2C5364".toColor(),
                                ]),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, left: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "????????????????????????????????? : ",
                                  style: GoogleFonts.ibmPlexSansThai(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 35),
                                  child: SizedBox(
                                    width: size.width,
                                    height: size.height / 7,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        BlocBuilder<CustomerCubit,
                                            CustomerState>(
                                          builder: (context, state) {
                                            if (state is CustomerLoading) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.orangeAccent,
                                                ),
                                              );
                                            }
                                            if (state is CustomerLoaded) {
                                              return Text(
                                                "??? ${state.customerEntity.balance}",
                                                style:
                                                    GoogleFonts.ibmPlexSansThai(
                                                  fontSize: 36,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              );
                                            }
                                            return Container();
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DepositView(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Container(
                                  width: size.width / 6,
                                  height: size.height / 12,
                                  decoration: BoxDecoration(
                                    color: "78A017".toColor(),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                  ),
                                  child:
                                      Image.asset("assets/images/deposit.png"),
                                ),
                              ),
                              Container(
                                width: size.width / 4,
                                height: size.height / 12,
                                decoration: BoxDecoration(
                                  color: "34312F".toColor(),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "?????????????????????",
                                    style: GoogleFonts.ibmPlexSansThai(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WithDrawView(uid: widget.uid),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Container(
                                  width: size.width / 6,
                                  height: size.height / 12,
                                  decoration: BoxDecoration(
                                    color: "FE7144".toColor(),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                  ),
                                  child:
                                      Image.asset("assets/images/withdraw.png"),
                                ),
                              ),
                              Container(
                                width: size.width / 4,
                                height: size.height / 12,
                                decoration: BoxDecoration(
                                  color: "34312F".toColor(),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "?????????????????????",
                                    style: GoogleFonts.ibmPlexSansThai(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "????????????????????????????????????",
                        style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "see all",
                        style: GoogleFonts.ibmPlexSansThai(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // .customerEntity.
                BlocBuilder<CustomerCubit, CustomerState>(
                  builder: (context, state) {
                    if (state is CustomerLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.orangeAccent,
                        ),
                      );
                    } else if (state is CustomerLoaded) {
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const ScrollPhysics(),
                        itemCount: state.customerEntity.transaction!.length,
                        itemBuilder: (context, index) {
                          
                          final date = DateConverter.dateFormat(
                              state.customerEntity.transaction![index].date);
                          if (state.customerEntity.transaction?.isNotEmpty ?? true) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: size.width * 0.23,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color:
                                              state.customerEntity.transaction![index].type ==
                                                      "deposit"
                                                  ? "78A017".toColor()
                                                  : "FE7144".toColor(),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                          ),
                                        ),
                                        child: Center(
                                          child: Builder(
                                            builder: (_) {
                                              if (state.customerEntity.transaction![index]
                                                      .type ==
                                                  "deposit") {
                                                return Image.asset(
                                                  "assets/images/deposit.png",
                                                  scale: 0.7,
                                                );
                                              } else if (state.customerEntity.transaction![index]
                                                      .type ==
                                                  "withdraw") {
                                                return Image.asset(
                                                  "assets/images/withdraw.png",
                                                  scale: 0.8,
                                                );
                                              } else if (state.customerEntity.transaction![index]
                                                      .type ==
                                                  "paid") {
                                                return Image.asset(
                                                  "assets/images/rice_pic.png",
                                                  scale: 0.8,
                                                );
                                              } else {
                                                return Container();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: size.width,
                                          height: 100,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (state.customerEntity.transaction![index]
                                                        .type ==
                                                    "deposit") ...[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10, top: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          date!,
                                                          style: GoogleFonts
                                                              .ibmPlexSansThai(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: Text(
                                                      state.customerEntity.transaction![index]
                                                          .name!,
                                                      style: GoogleFonts
                                                          .ibmPlexSansThai(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/money.png",
                                                        scale: 1,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10),
                                                        child: Text(
                                                          "??? ${state.customerEntity.transaction![index].deposit}",
                                                          style: GoogleFonts
                                                              .ibmPlexSansThai(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ] else if (state.customerEntity.transaction![index]
                                                        .type ==
                                                    "withdraw") ...[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10, top: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          date!,
                                                          style: GoogleFonts
                                                              .ibmPlexSansThai(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 6),
                                                    child: Text(state.customerEntity.transaction![index]
                                                          .name!,
                                                      style: GoogleFonts
                                                          .ibmPlexSansThai(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/money.png",
                                                        scale: 1,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10),
                                                        child: Text(
                                                          "??? ${state.customerEntity.transaction![index].withdraw}",
                                                          style: GoogleFonts
                                                              .ibmPlexSansThai(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ] else if (state.customerEntity.transaction![index]
                                                        .type ==
                                                    'paid') ...[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10, top: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Text(state.customerEntity.transaction?[
                                                                        index]
                                                                    .resName ??
                                                                "",
                                                            style: GoogleFonts
                                                                .ibmPlexSansThai(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Text(
                                                          date!,
                                                          style: GoogleFonts
                                                              .ibmPlexSansThai(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 6),
                                                    child: Text(
                                                      state.customerEntity.transaction![index]
                                                          .menuName!,
                                                      style: GoogleFonts
                                                          .ibmPlexSansThai(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/money.png",
                                                        scale: 1,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10),
                                                        child: Text(
                                                          "??? ${state.customerEntity.transaction![index].totalPrice}",
                                                          style: GoogleFonts
                                                              .ibmPlexSansThai(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ]
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 13,
                                  )
                                ],
                              ),
                            );
                          }
                          return Center(
                            child: Text(
                              "??????????????????????????????????????????????????? ??? ??????????????????",
                              style: AppTextStyle.googleFont(
                                  Colors.white, 24, FontWeight.bold),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          "??????????????????????????????????????????????????? ??? ??????????????????",
                          style: AppTextStyle.googleFont(
                              Colors.white, 24, FontWeight.bold),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
