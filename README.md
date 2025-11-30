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

