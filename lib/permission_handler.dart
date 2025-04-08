import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'file_handler.dart';

class PermissionHandler {
  static Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      // print("Already granted.");
      return true;
    }

    final PermissionStatus status = await permission.request();

    // if (status.isGranted) {
    //   print("Permission Granted!");
    //   return true;
    // } else if (status.isDenied) {
    //   print("Permission Denied!");
    //   return false;
    // } else if (status.isPermanentlyDenied) {
    //   print("Permission Permanently Denied. Open settings.");
    //   openAppSettings();
    // }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    if ((!status.isPermanentlyDenied) && (!status.isDenied)) {
      return true;
    }

    return false;
  }

  static Future<List<Permission>> getUnsatisfiedPermissions(
    List<Permission> permissions,
  ) async {
    final List<Permission> unsatisfiedPermissions = [];

    for (int i = 0; i < permissions.length; i++) {
      final bool isDenied = await permissions[i].isDenied;
      if (isDenied) {
        unsatisfiedPermissions.add(permissions[i]);
      }
      if (permissions[i] == Permission.manageExternalStorage && !isDenied) {
        StorageHandler.isExternal = true;
      }
    }

    return unsatisfiedPermissions;
  }

  static Future<void> ensurePermissions(
    List<Permission> permissions,
    BuildContext context,
  ) async {
    final List<Permission> unsatisfiedPermissions =
        await getUnsatisfiedPermissions(permissions);

    if (context.mounted && unsatisfiedPermissions.isNotEmpty) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PermissionWall(
            permissions: unsatisfiedPermissions,
          ),
        ),
      );
    }
  }
}

class PermissionWall extends StatelessWidget {
  const PermissionWall({
    required this.permissions,
    super.key,
  });

  final List<Permission> permissions;

  Future<void> requestPermissions(BuildContext context) async {
    for (final permission in permissions) {
      // bool granted = true;

      // do {
      //   granted = await requestPermission(permission);
      // } while (!granted);
      await PermissionHandler.requestPermission(permission);
    }

    if ((await PermissionHandler.getUnsatisfiedPermissions(permissions))
        .isEmpty) {
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Permissions Screen")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'The following permissions are required for assuring the app\'s functionality:\n'),
              for (Permission permission in permissions)
                Text(permission.toString()),
              ElevatedButton(
                onPressed: () => requestPermissions(context),
                child: Text("Request Permissions"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
