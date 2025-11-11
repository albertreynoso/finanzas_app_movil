import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/models/card_model.dart';
import '../../providers/card_provider.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _cardNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _billingDateController = TextEditingController();
  final _paymentDueDateController = TextEditingController();
  final _creditLimitController = TextEditingController();
  final _currentBalanceController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _cardType = 'credito';

  @override
  void dispose() {
    _cardNumberController.dispose();
    _bankNameController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _billingDateController.dispose();
    _paymentDueDateController.dispose();
    _creditLimitController.dispose();
    _currentBalanceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final card = CardModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cardNumber: _cardNumberController.text.replaceAll(' ', ''),
      bankName: _bankNameController.text,
      cardType: _cardType,
      billingDate: int.parse(_billingDateController.text),
      paymentDueDate: int.parse(_paymentDueDateController.text),
      creditLimit: _creditLimitController.text.isEmpty ? null : double.parse(_creditLimitController.text),
      currentBalance: _currentBalanceController.text.isEmpty ? 0 : double.parse(_currentBalanceController.text),
      cardHolder: _cardHolderController.text,
      expiryDate: _expiryDateController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      createdAt: DateTime.now(),
    );

    final provider = Provider.of<CardProvider>(context, listen: false);
    final success = await provider.addCard(card);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tarjeta registrada exitosamente'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al guardar la tarjeta'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Agregar Tarjeta',
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card Type
              DropdownButtonFormField<String>(
                value: _cardType,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Tarjeta *',
                ),
                items: const [
                  DropdownMenuItem(value: 'credito', child: Text('💳 Tarjeta de Crédito')),
                  DropdownMenuItem(value: 'debito', child: Text('💳 Tarjeta de Débito')),
                ],
                onChanged: (value) {
                  setState(() {
                    _cardType = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              // Bank Name
              TextFormField(
                controller: _bankNameController,
                decoration: const InputDecoration(
                  labelText: 'Banco / Entidad *',
                  prefixIcon: Icon(Icons.account_balance),
                  hintText: 'Ej: Banco Nacional, BBVA',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el nombre del banco';
                  }
                  if (value.length < 2) {
                    return 'El nombre debe tener al menos 2 caracteres';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Card Number
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de Tarjeta *',
                  prefixIcon: Icon(Icons.credit_card),
                  hintText: '1234 5678 9012 3456',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el número de tarjeta';
                  }
                  final cleaned = value.replaceAll(' ', '');
                  if (cleaned.length < 13 || cleaned.length > 16) {
                    return 'El número debe tener entre 13 y 16 dígitos';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
                    return 'Solo se permiten números';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Card Holder
              TextFormField(
                controller: _cardHolderController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Titular de la Tarjeta *',
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Nombre como aparece en la tarjeta',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el nombre del titular';
                  }
                  if (value.length < 3) {
                    return 'El nombre debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Expiry Date
              TextFormField(
                controller: _expiryDateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Fecha de Expiración *',
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: 'MM/YY',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la fecha de expiración';
                  }
                  if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                    return 'Formato: MM/YY';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Billing and Payment Dates (only for credit cards)
              if (_cardType == 'credito') ...[
                Text(
                  'Fechas de Facturación',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _billingDateController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Día de Facturación *',
                          hintText: 'Ej: 15',
                          helperText: 'Día del mes',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Requerido';
                          }
                          final day = int.tryParse(value);
                          if (day == null || day < 1 || day > 31) {
                            return 'Día inválido';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _paymentDueDateController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Día de Pago Límite *',
                          hintText: 'Ej: 25',
                          helperText: 'Día del mes',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Requerido';
                          }
                          final day = int.tryParse(value);
                          if (day == null || day < 1 || day > 31) {
                            return 'Día inválido';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Información de Crédito',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _creditLimitController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Línea de Crédito',
                          prefixText: '\$ ',
                          hintText: '0.00',
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final amount = double.tryParse(value);
                            if (amount == null) {
                              return 'Ingresa un valor válido';
                            }
                            if (amount < 0) {
                              return 'El valor no puede ser negativo';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _currentBalanceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Saldo Actual',
                          prefixText: '\$ ',
                          hintText: '0.00',
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final amount = double.tryParse(value);
                            if (amount == null) {
                              return 'Ingresa un valor válido';
                            }
                            if (amount < 0) {
                              return 'El valor no puede ser negativo';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Notes
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notas (opcional)',
                  hintText: 'Beneficios, recompensas, recordatorios...',
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              Consumer<CardProvider>(
                builder: (context, provider, child) {
                  return CustomButton(
                    text: 'Guardar Tarjeta',
                    onPressed: _handleSubmit,
                    isLoading: provider.isLoading,
                  );
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}