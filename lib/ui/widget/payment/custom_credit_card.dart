import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hafar_market_app/ui/widget/widgets.dart';
import 'package:moyasar/moyasar.dart';
import 'package:moyasar/src/utils/card_utils.dart';
import 'package:moyasar/src/utils/input_formatters.dart';
import 'package:moyasar/src/widgets/network_icons.dart';
import 'package:moyasar/src/widgets/three_d_s_webview.dart';

/// The widget that shows the Credit Card form and manages the 3DS step.
class CustomCreditCard extends StatefulWidget {
  CustomCreditCard(
      {super.key,
      required this.config,
      required this.onPaymentResult,
      this.locale = const Localization.en()})
      : textDirection =
            locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;

  final Function onPaymentResult;
  final PaymentConfig config;
  final Localization locale;
  final TextDirection textDirection;

  @override
  State<CustomCreditCard> createState() => _CustomCreditCardState();
}

class _CustomCreditCardState extends State<CustomCreditCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _cardData = CardFormModel();

  AutovalidateMode _autoValidateMode = AutovalidateMode.onUserInteraction;

  bool _isSubmitting = false;
  bool _tokenizeCard = false;
  bool _manualPayment = false;

  // Error state for each field
  String? _nameError;
  String? _cardNumberError;
  String? _expiryError;
  String? _cvcError;

  // Track if fields have been filled
  bool _nameFieldFilled = false;
  bool _cardNumberFieldFilled = false;
  bool _expiryFieldFilled = false;
  bool _cvcFieldFilled = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _tokenizeCard = widget.config.creditCard?.saveCard ?? false;
      _manualPayment = widget.config.creditCard?.manual ?? false;
    });
  }

  // Check if button should be enabled
  bool get _isButtonEnabled {
    // Check if all fields are filled and there are no errors
    bool allFieldsFilled = _nameFieldFilled &&
        _cardNumberFieldFilled &&
        _expiryFieldFilled &&
        _cvcFieldFilled;

    bool noErrors = _nameError == null &&
        _cardNumberError == null &&
        _expiryError == null &&
        _cvcError == null;

    return allFieldsFilled && noErrors && !_isSubmitting;
  }

  void _saveForm() async {
    if (!_isButtonEnabled) return;

    closeKeyboard();

    bool isValidForm =
        _formKey.currentState != null && _formKey.currentState!.validate();

    if (!isValidForm) {
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
      return;
    }

    _formKey.currentState?.save();

    final source = CardPaymentRequestSource(
        creditCardData: _cardData,
        tokenizeCard: _tokenizeCard,
        manualPayment: _manualPayment);
    final paymentRequest = PaymentRequest(widget.config, source);

    setState(() => _isSubmitting = true);

    final result = await Moyasar.pay(
        apiKey: widget.config.publishableApiKey,
        paymentRequest: paymentRequest);

    setState(() => _isSubmitting = false);

    if (result is! PaymentResponse ||
        result.status != PaymentStatus.initiated) {
      widget.onPaymentResult(result);
      return;
    }

    final String transactionUrl =
        (result.source as CardPaymentResponseSource).transactionUrl;

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true,
            maintainState: false,
            builder: (context) => ThreeDSWebView(
                transactionUrl: transactionUrl,
                on3dsDone: (String status, String message) async {
                  if (status == PaymentStatus.paid.name) {
                    result.status = PaymentStatus.paid;
                  } else if (status == PaymentStatus.authorized.name) {
                    result.status = PaymentStatus.authorized;
                  } else {
                    result.status = PaymentStatus.failed;
                    (result.source as CardPaymentResponseSource).message =
                        message;
                  }
                  Navigator.pop(context);
                  widget.onPaymentResult(result);
                })),
      );
    }
  }

  // Validate name on change
  void _validateName(String? value) {
    setState(() {
      _nameError = CardUtils.validateName(value, widget.locale);
      _nameFieldFilled = value != null && value.trim().isNotEmpty;
    });
  }

  // Validate card number on change
  void _validateCardNumber(String? value) {
    setState(() {
      _cardNumberError = CardUtils.validateCardNum(value, widget.locale);
      _cardNumberFieldFilled =
          value != null && value.replaceAll(' ', '').length >= 13;
    });
  }

  // Validate expiry date on change
  void _validateExpiry(String? value) {
    setState(() {
      final cleanValue = value?.replaceAll('\u200E', '') ?? '';
      _expiryError = CardUtils.validateDate(cleanValue, widget.locale);
      _expiryFieldFilled = cleanValue.length >= 5; // MM/YY format
    });
  }

  // Validate CVC on change
  void _validateCVC(String? value) {
    setState(() {
      _cvcError = CardUtils.validateCVC(value, widget.locale);
      _cvcFieldFilled = value != null && value.length >= 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: _autoValidateMode,
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_nameError ?? widget.locale.nameOnCard,
              style: TextStyle(
                fontSize: 16,
                color: _nameError != null ? Colors.red : null,
              )),
          SizedBox(
            height: 5,
          ),
          CardFormField(
            inputDecoration: buildInputDecoration(
                hintText: widget.locale.nameOnCard,
                hideBorder: true,
                hintTextDirection: widget.textDirection),
            keyboardType: TextInputType.text,
            onChanged: _validateName,
            onSaved: (value) => _cardData.name = value ?? '',
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z. ]')),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Text(
              _cardNumberError ??
                  _expiryError ??
                  _cvcError ??
                  widget.locale.cardInformation,
              style: TextStyle(
                fontSize: 16,
                color: (_cardNumberError != null ||
                        _expiryError != null ||
                        _cvcError != null)
                    ? Colors.red
                    : null,
              )),
          SizedBox(
            height: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardFormField(
                inputDecoration: buildInputDecoration(
                    hintText: widget.locale.cardNumber,
                    hintTextDirection: widget.textDirection,
                    hideBorder: true,
                    addNetworkIcons: true),
                onChanged: _validateCardNumber,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CardNumberInputFormatter(),
                ],
                onSaved: (value) =>
                    _cardData.number = CardUtils.getCleanedNumber(value!),
              ),
              gap(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CardFormField(
                          inputDecoration: buildInputDecoration(
                            hintText: '${widget.locale.expiry} (MM / YY)',
                            hintTextDirection: widget.textDirection,
                            hideBorder: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            CardMonthInputFormatter(),
                          ],
                          onChanged: _validateExpiry,
                          onSaved: (value) {
                            List<String> expireDate = CardUtils.getExpiryDate(
                                value!.replaceAll('\u200E', ''));
                            _cardData.month =
                                expireDate.first.replaceAll('\u200E', '');
                            _cardData.year =
                                expireDate[1].replaceAll('\u200E', '');
                          },
                        ),
                      ],
                    ),
                  ),
                  gap(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CardFormField(
                          inputDecoration: buildInputDecoration(
                            hintText: widget.locale.cvc,
                            hintTextDirection: widget.textDirection,
                            hideBorder: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          onChanged: _validateCVC,
                          onSaved: (value) => _cardData.cvc = value ?? '',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 55,
            width: double.infinity,
            child: FilledButton(
              onPressed: _isButtonEnabled ? _saveForm : null,
              child: _isSubmitting
                  ? const CircularProgressIndicator()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Text(
                          '${widget.locale.pay} ',
                          textDirection: widget.textDirection,
                        ),
                        Text(
                          getAmount(widget.config.amount),
                          textDirection: widget.textDirection,
                        ),
                        const SizedBox(width: 4),
                        SizedBox(
                            width: 16,
                            child: Image.asset(
                              'assets/images/saudiriyal.png',
                              color: Colors.white, // Tint color
                              package: 'moyasar',
                            )),
                        Spacer(),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardFormField extends StatelessWidget {
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final InputDecoration? inputDecoration;

  const CardFormField(
      {super.key,
      required this.onSaved,
      this.validator,
      this.onChanged,
      this.inputDecoration,
      this.keyboardType = TextInputType.number,
      this.textInputAction = TextInputAction.next,
      this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        decoration: inputDecoration,
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
        inputFormatters: inputFormatters);
  }
}

String showAmount(int amount, String currency, Localization locale) {
  final formattedAmount = (amount / 100).toStringAsFixed(2);
  return '${locale.pay} $currency $formattedAmount';
}

String getAmount(int amount) {
  final formattedAmount = (amount / 100).toStringAsFixed(2);
  return formattedAmount;
}

InputDecoration buildInputDecoration(
    {required String hintText,
    required TextDirection hintTextDirection,
    bool addNetworkIcons = false,
    bool hideBorder = false}) {
  return InputDecoration(
      suffixIcon: addNetworkIcons ? const NetworkIcons() : null,
      hintText: hintText,
      hintTextDirection: hintTextDirection,
      contentPadding: const EdgeInsets.all(8.0));
}

void closeKeyboard() => FocusManager.instance.primaryFocus?.unfocus();