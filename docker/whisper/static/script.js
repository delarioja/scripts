document.addEventListener("DOMContentLoaded", () => {
    const form = document.getElementById("transcribe-form");
    const progressText = document.getElementById("progress-text");
    const fileList = document.getElementById("file-list");
    const folderPathInput = document.getElementById("folder_path");

    // Conectar al servidor WebSocket
    const socket = io();

    // Escuchar actualizaciones de progreso
    socket.on("progress_update", (data) => {
        progressText.textContent += data.data + "\n";
        progressText.scrollTop = progressText.scrollHeight;  // Auto-scroll
    });

    // Enviar el formulario
    form.addEventListener("submit", async (e) => {
        e.preventDefault();

        const formData = new FormData(form);
        const response = await fetch("/transcribe", {
            method: "POST",
            body: formData
        });

        const result = await response.json();

        if (result.success) {
            // Mostrar enlace de descarga para los archivos generados
            const folderPath = folderPathInput.value;
            const files = await fetch(`/list-files?folder_path=${encodeURIComponent(folderPath)}`);
            const fileData = await files.json();

            fileList.innerHTML = "";
            fileData.forEach((file) => {
                const listItem = document.createElement("li");
                const downloadLink = document.createElement("a");
                downloadLink.href = `/download/${file}?folder_path=${encodeURIComponent(folderPath)}`;
                downloadLink.textContent = file;
                downloadLink.download = file;
                listItem.appendChild(downloadLink);
                fileList.appendChild(listItem);
            });
        } else {
            alert(`Error: ${result.error}`);
        }
    });
});
