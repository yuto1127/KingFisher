import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../layouts/main_layout.dart';
import '../services/users_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class AdminUserEditPage extends StatefulWidget {
  final int userId;
  const AdminUserEditPage({super.key, required this.userId});

  @override
  State<AdminUserEditPage> createState() => _AdminUserEditPageState();
}

class _AdminUserEditPageState extends State<AdminUserEditPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _user;
  bool _isLoadingAddress = false;

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _prefectureController = TextEditingController();
  final _cityController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  String? _gender;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _postalCodeController.dispose();
    _prefectureController.dispose();
    _cityController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    try {
      final user = await UsersApi.getUser(widget.userId);
      if (user != null) {
        setState(() {
          _user = user;
          _nameController.text = user['name'] ?? '';
          _phoneController.text = user['phone_number'] ?? '';
          _postalCodeController.text =
              (user['postal_code'] ?? '').replaceAll('-', '');
          _prefectureController.text = user['prefecture'] ?? '';
          _cityController.text = user['city'] ?? '';
          _address1Controller.text = user['address_line1'] ?? '';
          _address2Controller.text = user['address_line2'] ?? '';
          _gender = user['gender'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'ユーザーデータの取得に失敗しました。';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'エラーが発生しました: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchAddressFromPostalCode(String postalCode) async {
    if (postalCode.length != 7) return;

    setState(() {
      _isLoadingAddress = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://zipcloud.ibsnet.co.jp/api/search?zipcode=$postalCode'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 200 &&
            data['results'] != null &&
            data['results'].isNotEmpty) {
          final result = data['results'][0];
          setState(() {
            _prefectureController.text = result['address1'] ?? '';
            _cityController.text = result['address2'] ?? '';
          });
        }
      }
    } catch (e) {
      print('住所検索エラー: $e');
    } finally {
      setState(() {
        _isLoadingAddress = false;
      });
    }
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final updatedData = {
        'name': _nameController.text,
        'gender': _gender,
        'phone_number': _phoneController.text,
        'postal_code': _postalCodeController.text,
        'prefecture': _prefectureController.text,
        'city': _cityController.text,
        'address_line1': _address1Controller.text,
        'address_line2': _address2Controller.text,
      };

      try {
        await UsersApi.updateUser(widget.userId, updatedData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('ユーザー情報が更新されました'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      } catch (e) {
        setState(() {
          _errorMessage = '更新に失敗しました: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_user != null ? 'ID: ${widget.userId} 編集' : 'ユーザー編集'),
          backgroundColor: const Color(0xFF009a73),
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Text(_errorMessage!,
                        style: const TextStyle(color: Colors.red)))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(_nameController, '名前'),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                                labelText: '性別', border: OutlineInputBorder()),
                            value: _gender,
                            items: const [
                              DropdownMenuItem(value: '男性', child: Text('男性')),
                              DropdownMenuItem(value: '女性', child: Text('女性')),
                              DropdownMenuItem(
                                  value: 'その他', child: Text('その他')),
                            ],
                            validator: (value) => value == null || value.isEmpty
                                ? '性別を選択してください'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(_phoneController, '電話番号'),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _postalCodeController,
                            decoration: InputDecoration(
                              labelText: '郵便番号（7桁）',
                              border: const OutlineInputBorder(),
                              suffixIcon: _isLoadingAddress
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      ),
                                    )
                                  : null,
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(7),
                            ],
                            onChanged: (value) {
                              if (value.length == 7) {
                                _fetchAddressFromPostalCode(value);
                              }
                            },
                            validator: (value) {
                              if (value != null &&
                                  value.isNotEmpty &&
                                  !RegExp(r'^\d{7}$').hasMatch(value)) {
                                return '7桁の数字で入力してください';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(_prefectureController, '都道府県'),
                          const SizedBox(height: 16),
                          _buildTextField(_cityController, '市区町村'),
                          const SizedBox(height: 16),
                          _buildTextField(_address1Controller, '番地・建物名'),
                          const SizedBox(height: 16),
                          _buildTextField(_address2Controller, '建物名・部屋番号（任意）'),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _updateUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF009a73),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text('更新する'),
                          )
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (label.contains('（任意）')) return null;
        if (value == null || value.isEmpty) {
          return '$label は必須項目です';
        }
        return null;
      },
    );
  }
}
