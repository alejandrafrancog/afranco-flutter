import 'package:flutter/material.dart';
import 'package:afranco/theme/colors.dart';
import 'package:afranco/theme/text_style.dart';

class AcercaDeScreen extends StatelessWidget {
  const AcercaDeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildLogo(),

            const SizedBox(height: 32),

            _buildCompanyInfo(),

            const SizedBox(height: 32),

            _buildValoresSodepianos(),

            const SizedBox(height: 32),

            // Información de contacto
            _buildContactInfo(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withAlpha(100),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Image(
              image: NetworkImage(
                'https://sodep.com.py/wp-content/uploads/2023/06/sodep-logo_white-1.png',
              ),
              width:5,
              height:10
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'SODEP S.A.',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Soluciones de Desarrollo Profesional',
            style: AppTextStyles.subtitle1.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Sobre la Empresa',
                  style: AppTextStyles.h5.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'SODEP S.A. es una empresa comprometida con la excelencia y el desarrollo profesional, '
              'brindando soluciones innovadoras y servicios de calidad a nuestros clientes.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValoresSodepianos() {
    final valores = [
      {
        'titulo': 'Honestidad',
        'descripcion':
            'Actuamos con transparencia y verdad en todas nuestras relaciones',
        'color': AppColors.honestidad,
        'icon': Icons.verified_user,
      },
      {
        'titulo': 'Calidad',
        'descripcion':
            'Nos esforzamos por la excelencia en cada proyecto y servicio',
        'color': AppColors.calidad,
        'icon': Icons.star,
      },
      {
        'titulo': 'Flexibilidad',
        'descripcion': 'Nos adaptamos a las necesidades cambiantes del mercado',
        'color': AppColors.flexibilidad,
        'icon': Icons.sync,
      },
      {
        'titulo': 'Comunicación',
        'descripcion':
            'Mantenemos diálogo abierto y efectivo con todos nuestros stakeholders',
        'color': AppColors.comunicacion,
        'icon': Icons.forum,
      },
      {
        'titulo': 'Autogestión',
        'descripcion':
            'Fomentamos la responsabilidad personal y la iniciativa propia',
        'color': AppColors.autogestion,
        'icon': Icons.self_improvement,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.favorite, color: AppColors.secondary, size: 24),
            const SizedBox(width: 12),
            Text(
              'Valores Sodepianos',
              style: AppTextStyles.h5.copyWith(color: AppColors.secondary),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...valores.map(
          (valor) => _buildValorCard(
            valor['titulo'] as String,
            valor['descripcion'] as String,
            valor['color'] as Color,
            valor['icon'] as IconData,
          ),
        ),
      ],
    );
  }

  Widget _buildValorCard(
    String titulo,
    String descripcion,
    Color color,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withAlpha(128)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(120),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white.withAlpha(128),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: AppTextStyles.valorTitle),
                const SizedBox(height: 4),
                Text(descripcion, style: AppTextStyles.valorDescription),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.contact_mail,
                  color: AppColors.accent,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Información de Contacto',
                  style: AppTextStyles.h5.copyWith(color: AppColors.accent),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              Icons.location_on,
              'Dirección',
              'Bélgica 839 c/ Eusebio Lillo\nAsunción, Paraguay',
            ),
            const SizedBox(height: 12),
            _buildContactItem(Icons.phone, 'Teléfono', '(+595) 981-131-694'),
            const SizedBox(height: 12),
            _buildContactItem(Icons.email, 'Email', 'info@sodep.com.py'),
            const SizedBox(height: 12),
            _buildContactItem(Icons.web, 'Sitio Web', 'www.sodep.com.py'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.subtitle2.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
