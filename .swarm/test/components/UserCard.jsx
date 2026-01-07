// UserCard.jsx - Componente di test
// Creato da cervella-frontend come parte di TEST_FEEDBACK_LOOP

export function UserCard({ name, avatar }) {
  return (
    <div className="user-card">
      <img src={avatar} alt={name} />
      <span>{name}</span>
    </div>
  );
}
