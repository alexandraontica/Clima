from flask import Flask, request, jsonify
from datetime import datetime
import pandas as pd
import os
from predictions_model.predict_apparent_temp import predict_apparent_temp

app = Flask(__name__)


@app.route("/predict", methods=["POST"])
def predict_temp():
    forecast_data_json = request.get_json()

    try:
        forecast_data = forecast_data_json["list"]

        csv_data = {
            "Formatted Date": [],
            "Temperature (C)": [],
            "Humidity": [],
            "Wind Speed (km/h)": [],
            "Wind Bearing (degrees)": [],
            "Visibility (km)": [],
            "Pressure (millibars)": [],
        }

        for forecast in forecast_data:
            csv_data["Formatted Date"].append(datetime.fromtimestamp(forecast["dt"]))
            csv_data["Temperature (C)"].append(forecast["main"]["temp"])
            csv_data["Humidity"].append(forecast["main"]["humidity"] / 100)
            csv_data["Wind Speed (km/h)"].append(forecast["wind"]["speed"] * 3.6)
            csv_data["Wind Bearing (degrees)"].append(forecast["wind"]["deg"])
            csv_data["Visibility (km)"].append(forecast["visibility"] / 1000)
            csv_data["Pressure (millibars)"].append(forecast["main"]["pressure"])

        df = pd.DataFrame(csv_data)

        csv_filename = "forecast_data.csv"
        df.to_csv(csv_filename, index=False)

        predictions = predict_apparent_temp(csv_filename)
        predictions_list = predictions.flatten().tolist()

        return jsonify({"predictions": predictions_list}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        if os.path.exists(csv_filename):
            os.remove(csv_filename)


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0')
