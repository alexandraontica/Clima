# Clima

This is a **cross-platform Flutter weather app** with a **Flask backend** for making predictions using a **machine learning model**. It identifies the user's current location, fetches current weather data, hourly forecasts, and displays weather information based on the user's location or a specific city.

<video height=600 controls>
  <source src="./readme files/demo.mp4" type="video/mp4">
</video>

[*** Watch a short demo here***](https://drive.google.com/file/d/1zkjNAogObAJCqQ997K6khvL-Vhe288Fp/view?usp=sharing)

## Backend

This Flask-based backend is responsible for receiving weather forecast data, transforming it into a structured format, and **predicting the apparent temperature using a machine learning model trained with linear regression**.

### Features
- Accepts weather forecast data via a POST request in JSON format.
- Transforms the received data into a CSV file using **Pandas**.
- Loads a pre-trained linear regression model to predict the apparent temperature.
- Returns the apparent temperature predictions in JSON format.

### Prerequisites
1. **Python 3**
2. **Flask**
3. **Pandas**
4. **Joblib**
5. **Scikit-learn**

### Running the Backend

1. Ensure that the required Python packages are installed.
```bash
pip install flask pandas scikit-learn joblib
```
2. Run the Flask app.

```bash
cd backend
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
      "dt": 1726001396,
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

The model used for predicting the apparent temperature is based on **linear regression with PCA** for dimensionality reduction. The model was trained using weather data from the [Szeged Weather dataset](https://www.kaggle.com/datasets/budincsevity/szeged-weather).

#### Training Workflow

1. Load and clean the weather data.
2. Perform feature transformations, including:
   - Normalizing wind speed using a square root transformation.
   - Squaring the humidity to reduce skewness.
3. Standardize the features.
4. Apply PCA to reduce dimensions.
5. Train a linear regression model on the processed data.
6. Evaluate the model using metrics such as MSE, RMSE.

#### Model Evaluation Metrics

- Train set:
  - MSE: 1.12,
  - RMSE: 1.06,
  - Score: 99.01%
- Test set:
  - MSE: 1.13,
  - RMSE: 1.06,
  - Score: 98.99%

The model and PCA transformation are saved as `.pkl` files and used in the prediction workflow.


## Frontend
### Features

- Get the user's current location
- Handle location permissions, including errors if permissions are denied.
- Get weather data for the user's current location or a selected city searched by the user.
- Display weather icons, descriptions, and forecast data.
- Display temperature, humidity, wind speed, sunrise, sunset, and weather conditions.
- Fetch apparent temperature predictions from the backend.
- Interactive UI with a clean design for easy navigation.

### Getting Started

#### Prerequisites

- Flutter SDK
- Dart SDK
- Geolocator Plugin: Used for obtaining the user's current location.
- HTTP Package: Used for making network requests.
- Intl Package: Used for timestamp handling and date-time conversions using different timezones.
- Flutter_spinkit Package: Used for the loading animation while the app fetches the necessary data.

#### Running the Frontend

1. Ensure that you have installed Flutter and connected a mobile device or emulator to run the app on.
2. Install dependencies.
```bash
cd frontend
flutter pub get
```
3. Run the Flutter app.
```bash
flutter run
```

### Project Structure

#### Screens Overview

- **Loading Screen (`loading_screen.dart`)**: 
  - Displays a loading indicator while fetching weather data.
  - Responsible for obtaining the user’s current location, weather information and predictions on app start.

- **Location Screen (`location_screen.dart`)**:
  - Displays the current weather for the user's current location.
  - Features:
    - Weather icon, temperature, city name, local time, humidity, wind speed, sunrise time, and sunset time.
    - Button for refetching the user's location and displaying weather data for that location (top right corner).

    <img src="./readme files/location_screen.jpg" height=500 alt="location screen">

- **Forecast Screen (`forecast_screen.dart`)**:
    - Shows hourly weather forecast with the apparent temperature predictions made by the machine learning model.
    - Shows the weather forecast for the coming days.

    <img src="./readme files/forecast_screen.jpg" height=500 alt="forecast screen">

- **City Screen (`city_screen.dart`)**: 
    - Search bar for manually looking up weather data for another city.

    <img src="./readme files/city_screen.jpg" height=500 alt="city screen">

#### Reusable UI Components

- **Additional Info Card (`additional_info_card.dart`)**:
  - A card that displays additional weather information such as wind speed or humidity.

- **Daily Forecast Card (`daily_forecast_card.dart`)**:
  - Displays a weather forecast for a specific day, including the day of the week, weather conditions, and temperature range.

- **Hourly Forecast Card (`hourly_forecast_card.dart`)**:
  - Displays weather information for a specific hour, including temperature, forecast conditions, and the predicted apparent temperature.

- **Image Weather Card (`image_weather_card.dart`)**:
  - Displays current weather conditions along with a background image representing day or night on the main screen (location_screen). Shows current weather data, temperature, apparent temperature, and local time.

- **Navbar (`navbar.dart`)**:
  - Allows the user to navigate between current weather, forecast/predictions, and city search.

#### Services Overview

#### Location Service (`location.dart`)

This service handles:

- Fetching the user's current location using the `Geolocator` package.
- Handling location permissions, including checking whether permissions are granted or denied.
- Error handling for cases where the location services are disabled or permissions are permanently denied.

#### Time Service (`time.dart`)

This service provides time-related utilities:

- Convert UTC timestamps into local time based on a given timezone.
- Format the date and time in human-readable formats.
- Get the local day of the week and time from timestamps.

#### Networking Service (`networking.dart`)

This service handles:

- Making HTTP GET requests to retrieve data from the OpenWeatherMap API.
- Making HTTP POST requests to send data (weather forecasts) to the backend server and retrieve predicted apparent temperatures.
- Decoding JSON responses and returning the data to be used within the app.

#### Weather Service (`weather.dart`)

This service is responsible for:

- Fetching current weather and hourly forecast data from the OpenWeatherMap API.
- Constructing API URLs for both location-based and city-based queries.
- Parsing the weather data, including temperatures, conditions, and weather icons.
- Providing methods to convert raw forecast data into readable weather conditions (e.g., maximum and minimum temperatures, weather conditions).
- Fetching apparent temperature predictions from the Flask backend.
  
### APIs Used

- **OpenWeatherMap API**: Used to fetch real-time weather and forecast data.
- **Flask Backend (localhost)**
