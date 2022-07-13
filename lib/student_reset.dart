import 'package:flutter/material.dart';

import 'firebase/signIn.dart';
import 'firebase/wrapper.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final fkey = GlobalKey<FormState>();

  TextEditingController emailcontrol = TextEditingController();

  final Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: fkey,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 40,right: 40,top: 200,bottom: 30),
              child: TextFormField(
                controller: emailcontrol,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                validator: (email){
                  if(email == null || email.isEmpty){
                    return 'Enter Email';
                  }
                },
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    foregroundColor: MaterialStateColor.resolveWith((states) => Colors.black),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),),
                  child: const Text('Reset',style: TextStyle(fontSize: 17),),
                  onPressed: () async {
                    if(fkey.currentState!.validate())
                    {
                      if(await auth.resetPassword(emailcontrol.text))
                      {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reset Link has been sent to your email address(${emailcontrol.text})'),));
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>  const Wrapper()));
                      }
                      else
                      {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incorrect Email Address'),));
                      }
                    }
                    else
                    {
                      setState(() {});
                    }
                  },
                )
            )
          ],
        ),
      ),
    );
  }
}
