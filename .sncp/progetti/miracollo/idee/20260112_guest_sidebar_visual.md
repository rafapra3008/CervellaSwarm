# Guest Sidebar - Visual Mockup

**Data**: 2026-01-12
**Feature**: FASE 9 - KILLER FEATURE Miracallook

---

## Layout Completo

```
+==============================================================================+
|  SIDEBAR            |  EMAIL LIST                |  EMAIL DETAIL + GUEST   |
+==============================================================================+
|                     |                            |                          |
|  📥 All Mail        |  ☑ rafapra@gmail.com      | Subject: Late checkout?  |
|  ⭐ VIP             |    Late checkout request   +--------------------------|
|  🔔 Check-in        |    Today 2:30 PM           | From: rafapra@gmail.com |
|  👥 Team            |                            |       [Guest]            |
|  📦 Fornitori       |  ☐ mario.rossi@gmail.com  | To: info@hotel.com      |
|  📰 Newsletter      |    Grazie del soggiorno!   | Date: 12 Jan, 14:30     |
|  ⚙️  System         |    Today 1:15 PM           |                          |
|                     |                            | [Reply] [Forward] [...]  |
|                     |  Bundle: OTA (5)          |                          |
|                     |  └─ booking@airbnb.com    | Ciao,                    |
|                     |  └─ confirm@booking.com   | È possibile avere un     |
|                     |                            | late checkout domani?    |
|                     |                            |                          |
|                     |                            | Grazie                   |
|                     |                            | Rafael                   |
|                     |                            |                          |
|                     |                            |                          |
|                     |                            |                          |
|                     |                            |                          |
+=====================+============================+==========================+
                                                   |  GUEST SIDEBAR          |
                                                   |                         |
                                                   |  ┌─────────────────┐   |
                                                   |  │      RP         │   |
                                                   |  │  (gradient)     │   |
                                                   |  └─────────────────┘   |
                                                   |                         |
                                                   |  Rafael Vinicius Pra   |
                                                   |  rafapra@gmail.com     |
                                                   |  +39 340 123 4567      |
                                                   |                         |
                                                   |      [VIP]             |
                                                   |  3 soggiorni precedenti|
                                                   |                         |
                                                   |  ─────────────────────  |
                                                   |  📋 PRENOTAZIONE        |
                                                   |  ─────────────────────  |
                                                   |  ┌───────────────────┐ |
                                                   |  │ Camera: 301 Suite │ |
                                                   |  │ Deluxe            │ |
                                                   |  │                   │ |
                                                   |  │ Check-in:         │ |
                                                   |  │ 20 Gen 2026       │ |
                                                   |  │                   │ |
                                                   |  │ Check-out:        │ |
                                                   |  │ 25 Gen 2026       │ |
                                                   |  │                   │ |
                                                   |  │ Notti: 5          │ |
                                                   |  │                   │ |
                                                   |  │ Totale: €1,250    │ |
                                                   |  │                   │ |
                                                   |  │ Status: CONFIRMED │ |
                                                   |  └───────────────────┘ |
                                                   |                         |
                                                   |  ─────────────────────  |
                                                   |  📝 NOTE                |
                                                   |  ─────────────────────  |
                                                   |  • VIP Guest           |
                                                   |  • Preferisce vista    |
                                                   |    mare                |
                                                   |  • Richiesto late      |
                                                   |    checkout            |
                                                   |                         |
                                                   |  [Vedi in Miracollo]   |
                                                   |  [Aggiungi Nota]       |
                                                   |                         |
                                                   |  Miracollo PMS          |
                                                   +─────────────────────────+
```

---

## Stati Sidebar

### Email da Guest Noto
```
+--------------------------------+
|  Email Detail (flex-1)         |  Guest Sidebar (w-80)
+--------------------------------+
```

### Email NON Guest
```
+--------------------------------+
|  Email Detail (full width)     |
+--------------------------------+
```

---

