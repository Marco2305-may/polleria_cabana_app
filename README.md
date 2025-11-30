# 🐔 Pollería La Cabaña - App Flutter

## 📱 Descripción

Pollería La Cabaña es una **app móvil Flutter** para gestionar pedidos, reservas y usuarios de una pollería.  
Arquitectura: **MVVM (Model-View-ViewModel)** ✅

- **Model (📦)**: Entidades de la app (`Usuario`, `Pedido`, `Comida`, `Reservación`).  
- **View (🖥️)**: Pantallas y widgets que interactúan con el usuario.  
- **ViewModel / Services (⚙️)**: Lógica de negocio, conexión con Firebase, manejo de estado (`Provider`).

---

## 📂 Estructura del proyecto

```text
lib/
├─ models/      # Entidades principales (Usuario, Pedido, Comida, Reservación, etc.)
├─ screens/     # Pantallas de la app (cliente, admin)
├─ services/    # Lógica de negocio y conexión con Firebase
├─ widgets/     # Widgets reutilizables
└─ utils/       # Configuraciones privadas y utilidades (no subir al repo)

## 🧩 Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^4.2.1
  cloud_firestore: ^6.1.0
  firebase_auth: ^6.1.2
  firebase_storage: ^13.0.4
  image_picker: ^1.1.1
  provider: ^6.1.5
  path_provider: ^2.1.5
  google_sign_in: ^6.2.1
  google_maps_flutter: ^2.6.0
  geocoding: ^2.1.0
  geolocator: ^11.0.0
  cupertino_icons: ^1.0.8
  google_api_headers: ^1.6.0

Se utiliza Firebase para:

- **Autenticación de usuarios** (`firebase_auth`)
- **Base de datos en tiempo real** (`cloud_firestore`) con colecciones:
  - `usuarios`
  - `pedidos`
  - `comidas`
  - `reservaciones`
- **Almacenamiento de imágenes** (`firebase_storage`)

> Todos los archivos de configuración privada están en `lib/utils/` y se ignoran con `.gitignore`.

---

## 🌐 APIs externas

- **Google Maps API**: mostrar ubicación de la pollería y selección de direcciones.
- **Firebase Cloud**: autenticación, base de datos y almacenamiento.

> Las claves de las APIs **no se suben al repositorio**.

---

## ⚡ Instalación

1. Clonar el repositorio:

```bash
git clone https://github.com/Marco2305-may/polleria_cabana_app.git


2. Configurar Firebase:  
   - Colocar `google-services.json` en `android/app/`  
   - Colocar `GoogleService-Info.plist` en `iOS/Runner/`  

3. Ejecutar la app:

```bash
flutter run
