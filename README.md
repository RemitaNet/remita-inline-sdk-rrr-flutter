# Remitta Flutter Inline Payment

A Remitta package that helps you accept payment in your flutter application.

![](assets/inline_screenshot.png)



## Requirements

1. Remitta [API Keys](https://api.remita.net/#63394d54-96c1-4dd8-8255-51e9a55e16df)
2. Supported Flutter version >= 1.17.0


## Installation

1. Add the dependency to your project. In your `pubspec.yaml` file add: `remitta_flutter_inline: 1.0.0`
2. Run `flutter pub get`


## Usage

### Initializing a RemittaPayment instance

To create an instance, you should call the RemittaInlinePayment constructor with the following as parameters:

-  `BuildContext`
-  `PaymentRequest`
-  `Customizer`


It returns an instance of RemittaInlinePayment 
with this instance, we then call the async method `.initiatePayment()`.

    _handlePayment() async { 

        PaymentRequest request = PaymentRequest(
            environment: RemittaEnvironment.demo,
            rrr: 'pass your rrr here',
            key: 'enter your key here',
        );

        RemittaPayment remitta = RemittaInlinePayment(
            buildContext: context,
            paymentRequest: request,
            customizer: Customizer(),
        );

        PaymentResponse response = await remitta.initiatePayment();
  
    }


### Handling the response

Calling `.initiatePayment()` method returns a Future of `PaymentResponse`.



    PaymentResponse response = await remitta.initiatePayment();
    if (response.code != null && response.code == '00') {
      // transaction successful
      // verify transaction status before providing value
    } else {
      
    }


###  TEST CARDS


```json
    CARD: 5178 6810 0000 0002,  
    Expire Date : 05/30,  
    CCV: 000, 
    OTP: 123456
```



## License

By contributing to the Flutter library, you agree that your contributions will be licensed under its [MIT license](/LICENSE).




## Built Using

- [flutter](https://flutter.dev/)
- [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview)
