import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression

# Cargar el archivo CSV
data = pd.read_csv('/app/datos.csv')

# Dividir los datos en características (altura) y etiquetas (peso)
X = data.iloc[:, :-1].values.reshape(-1, 1)  # reshape para que sea bidimensional
y = data.iloc[:, -1]

# Dividir los datos en conjuntos de entrenamiento y prueba
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Crear el modelo de regresión lineal
model = LinearRegression()

# Entrenar el modelo
model.fit(X_train, y_train)

# Imprimir los coeficientes del modelo
print('Coeficientes:', model.coef_)
print('Intercept:', model.intercept_)

# Hacer predicciones en el conjunto de prueba
predictions = model.predict(X_test)

# Imprimir las predicciones en el conjunto de prueba
print('\nPredicciones en el conjunto de prueba:')
for i in range(len(X_test)):
    print(f'Altura: {X_test[i][0]}, Predicción de Peso: {predictions[i]:.2f}')

# Hacer predicciones con alturas específicas
new_heights = [[150], [190]]
new_predictions = model.predict(new_heights)

# Imprimir las predicciones específicas
print('\nPredicciones para Alturas específicas:')
for i in range(len(new_heights)):
    print(f'Altura: {new_heights[i][0]}, Predicción de Peso: {new_predictions[i]:.2f}')

# Leer el archivo valoresapredecir
try:
    valores_a_predecir = pd.read_csv('/app/valoresapredecir')
    nuevas_alturas = valores_a_predecir.iloc[:, 0].values.reshape(-1, 1)
    nuevas_predicciones = model.predict(nuevas_alturas)

    # Imprimir las predicciones para las nuevas alturas
    print('\nPredicciones para Nuevas Alturas:')
    for i in range(len(nuevas_alturas)):
        print(f'Altura: {nuevas_alturas[i][0]}, Predicción de Peso: {nuevas_predicciones[i]:.2f}')

except FileNotFoundError:
    print('\nEl archivo "valoresapredecir" no se encontró.')
