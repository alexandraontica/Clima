# Clima
## Backend

This Flask-based backend is responsible for receiving weather forecast data, transforming it into a structured format, and predicting the apparent temperature using a machine learning model trained with linear regression.

### Features
- Accepts weather forecast data via a POST request in JSON format.
- Transforms the received data into a CSV file using **Pandas**.
- Loads a pre-trained linear regression model to predict the apparent temperature.
- Returns the apparent temperature predictions in JSON format.

### Prerequisites
1. **Python 3.x**
2. **Flask**
3. **Pandas**
4. **Joblib**
5. **Scikit-learn**

Ensure you have the necessary Python packages installed. You can install them via `pip`:

```bash
pip install flask pandas scikit-learn joblib
```

### Running the Backend

1. Ensure that the required Python packages are installed.
2. Run the Flask app:

```bash
python app.py
```

The app will run on `http://0.0.0.0:5000` by default.

### Project Structure

```bash
backend
├── app.py                    # Main Flask application
├── predictions_model/
│   ├── apparent_temp_prediction_model.pkl  # Pre-trained model for apparent temp predictions
│   ├── pca_transform.pkl                   # PCA transformation used in the model
│   ├── predict_apparent_temp.py            # Function used to predict the data
│   └── model_training/                     # Scripts related to model training
│       ├── data_processing.py
│       ├── feature_transformation.py
│       ├── main.py
│       ├── model_evaluation.py
│       └── training data/
│            └── weatherHistory.csv
└── forecast_data.csv          # Temporary file for storing forecast data (created during prediction)
```

### API Endpoint

#### POST `/predict`

This route receives weather forecast data in JSON format, processes it, and returns predictions for the apparent temperature.

##### Request Body (JSON)

The request must contain a list of hourly weather data under the `list` key. Each forecast should contain the following fields:

- `dt`: Unix timestamp (seconds since epoch).
- `main`: An object with:
  - `temp`: Temperature in Celsius.
  - `humidity`: Relative humidity (as a percentage).
  - `pressure`: Atmospheric pressure (in millibars).
- `wind`: An object with:
  - `speed`: Wind speed in meters per second.
  - `deg`: Wind direction in degrees.
- `visibility`: Visibility distance in meters.

**Example:**

```json
{
  "list": [
    {
      "dt": 1633024800,
      "main": {
        "temp": 22.5,
        "humidity": 77,
        "pressure": 1013
      },
      "wind": {
        "speed": 3.5,
        "deg": 180
      },
      "visibility": 10000
    },
    ...
  ]
}
```

##### Response (JSON)

The API responds with a list of predicted apparent temperatures corresponding to the input data points.

**Example:**

```json
{
  "predictions": [21.3, 22.1, 20.8, 21.7]
}
```

### Model Training

The model used for predicting the apparent temperature is based on linear regression with PCA for dimensionality reduction. The model was trained using weather data from the [Szeged Weather dataset](https://www.kaggle.com/datasets/budincsevity/szeged-weather).

#### Training Workflow

1. Load and clean the weather data.
2. Perform feature transformations, including:
   - Normalizing wind speed using a square root transformation.
   - Squaring the humidity to reduce skewness.
3. Standardize the features.
4. Apply PCA to reduce dimensions.
5. Train a linear regression model on the processed data.
6. Evaluate the model using metrics such as MSE, RMSE, and R-squared.

#### Model Evaluation Metrics

- Train set:
  - MSE: X.XX
  - RMSE: X.XX
  - Score: XX%
- Test set:
  - MSE: X.XX
  - RMSE: X.XX
  - Score: XX%

The model and PCA transformation are saved as `.pkl` files and used in the prediction workflow.
