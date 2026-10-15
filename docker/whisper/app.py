import os
import subprocess
from flask import Flask, render_template, request, jsonify, send_from_directory
from flask_socketio import SocketIO, emit

app = Flask(__name__)
app.config["SECRET_KEY"] = "secret!"
socketio = SocketIO(app)

# Ruta base de la imagen Docker
DOCKER_IMAGE = "delarioja/whisper:v1"

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/transcribe", methods=["POST"])
def transcribe():
    folder_path = request.form["folder_path"]
    model = request.form["model"]
    language = request.form["language"]

    # Comando para ejecutar el contenedor
    docker_command = [
        "docker", "run", "--rm",
        "-v", f"{folder_path}:/app/data",
        DOCKER_IMAGE, model, language
    ]

    try:
        # Ejecutar el contenedor y capturar la salida en tiempo real
        process = subprocess.Popen(
            docker_command,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )

        # Leer la salida en tiempo real y enviar actualizaciones al frontend
        for line in process.stdout:
            socketio.emit("progress_update", {"data": line.strip()})

        # Esperar a que termine el proceso
        process.wait()

        # Verificar si hubo errores
        if process.returncode != 0:
            error_message = process.stderr.read()
            return jsonify({"success": False, "error": error_message})

        return jsonify({"success": True, "message": "Transcripción completada"})
    except Exception as e:
        return jsonify({"success": False, "error": str(e)})

@app.route("/download/<filename>")
def download_file(filename):
    folder_path = request.args.get("folder_path")
    return send_from_directory(folder_path, filename, as_attachment=True)

@socketio.on("connect")
def handle_connect():
    emit("progress_update", {"data": "Conectado al servidor"})

if __name__ == "__main__":
    socketio.run(app, host="0.0.0.0", port=5000)

@app.route("/list-files")
def list_files():
    folder_path = request.args.get("folder_path")
    files = [f for f in os.listdir(folder_path) if f.endswith(".txt") or f.endswith(".srt")]
    return jsonify(files)
