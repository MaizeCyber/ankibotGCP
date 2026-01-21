FROM python:3.9-slim
WORKDIR /app
EXPOSE 8080
COPY ankiexpanse ankiexpanse
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/* \
	&& ln -s /usr/bin/python3
RUN pip install --no-cache-dir -r ankiexpanse/requirements.txt
RUN python3 -v
ENV PYTHONPATH="/app"
ENV PORT 8080
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 ankiexpanse.src.app:app