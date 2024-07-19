# Use uma imagem base com Python
FROM python:3.9-slim

# Instalar Tesseract OCR e dependências necessárias
RUN apt-get update && \
    apt-get install -y tesseract-ocr tesseract-ocr-por && \
    rm -rf /var/lib/apt/lists/*

# Configurar a variável de ambiente TESSDATA_PREFIX
ENV TESSDATA_PREFIX=/usr/share/tesseract-ocr/5/tessdata/

# Definir o diretório de trabalho
WORKDIR /app

# Copiar o arquivo de dependências
COPY requirements.txt requirements.txt

# Instalar dependências Python
RUN pip install --no-cache-dir -r requirements.txt

# Copiar o restante do código da aplicação
COPY . .

# Definir o comando para iniciar a aplicação
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:8080"]