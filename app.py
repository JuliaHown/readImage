from flask import Flask, request, render_template, jsonify
from PIL import Image
import pytesseract
import os

app = Flask(__name__)

# Configurar o caminho para o executável do Tesseract (necessário para Windows)
pytesseract.pytesseract.tesseract_cmd = '/usr/bin/tesseract'

def extrair_texto_da_imagem(caminho_da_imagem):
    imagem = Image.open(caminho_da_imagem)
    texto_extraido = pytesseract.image_to_string(imagem, lang='por')
    return texto_extraido

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/static/<path:filename>')
def static_files(filename):
    return send_from_directory('templates', filename)

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({'error': 'Nenhum arquivo encontrado'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'Nenhum arquivo selecionado'}), 400

    if file:
        upload_folder = 'uploads'
        os.makedirs(upload_folder, exist_ok=True)
        filepath = os.path.join(upload_folder, file.filename)
        try:
            file.save(filepath)
            texto = extrair_texto_da_imagem(filepath)
            return jsonify({'texto': texto})
        except Exception as e:
            return jsonify({'error': f'Erro ao salvar o arquivo: {e}'}), 500

if __name__ == '__main__':
    app.run(debug=True)