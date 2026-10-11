# Frontend (Flutter screens)

The team built the mobile UI as separate Flutter projects, one per screen, during the course sprints. They are kept here as delivered: they render the UI but are **not yet wired to the backend API**.

| Folder | Screen | Committed by |
|---|---|---|
| `rider-login/` | Splash / rider login | Mai Mahmoud |
| `profile-menu/` | Rider profile and menu | Mai Mahmoud |
| `driver-login/` | Driver authentication | Shahd Yasser |
| `driver-requests/` | Driver's list of ride requests | Shahd Yasser |

Each folder is a standalone Flutter app:

```bash
cd frontend/driver-requests
flutter pub get
flutter run
```

## Next step: one app

Merge the screens into a single Flutter app that talks to the API:

1. Create one Flutter project and move each screen's `presentation/` folder into it, sharing `core/`, `theme/` and `widgets/`.
2. Add an API client that stores the JWT from `POST /api/auth/login` and sends it as `Authorization: Bearer <token>`.
3. Use `socket_io_client` with `auth: {'token': jwt}` for live ride updates and driver location.
4. Never embed Supabase or SMS keys in the app; the backend holds all secrets.