## Badge Status Prenotazione

**CONFIRMED** (blu)
```
┌──────────────┐
│ ● CONFERMATA │ (bg-blue-500/20 border-blue-500/30 text-blue-400)
└──────────────┘
```

**CHECKED_IN** (verde)
```
┌──────────────────┐
│ ● CHECK-IN FATTO │ (bg-green-500/20 border-green-500/30 text-green-400)
└──────────────────┘
```

**CHECKED_OUT** (grigio)
```
┌───────────────────┐
│ ● CHECK-OUT FATTO │ (bg-gray-500/20 border-gray-500/30 text-gray-400)
└───────────────────┘
```

**CANCELLED** (rosso)
```
┌──────────────┐
│ ● CANCELLATA │ (bg-red-500/20 border-red-500/30 text-red-400)
└──────────────┘
```

---

## Avatar Gradient

```
┌─────────────┐
│             │
│      RP     │  Iniziali su gradient
│             │  from-blue-500 to-purple-600
│             │
└─────────────┘
    64x64px
    rounded-full
```

---

## VIP Badge

```
┌─────────┐
│   VIP   │  Gradient amber/orange
└─────────┘  px-3 py-1 rounded-full
             from-amber-500/20 to-orange-500/20
             border border-amber-500/30
```

---

## Flow Utente

1. **Apri email normale** → Sidebar non appare
2. **Apri email da guest** → Sidebar slide in da destra
3. **Vedi info booking** → A colpo d'occhio: camera, date, status
4. **Leggi note** → Allergie, preferenze, richieste
5. **Click "Vedi in Miracollo"** → (futuro) Apre guest in PMS
6. **Click "Aggiungi Nota"** → (futuro) Modal per nota rapida

---

## Differenza Competitiva

### SUPERHUMAN (normale email client)
```
+--------------------------------------------------+
|  EMAIL DETAIL                                    |
|                                                  |
|  Subject: Late checkout?                         |
|  From: rafapra@gmail.com                         |
|                                                  |
|  Ciao, è possibile...                            |
+--------------------------------------------------+
```

### MIRACALLOOK (email + contesto PMS)
```
+------------------------------------------+--------+
|  EMAIL DETAIL                            | GUEST  |
|                                          | INFO   |
|  Subject: Late checkout?                 |        |
|  From: rafapra@gmail.com [Guest]         | Camera |
|                                          | 301    |
|  Ciao, è possibile...                    | Suite  |
|                                          |        |
|                                          | 20-25  |
|                                          | Gen    |
+------------------------------------------+--------+
```

**ZERO context switch!**

Quando ricevi email da un ospite:
- Vedi subito chi è (camera, date)
- Non devi aprire il PMS
- Puoi rispondere con contesto completo
- Note e preferenze a portata di mano

---

## Implementazione Tecnica

### Logica Condizionale
```typescript
const guest = findGuestByEmail(email.from);
// Se guest trovato → mostra sidebar
// Se guest null → nessuna sidebar
```

### Responsive Future
```
Desktop:  Email (flex-1) + Sidebar (w-80)
Tablet:   Email (full) + Sidebar togglable
Mobile:   Email (full) + Sidebar bottom sheet
```

---

## Mock Database

4 guest test disponibili:
- rafapra@gmail.com (VIP, Suite)
- mario.rossi@gmail.com (Check-in oggi)
- giulia.bianchi@example.com (Compleanno)
- paolo.verdi@mail.com (VIP, Suite Presidenziale)

---

## Filosofia Design

```
"Il design impone rispetto. Ogni pixel conta."
"Mobile-first, sempre."
"Fatto BENE > Fatto VELOCE"
```

- Padding generosi (no ammassamento)
- Colori dark mode coerenti
- Animazioni sottili (0.2-0.3s)
- Gerarchia visiva chiara
- Info scansionabile rapidamente

---

*"Il CONTEXT è il nostro vantaggio competitivo!"*
