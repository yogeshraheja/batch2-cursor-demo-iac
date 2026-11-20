FROM python:3.12-slim

WORKDIR /app

RUN apt-get update \
 && apt-get install -y --no-install-recommends git \
 && git clone --depth 1 --branch main \
      https://github.com/yogeshraheja/batch2_cursor_monitoring_application.git . \
 && apt-get purge -y git \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --default-timeout=100 -r requirements.txt

# Demo defaults aligned with ansible/inventory/group_vars/all.yml
ENV ADMIN_USERNAME=admin \
    SECRET_KEY=change-me-demo-secret \
    ADMIN_PASSWORD=ChangeMe123!

# Precompute Werkzeug hash so the container starts without extra -e flags;
# override ADMIN_PASSWORD_HASH at runtime if desired.
RUN ADMIN_PASSWORD_HASH="$(python scripts/generate_password_hash.py "$ADMIN_PASSWORD")" \
 && echo "ADMIN_PASSWORD_HASH=$ADMIN_PASSWORD_HASH" >> /etc/environment \
 && printf '%s\n' "$ADMIN_PASSWORD_HASH" > /run/admin_password_hash

ENV ADMIN_PASSWORD_HASH=""

EXPOSE 5100

CMD ["sh", "-c", "export ADMIN_PASSWORD_HASH=\"${ADMIN_PASSWORD_HASH:-$(cat /run/admin_password_hash)}\"; exec python app.py"]
