// UserCard.jsx - Componente di test per TEST_FEEDBACK_LOOP
// Creato da: cervella-frontend
// Data: 2026-01-07

export function UserCard({ name, avatar }) {
  return (
    <div className="user-card">
      <img src={avatar} alt={name} />
      <span>{name}</span>
    </div>
  );
}
