FROM python:3.9-slim

RUN apt-get update && \
    apt-get install -y tesseract-ocr tesseract-ocr-por && \
    rm -rf /var/lib/apt/lists/*

# Configurar a variável de ambiente TESSDATA_PREFIX
ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/5/tessdata/

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Definir o comando para iniciar a aplicação
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8080"]