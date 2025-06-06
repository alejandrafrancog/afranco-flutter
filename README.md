# 📱 📰 Flutter App

Proyecto desarrollado en Flutter. Esta aplicación requiere un archivo `.env` para funcionar correctamente.

## 🚀 Requisitos previos

- **Flutter 3.29.2** (recomendado)
- Tener un dispositivo físico o emulador configurado
- Tener creado un archivo `.env` en la raíz del proyecto

## 📝 Formato del .env

```bash
BEECEPTOR_BASE_URL=https://yourApiKey.proxy.beeceptor.com/api

BEECEPTOR_API_KEY=your_key_here
```

## ¿Cómo probar?

### Clonar el repositorio

```bash
git clone https://github.com/alejandrafrancog/afranco-flutter.git

cd afranco-flutter

```
### Ejecutar la app
```bash
flutter clean
flutter pub get
flutter run
```
### 📦 Dependencias del sistema (Linux)

Si estás en Linux y planeas correr el proyecto con soporte de `flutter_secure_storage`, necesitas instalar la siguiente dependencia del sistema:

```bash
sudo apt install libsecret-1-dev
```

### 🔧 Problemas comunes
- Si encuentras algún problema al ejecutar la app:

- Verifica que el archivo .env esté correctamente configurado

- Asegúrate de tener la versión correcta de Flutter instalada

- Ejecuta flutter doctor para verificar que tu entorno esté configurado correctamente

- En caso de usar un dispositivo físico (Android), asegúrate de tener activados
el modo desarrollador y la depuración por USB

- Asegúrate de entrar con uno de los usuarios definidos a continuación

### 👥 Usuarios de prueba disponibles
```bash
sodep
```
```bash
profeltes
```
```bash
monimoney
```
```bash
gricequeen
```
### 🔒 Contraseña en todos los casos

```bash
sodep
```
