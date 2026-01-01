FROM python:3.11-slim

LABEL maintainer="Cervella & Rafa"
LABEL description="Prometheus Exporter per CervellaSwarm"
LABEL version="1.0.0"

# Crea utente non-root
RUN useradd -m -u 1000 exporter

# Working directory
WORKDIR /app

# Copia requirements
COPY requirements.txt .

# Installa dipendenze
RUN pip install --no-cache-dir -r requirements.txt

# Copia script exporter
COPY swarm_exporter.py .

# Permessi
RUN chown -R exporter:exporter /app
RUN chmod +x swarm_exporter.py

# Switch a utente non-root
USER exporter

# Porta exporter
EXPOSE 9091

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python3 -c "import urllib.request; urllib.request.urlopen('http://localhost:9091/health')" || exit 1

# Entrypoint
ENTRYPOINT ["python3", "swarm_exporter.py"]
