FROM python:3.9-slim
WORKDIR /app
COPY ankiexpanse ankiexpanse
RUN apt install -y python3 \
	&& ln -s /usr/bin/python3
RUN pip install --no-cache-dir -r ankiexpanse/requirements.txt
RUN python3 -v
CMD ["python3", "ankiexpanse/src/app.py"]
# Or enter the name of your unique directory and parameter set.