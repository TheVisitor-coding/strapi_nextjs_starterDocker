# 📊 Guide Monitoring - Prometheus & Grafana

## 🚀 Démarrage rapide

### 1. Lancer le monitoring
```bash
# Démarrer avec monitoring
docker-compose --profile monitoring up -d

# Vérifier que tout fonctionne
docker-compose ps
```

### 2. Accéder aux interfaces
- **Grafana**: http://localhost:3001
  - Login: `admin`
  - Password: `admin`
- **Prometheus**: http://localhost:9090

## 📈 Utilisation de Grafana

### Dashboard automatique
Un dashboard "Stack Overview" est automatiquement créé avec :
- **Status des services** : Up/Down de chaque service
- **Requêtes HTTP** : Nombre de requêtes par minute
- **Temps de réponse** : Latence moyenne
- **Taux d'erreurs** : Erreurs 4xx et 5xx

### Créer un nouveau dashboard

1. **Créer un dashboard** :
   - Menu → Dashboards → New Dashboard
   - Cliquer "Add new panel"

2. **Ajouter une métrique** :
   - Data source : Prometheus
   - Query : `up{job="strapi-backend"}` (exemple)
   - Cliquer "Run query"

### Métriques utiles à surveiller

#### Services Status
```promql
up{job="strapi-backend"}
up{job="nextjs-frontend"}
up{job="nginx"}
```

#### Performance
```promql
# Temps de réponse moyen
rate(http_request_duration_seconds_sum[5m]) / rate(http_request_duration_seconds_count[5m])

# Requêtes par seconde
rate(http_requests_total[5m])
```

#### Erreurs
```promql
# Erreurs 5xx
rate(http_requests_total{status=~"5.."}[5m])

# Erreurs 4xx
rate(http_requests_total{status=~"4.."}[5m])
```

## 🔧 Configuration avancée

### Ajouter des métriques personnalisées

#### Pour Strapi
Ajouter dans `apps/api/config/middlewares.ts` :
```typescript
export default [
  'strapi::logger',
  'strapi::errors',
  'strapi::security',
  'strapi::cors',
  'strapi::poweredBy',
  'strapi::query',
  'strapi::body',
  'strapi::session',
  'strapi::favicon',
  'strapi::public',
  // Ajouter un middleware custom pour les métriques
];
```

#### Pour Next.js
Créer `apps/web/src/app/api/metrics/route.ts` :
```typescript
import { NextResponse } from 'next/server';

export async function GET() {
  // Logique pour exposer des métriques
  return NextResponse.json({
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    // Autres métriques...
  });
}
```

### Alertes

#### Créer une alerte dans Grafana
1. Dashboard → Panel → Edit
2. Alert tab → Create Alert
3. Condition : `up{job="strapi-backend"} == 0`
4. Notifications : Email, Slack, etc.

## 🎯 Cas d'usage pratiques

### 1. Monitoring de production
- **Disponibilité** : Vérifier que tous les services sont up
- **Performance** : Surveiller les temps de réponse
- **Erreurs** : Détecter les pics d'erreurs

### 2. Debug de problèmes
- **Corrélation** : Lier les erreurs aux pics de trafic
- **Historique** : Voir l'évolution sur plusieurs heures/jours
- **Isolation** : Identifier quel service pose problème

### 3. Optimisation
- **Bottlenecks** : Identifier les services lents
- **Ressources** : Surveiller CPU/mémoire
- **Trafic** : Analyser les patterns d'usage

## 🔍 Troubleshooting

### Prometheus ne collecte pas de métriques
```bash
# Vérifier la configuration
docker-compose logs prometheus

# Tester la connectivité
docker-compose exec prometheus wget -qO- backend:1337/_health
```

### Grafana ne trouve pas Prometheus
1. Vérifier que Prometheus est démarré
2. Data Sources → Prometheus → Test connection
3. URL doit être : `http://prometheus:9090`

### Dashboard vide
1. Vérifier que les services exposent des métriques
2. Tester les requêtes PromQL dans Prometheus
3. Vérifier les time ranges dans Grafana

## 📚 Ressources utiles

- **PromQL**: [Documentation officielle](https://prometheus.io/docs/prometheus/latest/querying/)
- **Grafana**: [Documentation officielle](https://grafana.com/docs/)
- **Dashboards**: [Grafana.com](https://grafana.com/grafana/dashboards/)

---

**💡 Conseil** : Commence par le dashboard "Stack Overview" puis ajoute des métriques spécifiques selon tes besoins ! 