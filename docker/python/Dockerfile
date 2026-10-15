# Utiliza la imagen oficial de Python 3.8
FROM python:3.8

# Establece el directorio de trabajo en /app
WORKDIR /app

# Copia los archivos necesarios al directorio de trabajo
COPY datos.csv /app/datos.csv
COPY valoresapredecir /app/valoresapredecir
COPY linear_regression.py /app/linear_regression.py
COPY requirements.txt /app/requirements.txt

# Instala las dependencias definidas en requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Comando por defecto para ejecutar la aplicación
CMD ["python", "linear_regression.py"]
