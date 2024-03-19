import 'package:firebase_2/api/networkstatus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/signupprovider.dart';

class CredentialDetails extends StatefulWidget {
  const CredentialDetails({super.key});

  @override
  State<CredentialDetails> createState() => _CredentialDetailsState();
}

class _CredentialDetailsState extends State<CredentialDetails> {
  @override
  void initState() {
    getValue();
    super.initState();
  }

  getValue() async {
    var provider = Provider.of<SignUpProvider>(context, listen: false);
    await provider.getCredentialDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<SignUpProvider>(
            builder: (context, signupProvider, child) => signupProvider
                        .credentialDataStatus ==
                    NetworkStatus.success
                ? Column(
                    children: [
                      signupProvider.credentialList.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                  itemCount:
                                      signupProvider.credentialList.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: Column(
                                        children: [
                                          Text(
                                              "${signupProvider.credentialList[index].id}"),
                                          Text(
                                              "${signupProvider.credentialList[index].email}")
                                        ],
                                      ),
                                    );
                                  }),
                            )
                          : Text("No Data Available!")
                    ],
                  )
                : signupProvider.credentialDataStatus == NetworkStatus.loading
                    ? Center(child: CircularProgressIndicator())
                    : Text("Error!!")),
      ),
    );
  }
}
