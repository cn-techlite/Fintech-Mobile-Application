import 'package:fintech_mobile_application/models/savings_product.dart';
import 'package:fintech_mobile_application/providers/navigation_provider.dart';
import 'package:fintech_mobile_application/providers/savings_provider.dart';
import 'package:fintech_mobile_application/repositories/savings_repository.dart';
import 'package:fintech_mobile_application/utils/currency_input_formatter.dart';
import 'package:fintech_mobile_application/utils/size_config.dart';
import 'package:fintech_mobile_application/utils/validators.dart';
import 'package:fintech_mobile_application/widgets/app_buttons.dart';
import 'package:fintech_mobile_application/widgets/app_snackbar.dart';
import 'package:fintech_mobile_application/widgets/app_text.dart';
import 'package:fintech_mobile_application/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateSavingsScreen extends ConsumerStatefulWidget {
  const CreateSavingsScreen({super.key, this.initialProduct});

  final SavingsProduct? initialProduct;

  @override
  ConsumerState<CreateSavingsScreen> createState() =>
      _CreateSavingsScreenState();
}

class _CreateSavingsScreenState extends ConsumerState<CreateSavingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();
  final _contributionController = TextEditingController();
  String? _productType;
  int? _durationMonths;

  @override
  void initState() {
    super.initState();
    _productType = widget.initialProduct?.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _contributionController.dispose();
    super.dispose();
  }

  Future<void> _createPlan() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final target = double.parse(_targetController.text.replaceAll(',', ''));
    final contribution = double.parse(
      _contributionController.text.replaceAll(',', ''),
    );
    if (contribution > target) {
      AppSnackBar.showError(
        context,
        'Monthly contribution cannot exceed target amount.',
      );
      return;
    }

    final created = await ref
        .read(savingsControllerProvider.notifier)
        .createPlan(
          name: _nameController.text,
          productType: _productType!,
          targetAmount: target,
          monthlyContribution: contribution,
          durationMonths: _durationMonths!,
        );
    if (!mounted) return;

    if (created) {
      ref.read(navigationIndexProvider.notifier).select(0);
      AppSnackBar.showSuccess(context, 'Savings Created Successfully');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      final message = ref.read(savingsControllerProvider).errorMessage;
      AppSnackBar.showError(context, message ?? 'Unable to create savings.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(savingsControllerProvider).isSaving;

    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: 'Create Savings',
          type: AppTextType.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(SizeConfig.pagePadding),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: SizeConfig.contentMaxWidth(
                  SizeConfig.formContentMaxWidth,
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AppText(
                      text: 'Start a new savings plan',
                      type: AppTextType.headlineSmall,
                      fontWeight: FontWeight.w900,
                    ),
                    SizedBox(height: 6.responsiveSize),
                    AppText(
                      text: 'Set a clear goal and contribution schedule.',
                      type: AppTextType.bodyMedium,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: 24.responsiveSize),
                    AppTextField(
                      controller: _nameController,
                      label: 'Savings Name',
                      hint: 'e.g. New car',
                      prefixIcon: Icons.edit_outlined,
                      textInputAction: TextInputAction.next,
                      validator: (value) => Validators.requiredField(
                        value,
                        label: 'Savings name',
                      ),
                    ),
                    SizedBox(height: 16.responsiveSize),
                    DropdownButtonFormField<String>(
                      initialValue: _productType,
                      decoration: const InputDecoration(
                        label: AppText(
                          text: 'Product Type',
                          type: AppTextType.bodyMedium,
                        ),
                        prefixIcon: Icon(Icons.savings_outlined),
                      ),
                      items: SavingsRepository.products
                          .map(
                            (product) => DropdownMenuItem(
                              value: product.name,
                              child: AppText(
                                text: product.name,
                                type: AppTextType.bodyMedium,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => _productType = value,
                      validator: (value) =>
                          value == null ? 'Product type is required.' : null,
                    ),
                    SizedBox(height: 16.responsiveSize),
                    AppTextField(
                      controller: _targetController,
                      label: 'Target Amount',
                      hint: '500,000',
                      prefixIcon: Icons.flag_outlined,
                      inputFormatters: const [CurrencyInputFormatter()],
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) => Validators.positiveAmount(
                        value,
                        label: 'Target amount',
                      ),
                    ),
                    SizedBox(height: 16.responsiveSize),
                    AppTextField(
                      controller: _contributionController,
                      label: 'Monthly Contribution',
                      hint: '50,000',
                      prefixIcon: Icons.payments_outlined,
                      inputFormatters: const [CurrencyInputFormatter()],
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) => Validators.positiveAmount(
                        value,
                        label: 'Monthly contribution',
                      ),
                    ),
                    SizedBox(height: 16.responsiveSize),
                    DropdownButtonFormField<int>(
                      initialValue: _durationMonths,
                      decoration: const InputDecoration(
                        label: AppText(
                          text: 'Duration',
                          type: AppTextType.bodyMedium,
                        ),
                        prefixIcon: Icon(Icons.calendar_month_outlined),
                      ),
                      items: const [3, 6, 12, 18, 24]
                          .map(
                            (months) => DropdownMenuItem(
                              value: months,
                              child: AppText(
                                text: '$months Months',
                                type: AppTextType.bodyMedium,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => _durationMonths = value,
                      validator: (value) =>
                          value == null ? 'Duration is required.' : null,
                    ),
                    SizedBox(height: 28.responsiveSize),
                    AppButton(
                      text: 'Create',
                      onPressed: _createPlan,
                      isLoading: isSaving,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
