import numpy as np
import pandas as pd
from sklearn.preprocessing import FunctionTransformer, StandardScaler


def transform_features(df):
    # through q-q plots and histograms it can be identified that
    # humidity data set is left skewed
    # wind speed data set is right skewed
    # we transform them to have a normal distribution (or closer to one)

    # squre root transformation for wind speed
    sqrt_transformer = FunctionTransformer(np.sqrt, validate=True)
    df["Wind Speed (km/h)"] = sqrt_transformer.transform(
        df[["Wind Speed (km/h)"]].values
    )

    # power transformation with power of 2 for humidity
    power_transformer = FunctionTransformer(lambda x: x**2, validate=True)
    df["Humidity"] = power_transformer.transform(df[["Humidity"]].values)

    # feature encoding
    df["Precip Type"] = df["Precip Type"].astype("category").cat.codes
    encoded_summary = pd.get_dummies(df["Summary"])
    encoded_daily_summary = pd.get_dummies(df["Daily Summary"])
    df = df.join(encoded_summary)
    df = df.join(encoded_daily_summary)
    df = df.drop(columns=["Daily Summary", "Summary"])

    return df


def standardize_data(x_train, x_test, y_train, y_test):
    std_columns = [
        "Temperature (C)",
        "Humidity",
        "Wind Speed (km/h)",
        "Wind Bearing (degrees)",
        "Visibility (km)",
        "Pressure (millibars)",
    ]

    # for feature data
    # we standardize the numerical columns to ensure that they have a mean of 0
    # and a standard deviation of 1, which makes the model perform better
    scaler_train = StandardScaler()
    scaler_train.fit(x_train[std_columns])
    x_train_scaled = scaler_train.transform(x_train[std_columns])
    x_test_scaled = scaler_train.transform(x_test[std_columns])

    # for target data
    scaler_target = StandardScaler()
    scaler_target.fit(y_train)
    y_train_scaled = scaler_target.transform(y_train)
    y_test_scaled = scaler_target.transform(y_test)

    return x_train_scaled, x_test_scaled, y_train_scaled, y_test_scaled
