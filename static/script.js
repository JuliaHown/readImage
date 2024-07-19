document.addEventListener('DOMContentLoaded', () => {
    const uploadButton = document.getElementById('uploadButton');
    uploadButton.addEventListener('click', uploadFile);
});

function uploadFile(event) {
    event.preventDefault();

    const formData = new FormData();
    const fileInput = document.getElementById('fileInput');
    if (fileInput.files.length === 0) {
        document.getElementById('result').textContent = 'Por favor, selecione um arquivo.';
        return;
    }

    formData.append('file', fileInput.files[0]);

    fetch('/upload', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.texto) {
            document.getElementById('extractedText').textContent = data.texto;
        } else {
            document.getElementById('extractedText').textContent = 'Erro: ' + (data.error || 'Erro desconhecido');
        }
    })
    .catch(error => {
        document.getElementById('extractedText').textContent = 'Erro: ' + error.message;
    });
}