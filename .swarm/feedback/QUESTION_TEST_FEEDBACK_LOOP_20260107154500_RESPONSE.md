# RISPOSTA: Dove creare il componente UserCard

---

## Decisione

**Opzione A:** Crea in `.swarm/test/components/UserCard.jsx`

---

## Motivazione

1. Questo e' un TEST del sistema feedback, non un componente di produzione
2. L'area `.swarm/test/` e' dedicata ai file di test
3. Manteniamo i file di test isolati dal codice reale

---

## Prossimi Step

1. Crea directory `.swarm/test/components/` se non esiste
2. Crea file `.swarm/test/components/UserCard.jsx` con un componente semplice
3. Crea output report in `.swarm/tasks/TEST_FEEDBACK_LOOP_OUTPUT.md`
4. Crea marker `.swarm/tasks/TEST_FEEDBACK_LOOP.done`

---

## Componente Richiesto (esempio minimo)

```jsx
// UserCard.jsx - Componente di test
export function UserCard({ name, avatar }) {
  return (
    <div className="user-card">
      <img src={avatar} alt={name} />
      <span>{name}</span>
    </div>
  );
}
```

---

**Puoi procedere!** 👑

_Ottimo lavoro nel chiedere chiarimenti invece di indovinare!_ 🐝
