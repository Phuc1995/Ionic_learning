import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:user_management/presentation/widgets/textfield_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnvironmentPage extends StatefulWidget {
  @override
  _EnvironmentPage createState() => _EnvironmentPage();
}

class _EnvironmentPage extends State<EnvironmentPage> {

  late Future<void> _initializeControllerFuture;
  // shared pref object
  late SharedPreferenceHelper _sharedPrefsHelper;

  bool _loading = false;

  TextEditingController _apiSeverController = TextEditingController();
  TextEditingController _storageServerController = TextEditingController();
  TextEditingController _bucketNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = Future.wait([asyncInit()]);
  }

  Future<void> asyncInit() async {
    _sharedPrefsHelper = await SharedPreferenceHelper.getInstance();
    _apiSeverController.text = _sharedPrefsHelper.gatewayServer;
    _storageServerController.text = _sharedPrefsHelper.storageServer;
    _bucketNameController.text = _sharedPrefsHelper.bucketName;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        brightness: Brightness.light,
        title: Text(
          ('Environment: ' + dotenv.env['ENV_NAME']!),
          style: TextStyle(color: Colors.black),),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Save',
                style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.pink[500],
                    fontWeight: FontWeight.bold
                )
            ),
            onPressed: () {
              _sharedPrefsHelper.setGatewayServer(_apiSeverController.text.trim());
              _sharedPrefsHelper.setStorageServer(_storageServerController.text.trim());
              _sharedPrefsHelper.setBucketName(_bucketNameController.text.trim());
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _buildBody();
            }  else {
              // Otherwise, display a loading indicator.
              return const Center(child: CircularProgressIndicator());
            }
          }
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
        children: <Widget>[
          SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 16.h),
                      _buildGatewayServer(),
                      _buildStorageServer(),
                      SizedBox(height: 16.h),
                    ],
                  ),
                )
              ),
          ),
          Visibility(
            visible: _loading,
            child: CustomProgressIndicatorWidget(),
          ),
        ]
    );
  }

  Widget _buildGatewayServer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16.h),
        Text('Gateway Server:'),
        TextFieldWidget(
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
          maxLength: 255,
          hint: 'Server url: http://192.168.1.87:8080',
          padding: EdgeInsets.only(top: 8.0.h),
          textController: _apiSeverController,
        )
      ],
    );
  }

  Widget _buildStorageServer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16.h),
        Text('Storage Server:'),
        TextFieldWidget(
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
          maxLength: 255,
          hint: 'Server url: http://192.168.1.87:9000',
          padding: EdgeInsets.only(top: 8.0.h),
          textController: _storageServerController,
        )
      ],
    );
  }

}
