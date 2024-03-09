

import 'dart:ui';

import 'package:ente_auth/core/configuration.dart';
import 'package:ente_auth/ui/account/password_entry_page.dart';
import 'package:ente_auth/ui/common/dynamic_fab.dart';
import 'package:ente_auth/utils/dialog_util.dart';
import 'package:ente_auth/utils/toast_util.dart';
import 'package:flutter/material.dart';

class RecoveryPage extends StatefulWidget {
  const RecoveryPage({Key? key}) : super(key: key);

  @override
  State<RecoveryPage> createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  final _recoveryKey = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isKeypadOpen = MediaQuery.of(context).viewInsets.bottom > 100;
    FloatingActionButtonLocation? fabLocation() {
      if (isKeypadOpen) {
        return null;
      } else {
        return FloatingActionButtonLocation.centerFloat;
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: isKeypadOpen,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).iconTheme.color,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButton: DynamicFAB(
        isKeypadOpen: isKeypadOpen,
        isFormValid: _recoveryKey.text.isNotEmpty,
        buttonText: 'Recover',
        onPressedFunction: () async {
          FocusScope.of(context).unfocus();
          final dialog = createProgressDialog(context, "Decrypting...");
          await dialog.show();
          try {
            await Configuration.instance.recover(_recoveryKey.text.trim());
            await dialog.hide();
            showToast(context, "Recovery successful!");
            // ignore: unawaited_futures
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: const PasswordEntryPage(
                      mode: PasswordEntryMode.reset,
                    ),
                  );
                },
              ),
            );
          } catch (e) {
            await dialog.hide();
            String errMessage = 'The recovery key you entered is incorrect';
            if (e is AssertionError) {
              errMessage = '$errMessage : ${e.message}';
            }
            // ignore: unawaited_futures
            showErrorDialog(context, "Incorrect recovery key", errMessage);
          }
        },
      ),
      floatingActionButtonLocation: fabLocation(),
      floatingActionButtonAnimator: NoScalingAnimation(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Text(
                    'Forgot password',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Enter your recovery key",
                      contentPadding: const EdgeInsets.all(20),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                    controller: _recoveryKey,
                    autofocus: false,
                    autocorrect: false,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        showErrorDialog(
                          context,
                          "Sorry",
                          "Due to the nature of our end-to-end encryption protocol, your data cannot be decrypted without your password or recovery key",
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Text(
                            "No recovery key?",
                            style:
                                Theme.of(context).textTheme.titleMedium!.copyWith(
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
