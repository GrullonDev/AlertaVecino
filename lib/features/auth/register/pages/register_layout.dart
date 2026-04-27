import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterLayout extends StatelessWidget {
  const RegisterLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(color: Colors.teal.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  'Registro',
                  style: GoogleFonts.abyssinicaSil(
                    fontSize: 32,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Crea una cuenta en Alerta Vecinos',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 32),
              
              _buildTextField(
                label: 'Nombre completo',
                icon: Icons.person_outline,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                label: 'Correo electrónico',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                label: 'Número de teléfono',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                label: 'Contraseña',
                icon: Icons.lock_outline,
                obscureText: true,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.visibility_off_outlined),
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                label: 'Departamento / Municipio',
                icon: Icons.map_outlined,
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                label: 'Colonia o Residencial',
                icon: Icons.location_city_outlined,
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                label: 'Sector, fase, bloque o calle',
                icon: Icons.signpost_outlined,
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                label: 'Número de casa/apartamento (Opcional)',
                icon: Icons.home_outlined,
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                label: 'Documento de verificación',
                icon: Icons.document_scanner_outlined,
                helperText: 'Recibo de agua/luz, constancia de residencia o código de invitación',
              ),
              const SizedBox(height: 32),
              
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Registrarse',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    '¿Ya tienes cuenta? ',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? helperText,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: Icon(icon, color: Colors.teal),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }
}
