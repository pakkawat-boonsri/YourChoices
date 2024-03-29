import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:your_choices/src/domain/entities/vendor/vendor_entity.dart';
import 'package:your_choices/src/presentation/views/customer_side/customer_main_view/customer_main_view.dart';
import 'package:your_choices/utilities/box_shadow.dart';
import 'package:your_choices/utilities/hex_color.dart';
import 'package:your_choices/utilities/text_style.dart';

import '../../../../utilities/show_flutter_toast.dart';
import '../../../config/app_routes/on_generate_routes.dart';
import '../../../domain/entities/customer/customer_entity.dart';
import '../../blocs/utilities_bloc/auth/auth_cubit.dart';
import '../../blocs/utilities_bloc/credential/credential_cubit.dart';
import '../vendor_side/vendor_main_view/vendor_main_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _regisKey = GlobalKey<FormState>();
  final _btmFormKey = GlobalKey<FormState>();

  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final resName = TextEditingController();
  final resDescription = TextEditingController();

  String selectingType = 'customer';
  bool isBottomSheetShow = false;
  File? imageFile;
  File? resImageFile;

  List<String> restaurantTypes = ["ร้านอาหารตามสั่ง", "ร้านข้าวแกง", "ร้านก๋วยเตี๋ยว", "ร้านเครื่องดื่ม"];

  String restaurantType = "ร้านก๋วยเตี๋ยว";

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    resName.dispose();
    resDescription.dispose();
    super.dispose();
  }

  bool isClick = false;
  bool isObscurePassword = true;
  bool isObscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocConsumer<CredentialCubit, CredentialState>(
      listener: (context, credentialState) {
        if (credentialState is CredentialSuccess) {
          BlocProvider.of<AuthCubit>(context).loggedIn();
        }
        if (credentialState is CredentialFailure) {
          showFlutterToast("Invalid Email and Password");
        }
      },
      builder: (context, credentialState) {
        if (credentialState is CredentialSuccess) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                if (state.type == "restaurant") {
                  return VendorMainView(uid: state.uid);
                } else {
                  return CustomerMainView(uid: state.uid);
                }
              } else {
                return bodySelection(size, context);
              }
            },
          );
        }
        return bodySelection(size, context);
      },
    );
  }

  Scaffold bodySelection(Size size, BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            reverse: isClick,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 95),
                  child: Container(
                    width: size.width,
                    height: size.height,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        headerContent(),
                        resgisterTextFormFields(),
                        selectingType == "customer"
                            ? ElevatedButton(
                                onPressed: () async {
                                  final result = _regisKey.currentState!.validate();
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.amber,
                                        ),
                                      );
                                    },
                                  );
                                  if (result) {
                                    await BlocProvider.of<CredentialCubit>(context).signUpCustomer(
                                      customerEntity: CustomerEntity(
                                        email: email.text,
                                        password: password.text,
                                        username: username.text,
                                        type: selectingType,
                                        balance: 0,
                                        imageFile: imageFile,
                                      ),
                                    );
                                    if (mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.amber.shade900),
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(horizontal: 100.0),
                                  ),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "ลงทะเบียน",
                                  style: GoogleFonts.ibmPlexSansThai(fontSize: 16, fontWeight: FontWeight.normal),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  final result = _regisKey.currentState!.validate();
                                  if (result) {
                                    isBottomSheetShow = true;
                                    await vendorModelSheet(context);
                                  } else {
                                    return;
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.amber.shade900,
                                  ),
                                  padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                      horizontal: 100.0,
                                    ),
                                  ),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "ต่อไป",
                                  style: GoogleFonts.ibmPlexSansThai(fontSize: 16, fontWeight: FontWeight.normal),
                                ),
                              ),
                        const SizedBox(
                          height: 15,
                        ),
                        RichTextNavigatorText(
                          size: size,
                        ),
                      ],
                    ),
                  ),
                ),
                Image.asset(
                  "assets/images/ic_launcher_round.png",
                  scale: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget resgisterTextFormFields() {
    return Form(
      key: _regisKey,
      child: StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              TextFormField(
                onTap: () {
                  setState(() {
                    isClick = true;
                  });
                },
                onChanged: (value) {
                  setState(() {});
                },
                controller: username,
                keyboardType: TextInputType.name,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  labelText: "ชื่อผู้ใช้",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  suffixIcon: username.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            username.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.amber.shade900,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.amber.shade900,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "โปรดกรอกชื่อผู้ใช้ของท่าน";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                onTap: () {
                  setState(() {
                    isClick = true;
                  });
                },
                onChanged: (value) {
                  setState(() {});
                },
                controller: email,
                keyboardType: TextInputType.name,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  labelText: "อีเมล",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  suffixIcon: email.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            email.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear),
                        )
                      : null,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.amber.shade900,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.amber.shade900,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.mail_outline,
                    color: Colors.black,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "โปรดกรอกชื่ออีเมลของท่าน";
                  }
                  String pattern = r'\w+@\w+\.\w+';
                  if (!RegExp(pattern).hasMatch(value)) {
                    return 'ฟอร์แมตไม่ตรงกับการกรอกอีเมล';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                onTap: () {
                  setState(() {
                    isClick = true;
                  });
                },
                onChanged: (value) {
                  setState(() {});
                },
                controller: password,
                keyboardType: TextInputType.name,
                autocorrect: false,
                obscureText: isObscurePassword,
                enableSuggestions: false,
                decoration: InputDecoration(
                  labelText: "รหัสผ่าน",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  suffixIcon: password.text.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => setState(() {
                                isObscurePassword = !isObscurePassword;
                              }),
                              icon: isObscurePassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                            ),
                            IconButton(
                              onPressed: () {
                                password.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.clear),
                            ),
                          ],
                        )
                      : null,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.amber.shade900,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.amber.shade900,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.black,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "โปรดกรอกรหัสผ่านของท่าน";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                onTap: () {
                  setState(() {
                    isClick = true;
                  });
                },
                onChanged: (value) {
                  setState(() {});
                },
                controller: confirmPassword,
                keyboardType: TextInputType.name,
                autocorrect: false,
                obscureText: isObscureConfirmPassword,
                enableSuggestions: false,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelText: "คอนเฟิร์มรหัสผ่าน",
                  suffixIcon: confirmPassword.text.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isObscureConfirmPassword = !isObscureConfirmPassword;
                                });
                              },
                              icon:
                                  isObscureConfirmPassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                            ),
                            IconButton(
                              onPressed: () {
                                confirmPassword.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.clear),
                            ),
                          ],
                        )
                      : null,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.amber.shade900,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.amber.shade900,
                      width: 1.5,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.black,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "โปรดกรอกยืนยันรหัสผ่านของท่าน";
                  } else if (password.text != confirmPassword.text) {
                    return "รหัสผ่านยืนยันไม่ตรงกับรหัสผ่านของท่าน";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: "customer",
                        groupValue: selectingType,
                        onChanged: ((value) {
                          this.setState(() {
                            selectingType = value.toString();
                            log(selectingType);
                          });
                        }),
                      ),
                      const Text("ลูกค้า")
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Radio(
                            value: "restaurant",
                            groupValue: selectingType,
                            onChanged: ((value) {
                              this.setState(
                                () {
                                  selectingType = value.toString();
                                  log(selectingType);
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                      const Text("ร้านอาหาร"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> vendorModelSheet(BuildContext context) {
    return showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Wrap(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ข้อมูลร้านค้า",
                          style: AppTextStyle.googleFont(
                            Colors.black,
                            40,
                            FontWeight.bold,
                          ),
                        ),
                        TouchableOpacity(
                          onTap: () {
                            setState(() {
                              isBottomSheetShow = false;
                            });
                            log("in pop ${isBottomSheetShow.toString()}");
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: "B44121".toColor(),
                            radius: 20,
                            child: Image.asset(
                              "assets/images/Xcross.png",
                              scale: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "กรอกข้อมูลร้านค้าเพิ่มเติม",
                      style: AppTextStyle.googleFont(
                        Colors.grey,
                        16,
                        FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    height: 2,
                    endIndent: 18,
                    indent: 18,
                    thickness: 1,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StatefulBuilder(
                    builder: (context, setState) => TouchableOpacity(
                      onTap: () async {
                        await optionToTakeImage();
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        // color: Colors.amber,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadowStyle.boxShadow1(),
                                ],
                              ),
                              child: resImageFile == null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 65,
                                      child: Image.asset(
                                        "assets/images/restaurant_image.png",
                                        scale: 0.8,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                          100,
                                        ),
                                      ),
                                      child: Image.file(
                                        resImageFile!,
                                        width: 129,
                                        height: 129,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "เลือกรูปภาพหน้าปกร้านค้า",
                              style: AppTextStyle.googleFont(
                                "FF602E".toColor(),
                                14,
                                FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: _btmFormKey,
                    child: StatefulBuilder(
                      builder: (context, setState) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ชื่อร้าน",
                              style: AppTextStyle.googleFont(
                                Colors.black,
                                16,
                                FontWeight.normal,
                              ),
                            ),
                            TextFormField(
                              controller: resName,
                              decoration: const InputDecoration(
                                hintText: "กรอกชื่อร้านของคุณ",
                                prefixIcon: Icon(
                                  Icons.storefront,
                                  color: Colors.black,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "โปรดกรอกชื่อร้านของคุณ";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "รายละเอียดร้านอาหาร",
                              style: AppTextStyle.googleFont(
                                Colors.black,
                                16,
                                FontWeight.normal,
                              ),
                            ),
                            TextFormField(
                              controller: resDescription,
                              decoration: const InputDecoration(
                                hintText: "กรอกรายละเอียดเกี่ยวกับร้านของคุณ",
                                prefixIcon: Icon(
                                  Icons.description,
                                  color: Colors.black,
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "โปรดกรอกรายละเอียดร้านของคุณ";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  StatefulBuilder(
                    builder: (context, setState) => Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 15),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.amber.shade900,
                          ),
                        ),
                        child: DropdownButton(
                          style: AppTextStyle.googleFont(
                            Colors.black,
                            16,
                            FontWeight.w500,
                          ),
                          iconSize: 32,
                          iconEnabledColor: Colors.black,
                          underline: Container(),
                          value: restaurantType,
                          items: restaurantTypes
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              restaurantType = value ?? "";
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_btmFormKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.amber,
                                ),
                              );
                            },
                          );
                          BlocProvider.of<CredentialCubit>(context).signUpVendor(
                            vendorEntity: VendorEntity(
                              username: username.text,
                              email: email.text,
                              password: password.text,
                              description: resDescription.text,
                              imageFile: imageFile,
                              resImageFile: resImageFile,
                              isActive: false,
                              onQueue: 0,
                              resName: resName.text,
                              totalPriceSell: 0,
                              type: selectingType,
                              restaurantType: restaurantType,
                            ),
                          );
                          Future.delayed(const Duration(seconds: 1)).then((value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.amber.shade900,
                        ),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                            horizontal: 100.0,
                          ),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              5.0,
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        "ยืนยันการลงทะเบียนร้านค้า",
                        style: GoogleFonts.ibmPlexSansThai(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget headerContent() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 90, left: 18),
      child: SizedBox(
        width: size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ยินดีต้อนรับ",
                  style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "ลงทะเบียนสำหรับบัญชีของคุณ",
                  style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 16,
                    color: "848699".toColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            StatefulBuilder(
              builder: (context, setState) => TouchableOpacity(
                onTap: () async {
                  await optionToTakeImage();
                  setState(() {});
                },
                child: imageFile != null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                100,
                              ),
                            ),
                            child: Image.file(
                              imageFile!,
                              width: 109,
                              height: 109,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "เลือกรูปโปรไฟล์",
                            style: AppTextStyle.googleFont(
                              "FF602E".toColor(),
                              12,
                              FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/image_picker.png",
                            scale: 1.5,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "เลือกรูปโปรไฟล์",
                            style: AppTextStyle.googleFont(
                              "FF602E".toColor(),
                              12,
                              FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future pickImageFromGallery() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null) {
        return null;
      } else {
        return File(file.path);
      }
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  Future pickImageFromCamera() async {
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.camera);
      if (file == null) {
        return null;
      } else {
        return File(file.path);
      }
    } on PlatformException catch (e) {
      log('Failed to pick image: $e');
    }
  }

  Future optionToTakeImage() {
    return showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      builder: (context) {
        return Wrap(
          alignment: WrapAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  title: Text(
                    "คลังรูปภาพ",
                    style: AppTextStyle.googleFont(
                      Colors.black,
                      18,
                      FontWeight.normal,
                    ),
                  ),
                  onTap: () async {
                    final File imageFromGallery = await pickImageFromGallery();

                    if (isBottomSheetShow) {
                      resImageFile = imageFromGallery;
                    } else {
                      imageFile = imageFromGallery;
                    }
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  leading: const Icon(
                    Icons.photo_library,
                    color: Colors.black,
                  ),
                ),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                  height: 1,
                  color: Colors.black,
                ),
                ListTile(
                  title: Text(
                    "กล้อง",
                    style: AppTextStyle.googleFont(
                      Colors.black,
                      18,
                      FontWeight.normal,
                    ),
                  ),
                  onTap: () async {
                    final File imageFromCamera = await pickImageFromCamera();

                    if (isBottomSheetShow) {
                      resImageFile = imageFromCamera;
                    } else {
                      imageFile = imageFromCamera;
                    }
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

class RichTextNavigatorText extends StatelessWidget {
  const RichTextNavigatorText({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      width: size.width,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "มีแอ็กเคานต์แล้วใช่มั้ย? ",
                style: GoogleFonts.ibmPlexSansThai(
                  fontSize: 16,
                  color: "130B71".toColor(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TouchableOpacity(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(context, PageConst.loginPage, (route) => false);
                },
                child: Text(
                  "เข้าสู่ระบบ",
                  style: GoogleFonts.ibmPlexSansThai(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
