/**
 * UserCard.jsx - Componente di test per sistema feedback
 *
 * Creato da: cervella-frontend
 * Task ID: TEST_FEEDBACK_LOOP
 * Data: 2026-01-07
 *
 * Questo componente e' stato creato come parte del test del sistema
 * di feedback dello sciame CervellaSwarm. Il worker (frontend) ha
 * correttamente chiesto chiarimenti quando il task non specificava
 * dove creare il file.
 */

import React from 'react';

/**
 * Componente UserCard - Mostra nome e avatar di un utente
 *
 * @param {Object} props
 * @param {string} props.name - Nome dell'utente
 * @param {string} props.avatar - URL dell'avatar
 * @returns {JSX.Element}
 */
export function UserCard({ name, avatar }) {
  return (
    <div className="user-card">
      <img
        src={avatar}
        alt={`Avatar di ${name}`}
        className="user-card__avatar"
      />
      <span className="user-card__name">{name}</span>
    </div>
  );
}

// Stili inline per demo (in produzione usare CSS modules o Tailwind)
export const UserCardStyles = `
.user-card {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px;
  border-radius: 8px;
  background: #f5f5f5;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.user-card__avatar {
  width: 48px;
  height: 48px;
  border-radius: 50%;
  object-fit: cover;
}

.user-card__name {
  font-size: 16px;
  font-weight: 500;
  color: #333;
}
`;

export default UserCard;
