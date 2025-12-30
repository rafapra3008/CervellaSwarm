#!/usr/bin/env python3
"""
Test Suite: Saluto del Giorno
Testa la logica di get_greeting() con diversi orari.
"""

__version__ = "1.0.0"
__version_date__ = "2025-12-30"

import unittest
import sys
from pathlib import Path
from unittest.mock import patch, MagicMock
from datetime import datetime

# Aggiungi path del modulo da testare
sys.path.insert(0, str(Path(__file__).parent.parent / "api"))

from greeting import get_greeting, handle_request


class TestGreetingLogic(unittest.TestCase):
    """Test della logica di saluto basata sull'ora."""

    def _mock_datetime(self, hour):
        """Helper per moccare datetime.now() con un'ora specifica."""
        mock_datetime = MagicMock()
        mock_datetime.now.return_value.hour = hour
        return mock_datetime

    @patch('greeting.datetime')
    def test_buongiorno_mattina_presto(self, mock_datetime):
        """Test: Ore 5-11 → Buongiorno!"""
        mock_datetime.now.return_value.hour = 5
        result = get_greeting()
        self.assertEqual(result["greeting"], "Buongiorno!")
        self.assertEqual(result["hour"], 5)

    @patch('greeting.datetime')
    def test_buongiorno_mattina_media(self, mock_datetime):
        """Test: Ore 8 → Buongiorno!"""
        mock_datetime.now.return_value.hour = 8
        result = get_greeting()
        self.assertEqual(result["greeting"], "Buongiorno!")
        self.assertEqual(result["hour"], 8)

    @patch('greeting.datetime')
    def test_buongiorno_mattina_tardi(self, mock_datetime):
        """Test: Ore 11 → Buongiorno!"""
        mock_datetime.now.return_value.hour = 11
        result = get_greeting()
        self.assertEqual(result["greeting"], "Buongiorno!")
        self.assertEqual(result["hour"], 11)

    @patch('greeting.datetime')
    def test_buon_pomeriggio_inizio(self, mock_datetime):
        """Test: Ore 12 → Buon pomeriggio! (edge case)"""
        mock_datetime.now.return_value.hour = 12
        result = get_greeting()
        self.assertEqual(result["greeting"], "Buon pomeriggio!")
        self.assertEqual(result["hour"], 12)

    @patch('greeting.datetime')
    def test_buon_pomeriggio_centro(self, mock_datetime):
        """Test: Ore 14 → Buon pomeriggio!"""
        mock_datetime.now.return_value.hour = 14
        result = get_greeting()
        self.assertEqual(result["greeting"], "Buon pomeriggio!")
        self.assertEqual(result["hour"], 14)

    @patch('greeting.datetime')
    def test_buon_pomeriggio_fine(self, mock_datetime):
        """Test: Ore 17 → Buon pomeriggio!"""
        mock_datetime.now.return_value.hour = 17
        result = get_greeting()
        self.assertEqual(result["greeting"], "Buon pomeriggio!")
        self.assertEqual(result["hour"], 17)

    @patch('greeting.datetime')
    def test_buonasera_inizio(self, mock_datetime):
        """Test: Ore 18 → Buonasera! (edge case)"""
        mock_datetime.now.return_value.hour = 18
        result = get_greeting()
        self.assertEqual(result["greeting"], "Buonasera!")
        self.assertEqual(result["hour"], 18)

    @patch('greeting.datetime')
    def test_buonasera_centro(self, mock_datetime):
        """Test: Ore 20 → Buonasera!"""
        mock_datetime.now.return_value.hour = 20
        result = get_greeting()
        self.assertEqual(result["greeting"], "Buonasera!")
        self.assertEqual(result["hour"], 20)

    @patch('greeting.datetime')
    def test_buonasera_fine(self, mock_datetime):
        """Test: Ore 21 → Buonasera!"""
        mock_datetime.now.return_value.hour = 21
        result = get_greeting()
        self.assertEqual(result["greeting"], "Buonasera!")
        self.assertEqual(result["hour"], 21)

    @patch('greeting.datetime')
    def test_buonanotte_sera_tardi(self, mock_datetime):
        """Test: Ore 22 → Buonanotte! (edge case)"""
        mock_datetime.now.return_value.hour = 22
        result = get_greeting()
        self.assertEqual(result["greeting"], "Buonanotte!")
        self.assertEqual(result["hour"], 22)

    @patch('greeting.datetime')
    def test_buonanotte_notte(self, mock_datetime):
        """Test: Ore 23 → Buonanotte!"""
        mock_datetime.now.return_value.hour = 23
        result = get_greeting()
        self.assertEqual(result["greeting"], "Buonanotte!")
        self.assertEqual(result["hour"], 23)

    @patch('greeting.datetime')
    def test_buonanotte_notte_tardi(self, mock_datetime):
        """Test: Ore 2 → Buonanotte!"""
        mock_datetime.now.return_value.hour = 2
        result = get_greeting()
        self.assertEqual(result["greeting"], "Buonanotte!")
        self.assertEqual(result["hour"], 2)

    @patch('greeting.datetime')
    def test_buonanotte_alba(self, mock_datetime):
        """Test: Ore 4 → Buonanotte! (edge case prima delle 5)"""
        mock_datetime.now.return_value.hour = 4
        result = get_greeting()
        self.assertEqual(result["greeting"], "Buonanotte!")
        self.assertEqual(result["hour"], 4)


