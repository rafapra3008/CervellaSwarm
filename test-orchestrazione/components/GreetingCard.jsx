// @version 1.0.0
// @date 2025-12-30
// GreetingCard - Componente per mostrare il saluto del giorno

import React, { useState, useEffect } from 'react';

const GreetingCard = () => {
  const [greeting, setGreeting] = useState('');
  const [hour, setHour] = useState(0);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchGreeting();
  }, []);

  const fetchGreeting = async () => {
    try {
      setLoading(true);
      const response = await fetch('/api/greeting');
      const data = await response.json();

      if (data.status === 'success') {
        setGreeting(data.data.greeting);
        setHour(data.data.hour);
      } else {
        setError('Errore nel caricamento del saluto');
      }
    } catch (err) {
      setError('Impossibile connettersi al server');
      console.error('Errore fetch greeting:', err);
    } finally {
      setLoading(false);
    }
  };

  // Determina colore sfondo in base all'ora
  const getBackgroundStyle = () => {
    if (hour >= 5 && hour < 12) {
      // Mattina: giallo/arancione
      return {
        background: 'linear-gradient(135deg, #FDB813 0%, #FFA500 100%)',
        color: '#2C1810'
      };
    } else if (hour >= 12 && hour < 18) {
      // Pomeriggio: azzurro
      return {
        background: 'linear-gradient(135deg, #89CFF0 0%, #4A9FD8 100%)',
        color: '#1A3A52'
      };
    } else if (hour >= 18 && hour < 22) {
      // Sera: viola
      return {
        background: 'linear-gradient(135deg, #A78BFA 0%, #7C3AED 100%)',
        color: '#FFFFFF'
      };
    } else {
      // Notte: blu scuro
      return {
        background: 'linear-gradient(135deg, #1E3A8A 0%, #0F172A 100%)',
        color: '#E0E7FF'
      };
    }
  };

  const cardStyle = {
    ...getBackgroundStyle(),
    borderRadius: '16px',
    padding: '32px',
    maxWidth: '400px',
    margin: '0 auto',
    boxShadow: '0 8px 24px rgba(0, 0, 0, 0.15)',
    transition: 'transform 0.3s ease, box-shadow 0.3s ease',
    cursor: 'pointer',
    fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif'
  };

  const greetingTextStyle = {
    fontSize: '32px',
    fontWeight: '700',
    marginBottom: '16px',
    textAlign: 'center',
    letterSpacing: '-0.5px'
  };

  const hourTextStyle = {
    fontSize: '18px',
    fontWeight: '500',
    textAlign: 'center',
    opacity: '0.9'
  };

  const loadingStyle = {
    ...cardStyle,
    background: 'linear-gradient(135deg, #E5E7EB 0%, #D1D5DB 100%)',
    color: '#6B7280'
  };

  const errorStyle = {
    ...cardStyle,
    background: 'linear-gradient(135deg, #FEE2E2 0%, #FECACA 100%)',
    color: '#991B1B'
  };

  // Stati loading ed errore
  if (loading) {
    return (
      <div style={loadingStyle}>
        <div style={greetingTextStyle}>Caricamento...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div style={errorStyle}>
        <div style={greetingTextStyle}>Ops!</div>
        <div style={hourTextStyle}>{error}</div>
      </div>
    );
  }

  return (
    <div
      style={cardStyle}
      onMouseEnter={(e) => {
        e.currentTarget.style.transform = 'translateY(-4px)';
        e.currentTarget.style.boxShadow = '0 12px 32px rgba(0, 0, 0, 0.2)';
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.transform = 'translateY(0)';
        e.currentTarget.style.boxShadow = '0 8px 24px rgba(0, 0, 0, 0.15)';
      }}
    >
      <div style={greetingTextStyle}>
        {greeting}
      </div>
      <div style={hourTextStyle}>
        Sono le ore {hour}:00
      </div>
    </div>
  );
};

export default GreetingCard;
