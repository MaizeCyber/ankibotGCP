FROM python:3.9-slim
WORKDIR /app
COPY ankiexpanse ankiexpanse
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/* \
	&& ln -s /usr/bin/python3
RUN pip install --no-cache-dir -r ankiexpanse/requirements.txt
RUN python3 -v
ENV PYTHONPATH="/app"
CMD ["python3", "ankiexpanse/src/app.py"]
# Or enter the name of your unique directory and parameter set.