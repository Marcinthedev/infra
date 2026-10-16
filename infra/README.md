# infra

Wszystko, co wspólne dla stacji Claude'a i wszystkich apek.

```
infra/
├── claude-ws/                     stacja robocza Claude'a
│   ├── Dockerfile
│   ├── start.sh
│   └── compose.yaml               stack "claude-ws" w Portainerze
├── stacks/
│   └── web-app/compose.yaml       wspólny stack apek (stage i prod, różnią się zmiennymi)
└── .github/workflows/
    ├── claude-ws-image.yml        buduje obraz stacji do GHCR
    ├── app-ci.yml                 wspólne CI apek (wywoływane z repo apki)
    └── app-release.yml            wspólny build/stage/prod apek (wywoływany z repo apki)
```

Ustawienie wymagane raz: Settings → Actions → General → Access →
„Accessible from repositories owned by the user”, żeby repo apek mogły używać workflow z `infra`.
