# Utiliser une image légère de Python 3.9
FROM python:3.9-slim

# Mainteneur de l'image
LABEL maintainer="aicha238"

# Définir le répertoire de travail
WORKDIR /app

# Sécurité : Ajouter un utilisateur non-root avant d’installer les paquets Python
RUN useradd -m appuser

# Mettre à jour et installer les dépendances système en une seule commande
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    gcc libssl-dev libldap2-dev libc6-dev libsasl2-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copier les fichiers nécessaires avec les bonnes permissions
COPY --chown=appuser:appuser student_age.py requirements.txt ./ 

# Créer un dossier pour stocker les fichiers JSON avec les bonnes permissions
RUN mkdir -p /data && chown -R appuser:appuser /data
VOLUME /data

# Passer à l’utilisateur non-root
USER appuser

# Installer les dépendances Python
RUN pip3 install -r requirements.txt
# Exposer le port 5000
EXPOSE 5000

# Commande de lancement de l’API Flask
CMD ["python", "student_age.py"]
