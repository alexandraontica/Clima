import joblib
from predictions_model.model_training.data_processing import load_and_clean_data
from predictions_model.model_training.feature_transformation import transform_features


def predict_apparent_temp(filename):
    model = joblib.load("predictions_model/apparent_temp_prediction_model.pkl")
    pca = joblib.load("predictions_model/pca_transform.pkl")

    df = load_and_clean_data(filename)
    df = transform_features(df)
    df_new_data = df.drop("Apparent Temperature (C)", axis=1, errors="ignore")

    pca_x_new = pca.transform(df_new_data)
    predictions = model.predict(pca_x_new)

    return predictions
