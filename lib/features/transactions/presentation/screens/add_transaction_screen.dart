import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../data/models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import '../../../cards/providers/card_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _type = 'expense';
  String? _category;
  String? _paymentMethod;
  String? _cardId;
  DateTime _selectedDate = DateTime.now();
  bool _isRecurring = false;
  DateTime? _recurringPaymentDate;
  String? _recurringFrequency;
  bool _recurringActive = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _type = _tabController.index == 0 ? 'expense' : 'income';
        _category = null; // Reset category when switching tabs
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, {bool isRecurring = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isRecurring ? (_recurringPaymentDate ?? DateTime.now()) : _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isRecurring) {
          _recurringPaymentDate = picked;
        } else {
          _selectedDate = picked;
        }
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_isRecurring && (_recurringPaymentDate == null || _recurringFrequency == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos de recurrencia'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final transaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _type,
      amount: double.parse(_amountController.text),
      description: _descriptionController.text,
      category: _category!,
      paymentMethod: _paymentMethod!,
      cardId: _cardId,
      date: _selectedDate,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      isRecurring: _isRecurring,
      recurringPaymentDate: _recurringPaymentDate?.toIso8601String(),
      recurringFrequency: _recurringFrequency,
      recurringActive: _recurringActive,
      createdAt: DateTime.now(),
    );

    final provider = Provider.of<TransactionProvider>(context, listen: false);
    final success = await provider.addTransaction(transaction);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_type == "expense" ? "Gasto" : "Ingreso"} registrado exitosamente'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al guardar la transacción'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Nueva Transacción',
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Type Tabs
              Container(
                decoration: BoxDecoration(
                  color: AppColors.mutedLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.mutedForegroundLight,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.trending_down),
                      text: 'Gasto',
                    ),
                    Tab(
                      icon: Icon(Icons.trending_up),
                      text: 'Ingreso',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Amount Field
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monto *',
                  prefixText: '\$ ',
                  hintText: '0.00',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el monto';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Ingresa un monto válido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción *',
                  hintText: _type == 'expense' ? 'Ej: Supermercado del mes' : 'Ej: Pago de salario',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa una descripción';
                  }
                  if (value.length < 3) {
                    return 'La descripción debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Categoría *',
                ),
                items: (_type == 'expense' ? AppConstants.expenseCategories : AppConstants.incomeCategories)
                    .map((cat) => DropdownMenuItem(
                          value: cat['value'],
                          child: Text(cat['label']!),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecciona una categoría';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Payment Method Dropdown
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Método de Pago *',
                ),
                items: AppConstants.paymentMethods
                    .map((method) => DropdownMenuItem(
                          value: method['value'],
                          child: Text(method['label']!),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value;
                    _cardId = null; // Reset card selection
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecciona un método de pago';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Card Selection (if credit or debit)
              if (_paymentMethod == 'credito' || _paymentMethod == 'debito')
                Consumer<CardProvider>(
                  builder: (context, cardProvider, child) {
                    final cards = _paymentMethod == 'credito'
                        ? cardProvider.creditCards
                        : cardProvider.debitCards;

                    return DropdownButtonFormField<String>(
                      value: _cardId,
                      decoration: const InputDecoration(
                        labelText: 'Seleccionar Tarjeta *',
                      ),
                      items: cards.isEmpty
                          ? [
                              DropdownMenuItem(
                                value: null,
                                child: Text('No hay tarjetas de ${_paymentMethod == "credito" ? "crédito" : "débito"}'),
                              ),
                            ]
                          : cards
                              .map((card) => DropdownMenuItem(
                                    value: card.id,
                                    child: Text('${card.bankName} - ${card.formattedCardNumber}'),
                                  ))
                              .toList(),
                      onChanged: cards.isEmpty
                          ? null
                          : (value) {
                              setState(() {
                                _cardId = value;
                              });
                            },
                      validator: (value) {
                        if ((_paymentMethod == 'credito' || _paymentMethod == 'debito') && value == null) {
                          return 'Selecciona una tarjeta';
                        }
                        return null;
                      },
                    );
                  },
                ),

              if (_paymentMethod == 'credito' || _paymentMethod == 'debito')
                const SizedBox(height: 16),

              // Date Picker
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha *',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Recurring Transaction Switch
              Card(
                child: SwitchListTile(
                  title: const Row(
                    children: [
                      Icon(Icons.repeat, size: 20),
                      SizedBox(width: 8),
                      Text('Transacción Recurrente'),
                    ],
                  ),
                  subtitle: const Text('Programa pagos o ingresos automáticos'),
                  value: _isRecurring,
                  onChanged: (value) {
                    setState(() {
                      _isRecurring = value;
                    });
                  },
                ),
              ),

              // Recurring Fields
              if (_isRecurring) ...[
                const SizedBox(height: 16),
                Card(
                  color: AppColors.mutedLight,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.repeat, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Configuración de Recurrencia',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () => _selectDate(context, isRecurring: true),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Fecha de Pago *',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            child: Text(
                              _recurringPaymentDate != null
                                  ? '${_recurringPaymentDate!.day}/${_recurringPaymentDate!.month}/${_recurringPaymentDate!.year}'
                                  : 'Seleccionar fecha',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _recurringFrequency,
                          decoration: const InputDecoration(
                            labelText: 'Frecuencia *',
                          ),
                          items: AppConstants.frequencies
                              .map((freq) => DropdownMenuItem(
                                    value: freq['value'],
                                    child: Text(freq['label']!),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _recurringFrequency = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Estado Activo'),
                          subtitle: const Text('La transacción se procesará automáticamente'),
                          value: _recurringActive,
                          onChanged: (value) {
                            setState(() {
                              _recurringActive = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // Notes Field
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notas (opcional)',
                  hintText: 'Agrega notas adicionales...',
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              Consumer<TransactionProvider>(
                builder: (context, provider, child) {
                  return CustomButton(
                    text: 'Guardar',
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