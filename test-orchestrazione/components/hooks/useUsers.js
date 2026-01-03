import { useState, useEffect } from 'react';

/**
 * Hook useUsers - Fetches users from /api/users
 *
 * @returns {Object} { users, loading, error, refetch }
 * - users: User[] - Array di utenti
 * - loading: boolean - true durante il fetch
 * - error: string|null - Messaggio errore se presente
 * - refetch: function - Ricarica i dati
 */

/**
 * @typedef {Object} User
 * @property {number} id - ID utente
 * @property {string} name - Nome utente
 * @property {string} email - Email utente
 */

const API_URL = '/api/users';

export function useUsers() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchUsers = async () => {
    setLoading(true);
    setError(null);

    try {
      const response = await fetch(API_URL);

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();
      setUsers(data);
    } catch (err) {
      setError(err.message || 'Errore nel caricamento utenti');
      setUsers([]);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchUsers();
  }, []);

  return {
    users,
    loading,
    error,
    refetch: fetchUsers
  };
}

export default useUsers;
