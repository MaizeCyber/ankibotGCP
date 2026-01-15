FROM python:3.9
WORKDIR /usr/src/app
EXPOSE 8080
COPY ankiexpanse ankiexpanse
RUN apt install -y python3 \
	&& ln -s /usr/bin/python3
RUN pip install --no-cache-dir -r ankiexpanse/requirements.txt
RUN python3 -v
CMD ["python3", "ankiexpanse/src/app.py"]