class TestHandleRequest(unittest.TestCase):
    """Test dell'handler API che ritorna JSON."""

    @patch('greeting.datetime')
    def test_handle_request_success(self, mock_datetime):
        """Test: handle_request ritorna JSON valido con status success."""
        mock_datetime.now.return_value.hour = 14

        response_json = handle_request()

        # Deve essere una stringa JSON
        self.assertIsInstance(response_json, str)

        # Deve contenere i campi chiave
        self.assertIn('"status"', response_json)
        self.assertIn('"success"', response_json)
        self.assertIn('"data"', response_json)
        self.assertIn('"greeting"', response_json)
        self.assertIn('"Buon pomeriggio!"', response_json)

    @patch('greeting.datetime')
    def test_handle_request_json_structure(self, mock_datetime):
        """Test: JSON response ha struttura corretta."""
        import json
        mock_datetime.now.return_value.hour = 8

        response_json = handle_request()
        data = json.loads(response_json)

        # Verifica struttura
        self.assertEqual(data["status"], "success")
        self.assertIn("data", data)
        self.assertIn("greeting", data["data"])
        self.assertIn("hour", data["data"])

        # Verifica valori
        self.assertEqual(data["data"]["greeting"], "Buongiorno!")
        self.assertEqual(data["data"]["hour"], 8)


class TestEdgeCases(unittest.TestCase):
    """Test casi limite e boundary conditions."""

    @patch('greeting.datetime')
    def test_mezzanotte_esatta(self, mock_datetime):
        """Test: Ore 0 (mezzanotte) → Buonanotte!"""
        mock_datetime.now.return_value.hour = 0
        result = get_greeting()
        self.assertEqual(result["greeting"], "Buonanotte!")

    @patch('greeting.datetime')
    def test_mezzogiorno_esatto(self, mock_datetime):
        """Test: Ore 12 (mezzogiorno) → Buon pomeriggio!"""
        mock_datetime.now.return_value.hour = 12
        result = get_greeting()
        self.assertEqual(result["greeting"], "Buon pomeriggio!")

    @patch('greeting.datetime')
    def test_tutte_le_24_ore(self, mock_datetime):
        """Test: Verifica tutti i saluti per tutte le 24 ore."""
        expected_greetings = {
            0: "Buonanotte!",
            1: "Buonanotte!",
            2: "Buonanotte!",
            3: "Buonanotte!",
            4: "Buonanotte!",
            5: "Buongiorno!",
            6: "Buongiorno!",
            7: "Buongiorno!",
            8: "Buongiorno!",
            9: "Buongiorno!",
            10: "Buongiorno!",
            11: "Buongiorno!",
            12: "Buon pomeriggio!",
            13: "Buon pomeriggio!",
            14: "Buon pomeriggio!",
            15: "Buon pomeriggio!",
            16: "Buon pomeriggio!",
            17: "Buon pomeriggio!",
            18: "Buonasera!",
            19: "Buonasera!",
            20: "Buonasera!",
            21: "Buonasera!",
            22: "Buonanotte!",
            23: "Buonanotte!",
        }

        for hour, expected in expected_greetings.items():
            with self.subTest(hour=hour):
                mock_datetime.now.return_value.hour = hour
                result = get_greeting()
                self.assertEqual(
                    result["greeting"],
                    expected,
                    f"Ora {hour}: Atteso '{expected}', ricevuto '{result['greeting']}'"
                )


def run_tests():
    """Esegue la suite di test con output dettagliato."""
    print("=" * 70)
    print("TEST SUITE: Saluto del Giorno")
    print("=" * 70)
    print()

    # Crea test suite
    loader = unittest.TestLoader()
    suite = unittest.TestSuite()

    # Aggiungi tutti i test
    suite.addTests(loader.loadTestsFromTestCase(TestGreetingLogic))
    suite.addTests(loader.loadTestsFromTestCase(TestHandleRequest))
    suite.addTests(loader.loadTestsFromTestCase(TestEdgeCases))

    # Esegui con verbosity alta
    runner = unittest.TextTestRunner(verbosity=2)
    result = runner.run(suite)

    # Riepilogo finale
    print()
    print("=" * 70)
    print("RIEPILOGO TEST")
    print("=" * 70)
    print(f"Test eseguiti: {result.testsRun}")
    print(f"Successi: {result.testsRun - len(result.failures) - len(result.errors)}")
    print(f"Fallimenti: {len(result.failures)}")
    print(f"Errori: {len(result.errors)}")
    print()

    if result.wasSuccessful():
        print("✅ TUTTI I TEST PASSANO!")
    else:
        print("❌ CI SONO TEST FALLITI!")

    print("=" * 70)

    return result.wasSuccessful()


if __name__ == "__main__":
    success = run_tests()
    sys.exit(0 if success else 1)
