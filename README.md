# grpc_alice

This package help to log GRPC request and response.


## Preview

![Preview](https://gitlab.com/ametory-open-source/grpc-alice/-/raw/main/preview.jpeg)

## Installing

1. Add dependencies to `pubspec.yaml`

   Get the latest version in the 'Installing' tab
   on [pub.dev](https://pub.dev/packages/grpc_alice/install)

    ```yaml
    dependencies:
        grpc_alice: <latest-version>
    ```

2. Run pub get.

   ```shell
   flutter pub get
   ```

3. Import package.

    ```dart
    import 'package:grpc_alice/grpc_alice.dart';
    ```

## Implementation

1. Wrap `MaterialApp` with `GrpcAlice` .

    ```dart
    GrpcAlice(
        child: MaterialApp(
            // Your initialization for material app.
        ),
    )
    ```

2. Shake your device.
