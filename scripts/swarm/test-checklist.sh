#!/bin/bash
#
# test-checklist.sh - Script di test per checklist-pre-merge.sh
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "╔══════════════════════════════════════════════════╗"
echo "║     TEST: Checklist Pre-Merge (Demo Mode)       ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "Questo test simula l'esecuzione della checklist."
echo "Risponderà automaticamente 'y' al gate HUMAN REVIEW."
echo ""
read -p "Premere ENTER per continuare..."

# Esegui checklist con auto-approvazione
echo "y" | "${SCRIPT_DIR}/checklist-pre-merge.sh" --skip-tests

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║              TEST COMPLETATO!                    ║"
echo "╚══════════════════════════════════════════════════╝"
